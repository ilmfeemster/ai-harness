[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[^/\s]+/[^/\s]+$')]
    [string]$Repo,

    [Parameter(Mandatory = $true)]
    [string]$IssueDirectory
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-FrontMatterDocument {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $content = [System.IO.File]::ReadAllText((Resolve-Path -LiteralPath $Path).Path)
    $match = [regex]::Match(
        $content,
        '\A---\r?\n(?<frontmatter>.*?)\r?\n---\r?\n(?<body>.*)\z',
        [System.Text.RegularExpressions.RegexOptions]::Singleline
    )

    if (-not $match.Success) {
        throw "Issue draft '$Path' is missing valid YAML front matter."
    }

    $metadata = @{}
    foreach ($line in ($match.Groups['frontmatter'].Value -split '\r?\n')) {
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }

        $pair = [regex]::Match($line, '^(?<key>[A-Za-z0-9_]+):\s*"(?<value>.*)"\s*$')
        if (-not $pair.Success) {
            throw "Unsupported front matter line in '$Path': $line"
        }

        $metadata[$pair.Groups['key'].Value] = $pair.Groups['value'].Value
    }

    return [pscustomobject]@{
        Content = $content
        FrontMatter = $match.Groups['frontmatter'].Value
        Body = $match.Groups['body'].Value
        Metadata = $metadata
    }
}

function Assert-RequiredMetadata {
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$Metadata,

        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    foreach ($key in @(
        'title',
        'work_type',
        'readiness',
        'phase',
        'sequence',
        'github_issue_number',
        'github_issue_url'
    )) {
        if (-not $Metadata.ContainsKey($key)) {
            throw "Issue draft '$Path' is missing front matter key '$key'."
        }
    }
}

function Get-MarkdownSection {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Body,

        [Parameter(Mandatory = $true)]
        [string]$Heading
    )

    $pattern = '(?ms)^##\s+' + [regex]::Escape($Heading) + '\s*\r?\n(?<section>.*?)(?=^##\s+|\z)'
    $match = [regex]::Match($Body, $pattern)

    if (-not $match.Success) {
        return $null
    }

    return $match.Groups['section'].Value.Trim()
}

function Set-QuotedFrontMatterValue {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Content,

        [Parameter(Mandatory = $true)]
        [string]$Key,

        [Parameter(Mandatory = $true)]
        [string]$Value
    )

    $escapedValue = $Value.Replace('\', '\\').Replace('"', '\"')
    $pattern = '(?m)^' + [regex]::Escape($Key) + ':\s*".*"\s*$'
    $replacement = $Key + ': "' + $escapedValue + '"'

    if ($Content -notmatch $pattern) {
        throw "Cannot update missing front matter key '$Key'."
    }

    return [regex]::Replace($Content, $pattern, $replacement, 1)
}

function Remove-DuplicateTitleHeading {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Body,

        [Parameter(Mandatory = $true)]
        [string]$Title
    )

    $lines = $Body -split '\r?\n'
    if ($lines.Count -gt 0 -and $lines[0].Trim() -eq "# $Title") {
        $remaining = $lines | Select-Object -Skip 1
        return ($remaining -join [Environment]::NewLine).TrimStart()
    }

    return $Body.Trim()
}

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw "GitHub CLI 'gh' is not installed or is not available on PATH."
}

& gh auth status | Out-Null
if ($LASTEXITCODE -ne 0) {
    throw "GitHub CLI is not authenticated. Run 'gh auth login' before publishing."
}

if (-not (Test-Path -LiteralPath $IssueDirectory -PathType Container)) {
    throw "Issue directory does not exist: $IssueDirectory"
}

$resolvedDirectory = Resolve-Path -LiteralPath $IssueDirectory
$planPath = Join-Path $resolvedDirectory.Path 'README.md'
if (-not (Test-Path -LiteralPath $planPath -PathType Leaf)) {
    throw "Phase plan is missing: $planPath"
}

$planDocument = Get-FrontMatterDocument -Path $planPath
foreach ($key in @('phase', 'roadmap_phase', 'status', 'publication', 'design')) {
    if (-not $planDocument.Metadata.ContainsKey($key)) {
        throw "Phase plan is missing front matter key '$key'."
    }
}

if ($planDocument.Metadata['status'].Trim() -ne 'Approved') {
    throw "Phase plan must have status 'Approved' before publication."
}

if ($planDocument.Metadata['publication'].Trim() -ne 'Not published') {
    throw "Phase plan publication must be 'Not published' before a fresh publication run."
}

$issueFiles = @(
    Get-ChildItem -LiteralPath $resolvedDirectory -File -Filter '*.md' |
        Where-Object { $_.Name -ne 'README.md' } |
        Sort-Object Name
)

if ($issueFiles.Count -eq 0) {
    throw "No Issue draft files were found in '$IssueDirectory'."
}

$existingJson = & gh issue list `
    --repo $Repo `
    --state all `
    --limit 1000 `
    --json number,title,url

if ($LASTEXITCODE -ne 0) {
    throw "Unable to list existing GitHub Issues for duplicate detection."
}

$existingIssues = @()
if (-not [string]::IsNullOrWhiteSpace(($existingJson -join ''))) {
    $existingIssues = @(($existingJson -join [Environment]::NewLine) | ConvertFrom-Json)
}

$validatedDrafts = New-Object System.Collections.Generic.List[object]
$seenTitles = @{}

foreach ($file in $issueFiles) {
    $document = Get-FrontMatterDocument -Path $file.FullName
    Assert-RequiredMetadata -Metadata $document.Metadata -Path $file.FullName

    $title = $document.Metadata['title'].Trim()
    $readiness = $document.Metadata['readiness'].Trim()
    $workType = $document.Metadata['work_type'].Trim()
    $phase = $document.Metadata['phase'].Trim()
    $sequence = $document.Metadata['sequence'].Trim()
    $issueNumber = $document.Metadata['github_issue_number'].Trim()
    $issueUrl = $document.Metadata['github_issue_url'].Trim()

    if ([string]::IsNullOrWhiteSpace($title) -or $title -match '^\[') {
        throw "Issue draft '$($file.Name)' has an unresolved title."
    }

    $allowedWorkTypes = @(
        'Feature',
        'Refactor',
        'Documentation',
        'Infrastructure',
        'Test improvement',
        'Maintenance',
        'Other'
    )

    if ($allowedWorkTypes -notcontains $workType) {
        throw "Issue draft '$($file.Name)' uses unsupported work_type '$workType'."
    }

    if ([string]::IsNullOrWhiteSpace($phase) -or $phase -match '^\[') {
        throw "Issue draft '$($file.Name)' has unresolved phase metadata."
    }

    if ($sequence -notmatch '^\d{2,}$') {
        throw "Issue draft '$($file.Name)' has invalid sequence metadata '$sequence'."
    }

    if ($file.BaseName -notmatch ('^' + [regex]::Escape($sequence) + '-')) {
        throw "Issue draft '$($file.Name)' does not match sequence metadata '$sequence'."
    }

    if ($phase -ne $planDocument.Metadata['phase'].Trim()) {
        throw "Issue draft '$($file.Name)' phase '$phase' does not match the phase plan."
    }

    if ($seenTitles.ContainsKey($title)) {
        throw "Multiple local Issue drafts use the same title '$title'."
    }
    $seenTitles[$title] = $true

    if ($readiness -ne 'Ready') {
        throw "Issue draft '$($file.Name)' is not Ready. Current readiness: '$readiness'."
    }

    if (-not [string]::IsNullOrWhiteSpace($issueNumber) -or
        -not [string]::IsNullOrWhiteSpace($issueUrl)) {
        throw "Issue draft '$($file.Name)' already contains GitHub publication metadata."
    }

    foreach ($heading in @(
        'Work type',
        'Goal',
        'Context',
        'Scope',
        'Non-goals',
        'Acceptance criteria',
        'Dependencies',
        'Relevant project documents',
        'Readiness'
    )) {
        if ($null -eq (Get-MarkdownSection -Body $document.Body -Heading $heading)) {
            throw "Issue draft '$($file.Name)' is missing required section '## $heading'."
        }
    }

    $readinessSection = Get-MarkdownSection -Body $document.Body -Heading 'Readiness'
    if ($readinessSection -match '(?m)^-\s+\[\s\]') {
        throw "Issue draft '$($file.Name)' has unchecked readiness confirmations."
    }

    $placeholderPatterns = @(
        '\[Issue title\]',
        '\[Select one work type[^\]]*\]',
        '\[State one singular[^\]]*\]',
        '\[Explain why[^\]]*\]',
        '\[Included outcome[^\]]*\]',
        '\[Related work[^\]]*\]',
        '\[Later-phase[^\]]*\]',
        '\[Observable condition[^\]]*\]',
        '\[Name satisfied prerequisites[^\]]*\]',
        '\[Add approved design[^\]]*\]'
    )

    foreach ($placeholderPattern in $placeholderPatterns) {
        if ($document.Body -match $placeholderPattern) {
            throw "Issue draft '$($file.Name)' contains an unresolved template placeholder."
        }
    }

    $duplicate = $existingIssues |
        Where-Object { $_.title.Trim() -eq $title } |
        Select-Object -First 1

    if ($null -ne $duplicate) {
        throw "An existing GitHub Issue already has the exact title '$title': $($duplicate.url)"
    }

    [void]$validatedDrafts.Add([pscustomobject]@{
        File = $file
        Document = $document
        Title = $title
    })
}

Write-Host "Preflight passed for $($validatedDrafts.Count) Issue draft(s)."
Write-Host "Repository: $Repo"
Write-Host "Directory: $($resolvedDirectory.Path)"

$created = New-Object System.Collections.Generic.List[object]

foreach ($draft in $validatedDrafts) {
    $tempBody = [System.IO.Path]::GetTempFileName()

    try {
        $body = Remove-DuplicateTitleHeading `
            -Body $draft.Document.Body `
            -Title $draft.Title

        [System.IO.File]::WriteAllText($tempBody, $body)

        if (-not $PSCmdlet.ShouldProcess(
            "$Repo — $($draft.Title)",
            'Create GitHub Issue and update local publication metadata'
        )) {
            continue
        }

        $issueUrlOutput = & gh issue create `
            --repo $Repo `
            --title $draft.Title `
            --body-file $tempBody

        if ($LASTEXITCODE -ne 0) {
            throw "GitHub Issue creation failed for '$($draft.Title)'."
        }

        $url = ($issueUrlOutput | Select-Object -Last 1).Trim()
        $urlMatch = [regex]::Match($url, '/issues/(?<number>\d+)(?:\?.*)?$')
        if (-not $urlMatch.Success) {
            throw "Created Issue URL could not be parsed for '$($draft.Title)': $url"
        }

        $number = $urlMatch.Groups['number'].Value
        $updatedContent = Set-QuotedFrontMatterValue `
            -Content $draft.Document.Content `
            -Key 'github_issue_number' `
            -Value $number

        $updatedContent = Set-QuotedFrontMatterValue `
            -Content $updatedContent `
            -Key 'github_issue_url' `
            -Value $url

        [System.IO.File]::WriteAllText($draft.File.FullName, $updatedContent)

        [void]$created.Add([pscustomobject]@{
            Number = $number
            Title = $draft.Title
            Url = $url
            File = $draft.File.FullName
        })

        Write-Host "Created #$number — $($draft.Title)"
    }
    catch {
        Write-Error "Publication stopped after $($created.Count) successful creation(s). $($_.Exception.Message)"
        if ($created.Count -gt 0) {
            $partialPlan = Set-QuotedFrontMatterValue `
                -Content $planDocument.Content `
                -Key 'publication' `
                -Value 'Partial'
            [System.IO.File]::WriteAllText($planPath, $partialPlan)

            Write-Host 'Created before failure:'
            $created | Format-Table Number, Title, Url
        }
        throw
    }
    finally {
        Remove-Item -LiteralPath $tempBody -Force -ErrorAction SilentlyContinue
    }
}

if ($WhatIfPreference) {
    Write-Host 'WhatIf completed. No GitHub Issues or local metadata were changed.'
}
else {
    $publishedPlan = Set-QuotedFrontMatterValue `
        -Content $planDocument.Content `
        -Key 'status' `
        -Value 'Published'

    $publishedPlan = Set-QuotedFrontMatterValue `
        -Content $publishedPlan `
        -Key 'publication' `
        -Value 'Published'

    [System.IO.File]::WriteAllText($planPath, $publishedPlan)

    Write-Host "Publication completed. Created $($created.Count) Issue(s)."
    $created | Format-Table Number, Title, Url
    Write-Host "Updated phase plan metadata: $planPath"
}
