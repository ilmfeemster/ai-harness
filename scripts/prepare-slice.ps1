[CmdletBinding(DefaultParameterSetName = 'Issue')]
param(
    [Parameter(ParameterSetName = 'Issue')]
    [ValidateRange(1, [int]::MaxValue)]
    [int]$IssueNumber,

    [Parameter(ParameterSetName = 'Issue')]
    [string]$IssueJsonPath,

    [Parameter(ParameterSetName = 'ContextManifest')]
    [switch]$ContextManifest,

    [Parameter(ParameterSetName = 'ContextManifest')]
    [string]$NormalizedIssueJsonPath,

    [Parameter(ParameterSetName = 'ContextManifest')]
    [string]$RepositoryRoot,

    [Parameter(ParameterSetName = 'ContextManifest')]
    [string]$ManifestOutputRoot,

    [switch]$NoRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:ManifestToolVersion = 'phase-1-context-manifest/1'

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
        throw "Issue body is missing required section '## $Heading'."
    }

    $value = $match.Groups['section'].Value.Trim()
    if ([string]::IsNullOrWhiteSpace($value)) {
        throw "Issue section '## $Heading' is empty."
    }

    return $value
}

function Get-ReadinessConfirmations {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ReadinessSection
    )

    $matches = [regex]::Matches($ReadinessSection, '(?m)^-\s+\[(?<checked>[ xX])\]\s+(?<label>.+?)\s*$')
    if ($matches.Count -eq 0) {
        throw "Issue section '## Readiness' does not contain checkbox confirmations."
    }

    return @($matches | ForEach-Object {
        [pscustomobject]@{
            Label = $_.Groups['label'].Value.Trim()
            Checked = $_.Groups['checked'].Value -match '[xX]'
        }
    })
}

function Get-IssueSnapshotFromGitHub {
    param(
        [Parameter(Mandatory = $true)]
        [int]$Number
    )

    if ($null -eq (Get-Command gh -ErrorAction SilentlyContinue)) {
        throw "GitHub CLI 'gh' is required to read Issue #$Number."
    }

    $json = & gh issue view $Number --json number,title,url,state,body
    if ($LASTEXITCODE -ne 0) {
        throw "Unable to read GitHub Issue #$Number. Verify GitHub CLI authentication, repository context, and Issue access."
    }

    try {
        return ($json | ConvertFrom-Json)
    }
    catch {
        throw "GitHub Issue #$Number returned unreadable JSON. $($_.Exception.Message)"
    }
}

function Get-IssueSnapshotFromFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Issue fixture file does not exist: $Path"
    }

    try {
        return (Get-Content -Raw -LiteralPath $Path | ConvertFrom-Json)
    }
    catch {
        throw "Issue fixture file contains unreadable JSON: $Path. $($_.Exception.Message)"
    }
}

function Get-NormalizedIssue {
    param(
        [Parameter(Mandatory = $true)]
        [psobject]$Snapshot
    )

    foreach ($property in @('number', 'title', 'url', 'state', 'body')) {
        if ($null -eq $Snapshot.PSObject.Properties[$property] -or [string]::IsNullOrWhiteSpace([string]$Snapshot.$property)) {
            throw "Issue snapshot is missing required property '$property'."
        }
    }

    if ([string]$Snapshot.state -ne 'OPEN') {
        throw "GitHub Issue #$($Snapshot.number) is not open. Current state: $($Snapshot.state)."
    }

    $body = [string]$Snapshot.body
    $isImplementation = $body -match '(?m)^##\s+(Work type|Goal)\s*$'
    $isBug = $body -match '(?m)^##\s+(Summary|Observed behavior|Expected behavior)\s*$'
    if ($isImplementation -eq $isBug) {
        throw 'Issue body does not match exactly one supported implementation or bug form.'
    }

    $readiness = Get-ReadinessConfirmations -ReadinessSection (Get-MarkdownSection -Body $body -Heading 'Readiness')
    $source = [pscustomobject]@{
        Number = [int]$Snapshot.number
        Title = [string]$Snapshot.title
        Url = [string]$Snapshot.url
        State = [string]$Snapshot.state
        UnparsedBody = $body
    }

    if ($isImplementation) {
        return [pscustomobject]@{
            SchemaVersion = 1
            IssueType = 'Implementation'
            Source = $source
            WorkType = Get-MarkdownSection -Body $body -Heading 'Work type'
            Goal = Get-MarkdownSection -Body $body -Heading 'Goal'
            Context = Get-MarkdownSection -Body $body -Heading 'Context'
            Scope = Get-MarkdownSection -Body $body -Heading 'Scope'
            NonGoals = Get-MarkdownSection -Body $body -Heading 'Non-goals'
            AcceptanceCriteria = Get-MarkdownSection -Body $body -Heading 'Acceptance criteria'
            Dependencies = Get-MarkdownSection -Body $body -Heading 'Dependencies'
            RelevantDocuments = Get-MarkdownSection -Body $body -Heading 'Relevant project documents'
            Readiness = @($readiness)
            Bug = $null
        }
    }

    $summary = Get-MarkdownSection -Body $body -Heading 'Summary'
    $observed = Get-MarkdownSection -Body $body -Heading 'Observed behavior'
    $expected = Get-MarkdownSection -Body $body -Heading 'Expected behavior'
    $evidence = Get-MarkdownSection -Body $body -Heading 'Reproduction or evidence'
    $impact = Get-MarkdownSection -Body $body -Heading 'Impact'

    return [pscustomobject]@{
        SchemaVersion = 1
        IssueType = 'Bug'
        Source = $source
        WorkType = 'Bug'
        Goal = "Correct: $expected"
        Context = "Summary: $summary`n`nObserved behavior:`n$observed`n`nImpact:`n$impact"
        Scope = Get-MarkdownSection -Body $body -Heading 'Fix scope'
        NonGoals = Get-MarkdownSection -Body $body -Heading 'Non-goals'
        AcceptanceCriteria = Get-MarkdownSection -Body $body -Heading 'Acceptance criteria'
        Dependencies = Get-MarkdownSection -Body $body -Heading 'Dependencies'
        RelevantDocuments = Get-MarkdownSection -Body $body -Heading 'Relevant project documents'
        Readiness = @($readiness)
        Bug = [pscustomobject]@{
            Summary = $summary
            ObservedBehavior = $observed
            ExpectedBehavior = $expected
            Evidence = $evidence
            Impact = $impact
        }
    }
}

function Invoke-IssueNormalization {
    param(
        [int]$Number,
        [string]$FixturePath
    )

    if ($Number -gt 0 -and -not [string]::IsNullOrWhiteSpace($FixturePath)) {
        throw 'Specify either IssueNumber or IssueJsonPath, not both.'
    }

    if ($Number -le 0 -and [string]::IsNullOrWhiteSpace($FixturePath)) {
        throw 'Specify an explicit IssueNumber for GitHub or IssueJsonPath for a local deterministic fixture.'
    }

    $snapshot = if ($Number -gt 0) {
        Get-IssueSnapshotFromGitHub -Number $Number
    }
    else {
        Get-IssueSnapshotFromFile -Path $FixturePath
    }

    return Get-NormalizedIssue -Snapshot $snapshot
}

function Test-NormalizedIssueProperty {
    param(
        [Parameter(Mandatory = $true)]
        [psobject]$Object,

        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    if ($null -eq $Object.PSObject.Properties[$Name]) {
        return $false
    }
    if ($Name -eq 'Readiness') {
        return @($Object.$Name).Count -gt 0
    }
    return -not [string]::IsNullOrWhiteSpace([string]$Object.$Name)
}

function Assert-NormalizedIssueContract {
    param(
        [Parameter(Mandatory = $true)]
        [psobject]$NormalizedIssue
    )

    foreach ($property in @('Source', 'Goal', 'Context', 'Scope', 'NonGoals', 'AcceptanceCriteria', 'Dependencies', 'RelevantDocuments', 'Readiness')) {
        if (-not (Test-NormalizedIssueProperty -Object $NormalizedIssue -Name $property)) {
            throw "Normalized Issue contract is missing required property '$property'."
        }
    }

    foreach ($property in @('Number', 'Title', 'Url')) {
        if (-not (Test-NormalizedIssueProperty -Object $NormalizedIssue.Source -Name $property)) {
            throw "Normalized Issue contract source is missing required property '$property'."
        }
    }

    if ([int]$NormalizedIssue.Source.Number -le 0) {
        throw 'Normalized Issue contract source number must be positive.'
    }
}

function Get-NormalizedIssueContractFromFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Normalized Issue contract file does not exist: $Path"
    }

    try {
        $contract = Get-Content -Raw -LiteralPath $Path | ConvertFrom-Json
    }
    catch {
        throw "Normalized Issue contract contains unreadable JSON: $Path. $($_.Exception.Message)"
    }

    Assert-NormalizedIssueContract -NormalizedIssue $contract
    return $contract
}

function Get-RelevantDocumentPaths {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RelevantDocuments
    )

    $records = @()
    $seen = @{}
    foreach ($line in ($RelevantDocuments -split '\r?\n')) {
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }

        $original = $line.Trim()
        $entry = [regex]::Replace($original, '^\s*[-*+]\s*', '').Trim()
        $path = $null
        $backtick = [regex]::Match($entry, '`(?<path>[^`]+)`')
        if ($backtick.Success) {
            $path = $backtick.Groups['path'].Value.Trim()
        }
        elseif ($entry -notmatch '\s' -and $entry -match '(^[^/\\\s]+\.[^/\\\s]+$|^[^/\\\s]+(?:[/\\][^/\\\s]+)+$)') {
            $path = $entry
        }

        $reason = $null
        $accepted = $false
        if ([string]::IsNullOrWhiteSpace($path)) {
            $reason = 'entry is not a single relative file path or complete backticked path'
        }
        else {
            $path = $path.Replace('\', '/')
            $segments = $path -split '/'
            if ($path -match '^(?:[a-z][a-z0-9+.-]*:|/|\\)' -or $segments -contains '..') {
                $reason = 'path is rooted, drive-qualified, a URL, or contains a parent traversal segment'
                $path = $null
            }
            elseif ($path -match '^(?:https?|ftp)://') {
                $reason = 'external URLs are outside the local repository boundary'
                $path = $null
            }
        }

        if ($null -eq $path) {
            $records += [pscustomobject]@{
                Path = $null
                Original = $original
                Classification = 'Rejected'
                Reason = $reason
                Accepted = $false
            }
            continue
        }

        $key = $path.ToLowerInvariant()
        if ($seen.ContainsKey($key)) {
            $records += [pscustomobject]@{
                Path = $path
                Original = $original
                Classification = 'Duplicate'
                Reason = 'duplicate path ignored; first occurrence retained'
                Accepted = $false
            }
            continue
        }

        $seen[$key] = $true
        $records += [pscustomobject]@{
            Path = $path
            Original = $original
            Classification = 'Accepted'
            Reason = $null
            Accepted = $true
        }
    }

    return @($records)
}

function Get-SafeManifestText {
    param(
        [AllowNull()]
        [string]$Value
    )

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return '[omitted]'
    }

    if ($Value -match '(?i)\b(?:token|secret|password|credential|api[_ -]?key|bearer)\b') {
        return '[sensitive entry redacted]'
    }

    if ($Value -match '^(?i)(?:https?|ftp)://') {
        return '[external URL omitted]'
    }

    if ($Value -match '^(?:[a-zA-Z]:[\\/]|[\\/])') {
        return '[rooted path omitted]'
    }

    $safe = $Value.Replace('|', '\|').Replace("`r", ' ').Replace("`n", ' ')
    if ($safe.Length -gt 200) {
        return $safe.Substring(0, 200) + '...'
    }
    return $safe
}

function New-ContextNotice {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Category,

        [AllowNull()]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [string]$Message,

        [AllowNull()]
        [string]$Original
    )

    [pscustomobject]@{
        Category = $Category
        Path = if ([string]::IsNullOrWhiteSpace($Path)) { $null } else { $Path }
        Reference = if ([string]::IsNullOrWhiteSpace($Original)) { $null } else { Get-SafeManifestText -Value $Original }
        Message = $Message
    }
}

function Get-ContextFileText {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RepositoryRoot,

        [Parameter(Mandatory = $true)]
        [string]$RelativePath,

        [AllowNull()]
        [scriptblock]$FileReader
    )

    $fullPath = Join-Path $RepositoryRoot ($RelativePath.Replace('/', [IO.Path]::DirectorySeparatorChar))
    if ($null -ne $FileReader) {
        return [string](& $FileReader $fullPath)
    }

    if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
        throw 'file is missing or inaccessible'
    }

    return Get-Content -Raw -LiteralPath $fullPath
}

function Get-ContextFileStatus {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RepositoryRoot,

        [Parameter(Mandatory = $true)]
        [string]$RelativePath,

        [AllowNull()]
        [scriptblock]$FileReader
    )

    try {
        $content = Get-ContextFileText -RepositoryRoot $RepositoryRoot -RelativePath $RelativePath -FileReader $FileReader
        return [pscustomobject]@{
            Available = $true
            Content = $content
        }
    }
    catch {
        return [pscustomobject]@{
            Available = $false
            Content = $null
        }
    }
}

function Test-AllowedLinkedPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $lower = $Path.ToLowerInvariant()
    return $lower -eq 'agents.md' -or
        $lower -eq 'readme.md' -or
        $lower.StartsWith('docs/') -or
        $lower.StartsWith('templates/') -or
        $lower.StartsWith('.github/issue_template/')
}

function Get-FrontMatterValue {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Content,

        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    $match = [regex]::Match($Content, '(?ms)^---\s*\r?\n(?<front>.*?)(?:\r?\n)---\s*(?:\r?\n|$)')
    if (-not $match.Success) {
        return $null
    }

    $value = [regex]::Match($match.Groups['front'].Value, '(?m)^\s*' + [regex]::Escape($Name) + '\s*:\s*["'']?(?<value>[^"''\r\n]+)["'']?\s*$')
    if (-not $value.Success) {
        return $null
    }
    return $value.Groups['value'].Value.Trim()
}

function Get-DesignStatus {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Content
    )

    $match = [regex]::Match($Content, '(?ms)^##\s+Status\s*\r?\n(?<section>.*?)(?=^##\s+|\z)')
    if (-not $match.Success) {
        return $null
    }

    foreach ($line in ($match.Groups['section'].Value -split '\r?\n')) {
        if (-not [string]::IsNullOrWhiteSpace($line)) {
            $value = $line.Trim().TrimStart('*').Trim()
            if ($value -match '(?i)^approved$') { return 'Approved' }
            if ($value -match '(?i)^draft$') { return 'Draft' }
            return $value
        }
    }
    return $null
}

function Get-ActivePhaseMetadata {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProjectContent
    )

    $currentPhase = $null
    $phaseMatch = [regex]::Match($ProjectContent, '(?ms)^##\s+Current phase\s*\r?\n(?<section>.*?)(?=^##\s+|\z)')
    if ($phaseMatch.Success) {
        $phaseNumber = [regex]::Match($phaseMatch.Groups['section'].Value, '(?i)\bphase\s*[- ]?(?<number>\d+)\b')
        if ($phaseNumber.Success) {
            $currentPhase = 'phase-' + $phaseNumber.Groups['number'].Value
        }
    }

    $expected = $null
    $expectedMatch = [regex]::Match($ProjectContent, '(?mi)^\s*-\s*\*\*Expected design:\*\*\s*(?<path>`[^`]+`|[^\s]+)')
    if ($expectedMatch.Success) {
        $expected = $expectedMatch.Groups['path'].Value.Trim('`').Replace('\', '/')
    }

    [pscustomobject]@{
        ActivePhase = $currentPhase
        ExpectedDesign = $expected
    }
}

function Test-ExactPhaseIssueMapping {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RepositoryRoot,

        [Parameter(Mandatory = $true)]
        [int]$IssueNumber,

        [Parameter(Mandatory = $true)]
        [string]$ActivePhase
    )

    if ([string]::IsNullOrWhiteSpace($ActivePhase)) {
        return $false
    }

    $issuesRoot = Join-Path $RepositoryRoot 'docs/issues'
    if (-not (Test-Path -LiteralPath $issuesRoot -PathType Container)) {
        return $false
    }

    foreach ($phaseDirectory in @(Get-ChildItem -LiteralPath $issuesRoot -Directory | Sort-Object Name)) {
        foreach ($draft in @(Get-ChildItem -LiteralPath $phaseDirectory.FullName -File -Filter '*.md' | Sort-Object Name)) {
            try {
                $content = Get-Content -Raw -LiteralPath $draft.FullName
            }
            catch {
                continue
            }
            $number = Get-FrontMatterValue -Content $content -Name 'github_issue_number'
            $phase = Get-FrontMatterValue -Content $content -Name 'phase'
            $readiness = Get-FrontMatterValue -Content $content -Name 'readiness'
            if ($number -eq [string]$IssueNumber -and $phase -eq $ActivePhase -and $readiness -eq 'Ready') {
                return $true
            }
        }
    }
    return $false
}

function Get-ContextCandidates {
    param(
        [Parameter(Mandatory = $true)]
        [psobject]$NormalizedIssue,

        [Parameter(Mandatory = $true)]
        [string]$RepositoryRoot,

        [AllowNull()]
        [scriptblock]$FileReader
    )

    Assert-NormalizedIssueContract -NormalizedIssue $NormalizedIssue
    $root = (Resolve-Path -LiteralPath $RepositoryRoot).Path
    $mandatoryPaths = @('AGENTS.md', 'docs/project.md', 'docs/architecture.md', 'docs/decisions.md', 'docs/testing.md', 'docs/current-slice.md')
    $mandatory = @()
    $linked = @()
    $designs = @()
    $warnings = @()
    $blockers = @()

    foreach ($path in $mandatoryPaths) {
        $status = Get-ContextFileStatus -RepositoryRoot $root -RelativePath $path -FileReader $FileReader
        $mandatory += [pscustomobject]@{
            Path = $path
            Category = 'Mandatory authority'
            Available = $status.Available
            Reason = 'mandatory authority'
        }
        if (-not $status.Available) {
            $blockers += New-ContextNotice -Category 'Mandatory authority' -Path $path -Message 'mandatory authority is missing or inaccessible; restore the file before preparing context.'
        }
    }

    $references = Get-RelevantDocumentPaths -RelevantDocuments ([string]$NormalizedIssue.RelevantDocuments)
    $linkedDesignPaths = @()
    foreach ($reference in $references) {
        if (-not $reference.Accepted) {
            $warnings += New-ContextNotice -Category 'Issue-linked document' -Path $reference.Path -Original $reference.Original -Message $reference.Reason
            continue
        }

        if (-not (Test-AllowedLinkedPath -Path $reference.Path)) {
            $warnings += New-ContextNotice -Category 'Issue-linked document' -Path $reference.Path -Original $reference.Original -Message 'linked path is outside the bounded local-document set and was excluded.'
            continue
        }

        $isDesign = $reference.Path.ToLowerInvariant().StartsWith('docs/design/') -and $reference.Path.ToLowerInvariant().EndsWith('.md')
        $status = Get-ContextFileStatus -RepositoryRoot $root -RelativePath $reference.Path -FileReader $FileReader
        $linked += [pscustomobject]@{
            Path = $reference.Path
            Category = 'Issue-linked document'
            Available = $status.Available
            IsDesign = $isDesign
            Reason = 'linked by source Issue'
        }
        if ($isDesign) {
            $linkedDesignPaths += $reference.Path
        }
        if (-not $status.Available) {
            $blockers += New-ContextNotice -Category 'Issue-linked document' -Path $reference.Path -Message 'linked local document is missing or inaccessible; restore the path before preparing context.'
        }
    }

    $projectStatus = Get-ContextFileStatus -RepositoryRoot $root -RelativePath 'docs/project.md' -FileReader $FileReader
    $phaseMetadata = if ($projectStatus.Available) { Get-ActivePhaseMetadata -ProjectContent $projectStatus.Content } else { [pscustomobject]@{ ActivePhase = $null; ExpectedDesign = $null } }
    $mappedExpectedDesign = Test-ExactPhaseIssueMapping -RepositoryRoot $root -IssueNumber ([int]$NormalizedIssue.Source.Number) -ActivePhase $phaseMetadata.ActivePhase

    $designRoot = Join-Path $root 'docs/design'
    if (Test-Path -LiteralPath $designRoot -PathType Container) {
        foreach ($designFile in @(Get-ChildItem -LiteralPath $designRoot -File -Filter '*.md' | Sort-Object Name)) {
            $designPath = $designFile.Name
            $relativeDesignPath = 'docs/design/' + $designPath
            $designStatus = Get-ContextFileStatus -RepositoryRoot $root -RelativePath $relativeDesignPath -FileReader $FileReader
            $status = if ($designStatus.Available) { Get-DesignStatus -Content $designStatus.Content } else { $null }
            $explicit = @($linkedDesignPaths | Where-Object { $_.ToLowerInvariant() -eq $relativeDesignPath.ToLowerInvariant() }).Count -gt 0
            $expected = -not [string]::IsNullOrWhiteSpace($phaseMetadata.ExpectedDesign) -and $phaseMetadata.ExpectedDesign.ToLowerInvariant() -eq $relativeDesignPath.ToLowerInvariant()
            $selected = $false
            $reason = $null

            if ($status -eq 'Approved' -and $explicit) {
                $selected = $true
                $reason = 'approved design linked by source Issue'
            }
            elseif ($status -eq 'Approved' -and $expected -and $mappedExpectedDesign) {
                $selected = $true
                $reason = 'approved active-phase design; Assumption A-1'
                $warnings += New-ContextNotice -Category 'Design applicability' -Path $relativeDesignPath -Message 'Assumption A-1 selected the active expected design; human review is required.'
            }
            elseif ($status -eq 'Approved' -and $expected) {
                $reason = 'active expected design has no exact Issue-to-phase mapping; excluded from governing context'
                $warnings += New-ContextNotice -Category 'Design applicability' -Path $relativeDesignPath -Message 'Assumption A-1 evidence is incomplete; active expected design was not selected.'
            }
            elseif ($status -eq 'Approved') {
                $reason = 'approved design is unlinked; no explicit link establishes governing relevance'
                $warnings += New-ContextNotice -Category 'Design applicability' -Path $relativeDesignPath -Message 'unlinked approved design remains non-governing because no explicit relevance evidence exists.'
            }
            elseif ($status -eq 'Draft') {
                $reason = 'Draft design is never governing'
                $warnings += New-ContextNotice -Category 'Design status' -Path $relativeDesignPath -Message 'Draft design was recorded as a candidate but excluded from governing context.'
            }
            else {
                $reason = 'design status is missing or unrecognized; candidate excluded'
                $warnings += New-ContextNotice -Category 'Design status' -Path $relativeDesignPath -Message 'design status is missing or unrecognized; candidate was excluded from governing context.'
            }

            $designs += [pscustomobject]@{
                Path = $relativeDesignPath
                Status = $status
                ExplicitlyLinked = $explicit
                ActiveExpected = $expected
                Selected = $selected
                Reason = $reason
            }
        }
    }

    if (-not [string]::IsNullOrWhiteSpace($phaseMetadata.ExpectedDesign) -and
        -not (Test-Path -LiteralPath (Join-Path $root ($phaseMetadata.ExpectedDesign.Replace('/', [IO.Path]::DirectorySeparatorChar))) -PathType Leaf)) {
        $warnings += New-ContextNotice -Category 'Design applicability' -Path $phaseMetadata.ExpectedDesign -Message 'active phase expected design is absent; no design candidate can govern through Assumption A-1.'
    }

    [pscustomobject]@{
        Mandatory = @($mandatory)
        Linked = @($linked)
        Designs = @($designs)
        Warnings = @($warnings)
        Blockers = @($blockers)
        ActivePhase = $phaseMetadata.ActivePhase
        ExpectedDesign = $phaseMetadata.ExpectedDesign
    }
}

function Get-ReadinessSummary {
    param(
        [Parameter(Mandatory = $true)]
        [psobject]$NormalizedIssue
    )

    $readiness = @($NormalizedIssue.Readiness)
    $checked = @($readiness | Where-Object { $_.Checked }).Count
    return "$checked of $($readiness.Count) readiness confirmations checked."
}

function Resolve-ContextManifest {
    param(
        [Parameter(Mandatory = $true)]
        [psobject]$NormalizedIssue,

        [Parameter(Mandatory = $true)]
        [string]$RepositoryRoot,

        [string]$OutputPath,

        [AllowNull()]
        [scriptblock]$FileReader
    )

    Assert-NormalizedIssueContract -NormalizedIssue $NormalizedIssue
    $candidates = Get-ContextCandidates -NormalizedIssue $NormalizedIssue -RepositoryRoot $RepositoryRoot -FileReader $FileReader
    $selected = @()
    $considered = @()
    $selectedPaths = @{}
    $designPaths = @($candidates.Designs | ForEach-Object { $_.Path.ToLowerInvariant() })

    foreach ($mandatory in $candidates.Mandatory) {
        if ($mandatory.Available) {
            $selected += [pscustomobject]@{
                Path = $mandatory.Path
                Category = $mandatory.Category
                Reason = $mandatory.Reason
            }
            $selectedPaths[$mandatory.Path.ToLowerInvariant()] = $true
        }
    }

    foreach ($linked in $candidates.Linked) {
        if ($linked.Available -and -not $linked.IsDesign -and -not $selectedPaths.ContainsKey($linked.Path.ToLowerInvariant())) {
            $selected += [pscustomobject]@{
                Path = $linked.Path
                Category = $linked.Category
                Reason = $linked.Reason
            }
            $selectedPaths[$linked.Path.ToLowerInvariant()] = $true
        }
        elseif (-not $linked.Available -or ($linked.IsDesign -and $designPaths -notcontains $linked.Path.ToLowerInvariant())) {
            $considered += [pscustomobject]@{
                Path = $linked.Path
                Category = $linked.Category
                Status = if ($linked.IsDesign) { 'Design candidate' } else { 'Unavailable' }
                Reason = if ($linked.IsDesign) { 'design selection is governed by Approved status and explicit applicability' } else { 'missing or inaccessible linked document' }
            }
        }
    }

    foreach ($design in @($candidates.Designs | Sort-Object Path)) {
        if ($design.Selected) {
            if (-not $selectedPaths.ContainsKey($design.Path.ToLowerInvariant())) {
                $selected += [pscustomobject]@{
                    Path = $design.Path
                    Category = 'Approved design'
                    Reason = $design.Reason
                }
                $selectedPaths[$design.Path.ToLowerInvariant()] = $true
            }
        }
        else {
            $considered += [pscustomobject]@{
                Path = $design.Path
                Category = 'Design candidate'
                Status = if ([string]::IsNullOrWhiteSpace($design.Status)) { 'Missing or unrecognized' } else { $design.Status }
                Reason = $design.Reason
            }
        }
    }

    [pscustomobject]@{
        PreparationTimestamp = (Get-Date).ToUniversalTime().ToString('o')
        ToolVersion = $script:ManifestToolVersion
        Source = [pscustomobject]@{
            Number = [int]$NormalizedIssue.Source.Number
            Title = [string]$NormalizedIssue.Source.Title
            Url = [string]$NormalizedIssue.Source.Url
            SnapshotIdentifier = if ($null -ne $NormalizedIssue.Source.PSObject.Properties['SnapshotIdentifier']) { [string]$NormalizedIssue.Source.SnapshotIdentifier } else { $null }
        }
        ReadinessSummary = Get-ReadinessSummary -NormalizedIssue $NormalizedIssue
        Selected = @($selected)
        Considered = @($considered)
        Warnings = @($candidates.Warnings)
        Blockers = @($candidates.Blockers)
        DownstreamReady = @($candidates.Blockers).Count -eq 0
        OutputPath = $OutputPath
        DraftOutputStatus = 'Not written by context-manifest mode'
    }
}

function Format-ManifestRecord {
    param(
        [Parameter(Mandatory = $true)]
        [psobject]$Record
    )

    $path = Get-SafeManifestText -Value ([string]$Record.Path)
    $category = Get-SafeManifestText -Value ([string]$Record.Category)
    $reason = Get-SafeManifestText -Value ([string]$Record.Reason)
    if ($null -ne $Record.PSObject.Properties['Status']) {
        $status = Get-SafeManifestText -Value ([string]$Record.Status)
        return "- **$path** - $category; status: $status; $reason."
    }
    return "- **$path** - $category; $reason."
}

function Format-ManifestNotice {
    param(
        [Parameter(Mandatory = $true)]
        [psobject]$Notice
    )

    $category = Get-SafeManifestText -Value ([string]$Notice.Category)
    $message = Get-SafeManifestText -Value ([string]$Notice.Message)
    $path = if ($null -ne $Notice.Path) { Get-SafeManifestText -Value ([string]$Notice.Path) } else { $null }
    $reference = if ($null -ne $Notice.Reference) { Get-SafeManifestText -Value ([string]$Notice.Reference) } else { $null }
    $parts = @("**$category**")
    if ($null -ne $path) { $parts += "path: $path" }
    if ($null -ne $reference) { $parts += "entry: $reference" }
    $parts += $message
    return '- ' + ($parts -join '; ') + '.'
}

function ConvertTo-ManifestMarkdown {
    param(
        [Parameter(Mandatory = $true)]
        [psobject]$Manifest
    )

    $selected = @($Manifest.Selected)
    $considered = @($Manifest.Considered)
    $warnings = @($Manifest.Warnings)
    $blockers = @($Manifest.Blockers)
    $lines = @(
        "# Context Manifest - Issue #$($Manifest.Source.Number)",
        '',
        '## Preparation',
        '',
        "- Prepared at: $($Manifest.PreparationTimestamp)",
        "- Tool version: $($Manifest.ToolVersion)",
        '',
        '## Source Issue',
        '',
        "- Number: $($Manifest.Source.Number)",
        "- Title: $(Get-SafeManifestText -Value $Manifest.Source.Title)",
        "- URL: $(Get-SafeManifestText -Value $Manifest.Source.Url)"
    )
    if (-not [string]::IsNullOrWhiteSpace([string]$Manifest.Source.SnapshotIdentifier)) {
        $lines += "- Snapshot identifier: $(Get-SafeManifestText -Value $Manifest.Source.SnapshotIdentifier)"
    }
    $lines += @(
        '',
        '## Readiness',
        '',
        "- $($Manifest.ReadinessSummary)",
        "- Downstream-ready: $($Manifest.DownstreamReady)",
        '',
        '## Selected governing documents',
        ''
    )
    if ($selected.Count -eq 0) { $lines += '- None.' } else { $lines += @($selected | ForEach-Object { Format-ManifestRecord -Record $_ }) }
    $lines += @('', '## Considered but not selected', '')
    if ($considered.Count -eq 0) { $lines += '- None.' } else { $lines += @($considered | ForEach-Object { Format-ManifestRecord -Record $_ }) }
    $lines += @('', '## Warnings', '')
    if ($warnings.Count -eq 0) { $lines += '- None.' } else { $lines += @($warnings | ForEach-Object { Format-ManifestNotice -Notice $_ }) }
    $lines += @('', '## Blockers', '')
    if ($blockers.Count -eq 0) { $lines += '- None.' } else { $lines += @($blockers | ForEach-Object { Format-ManifestNotice -Notice $_ }) }
    $lines += @(
        '',
        '## Output',
        '',
        "- Manifest path: $(Get-SafeManifestText -Value $Manifest.OutputPath)",
        "- Draft output status: $(Get-SafeManifestText -Value $Manifest.DraftOutputStatus)",
        "- Downstream-ready state: $($Manifest.DownstreamReady)",
        ''
    )
    return ($lines -join "`n")
}

function Write-ContextManifest {
    param(
        [Parameter(Mandatory = $true)]
        [psobject]$Manifest,

        [Parameter(Mandatory = $true)]
        [string]$ManifestOutputRoot
    )

    $issueNumber = [int]$Manifest.Source.Number
    if ($issueNumber -le 0) {
        throw 'Manifest source Issue number must be positive.'
    }

    if (-not (Test-Path -LiteralPath $ManifestOutputRoot -PathType Container)) {
        New-Item -ItemType Directory -Path $ManifestOutputRoot -Force | Out-Null
    }

    $outputPath = Join-Path $ManifestOutputRoot "$issueNumber.md"
    [IO.File]::WriteAllText($outputPath, (ConvertTo-ManifestMarkdown -Manifest $Manifest), [Text.UTF8Encoding]::new($false))
    return (Resolve-Path -LiteralPath $outputPath).Path
}

function Invoke-ContextManifest {
    param(
        [Parameter(Mandatory = $true)]
        [string]$NormalizedIssueJsonPath,

        [Parameter(Mandatory = $true)]
        [string]$RepositoryRoot,

        [string]$ManifestOutputRoot
    )

    $root = (Resolve-Path -LiteralPath $RepositoryRoot).Path
    $normalized = Get-NormalizedIssueContractFromFile -Path $NormalizedIssueJsonPath
    $outputRoot = if ([string]::IsNullOrWhiteSpace($ManifestOutputRoot)) {
        Join-Path $root 'docs/context-manifests'
    }
    elseif ([IO.Path]::IsPathRooted($ManifestOutputRoot)) {
        $ManifestOutputRoot
    }
    else {
        Join-Path $root $ManifestOutputRoot
    }
    $relativeOutputPath = if ([string]::IsNullOrWhiteSpace($ManifestOutputRoot)) {
        'docs/context-manifests/' + [int]$normalized.Source.Number + '.md'
    }
    elseif ([IO.Path]::IsPathRooted($ManifestOutputRoot)) {
        'context-manifests/' + [int]$normalized.Source.Number + '.md'
    }
    else {
        $ManifestOutputRoot.Replace('\', '/').TrimEnd('/') + '/' + [int]$normalized.Source.Number + '.md'
    }
    $manifest = Resolve-ContextManifest -NormalizedIssue $normalized -RepositoryRoot $root -OutputPath $relativeOutputPath
    $writtenPath = Write-ContextManifest -Manifest $manifest -ManifestOutputRoot $outputRoot

    [pscustomobject]@{
        SelectedCount = @($manifest.Selected).Count
        ConsideredCount = @($manifest.Considered).Count
        WarningCount = @($manifest.Warnings).Count
        BlockerCount = @($manifest.Blockers).Count
        DownstreamReady = $manifest.DownstreamReady
        OutputPath = $writtenPath
    }
}

if (-not $NoRun) {
    if ($ContextManifest) {
        if ([string]::IsNullOrWhiteSpace($NormalizedIssueJsonPath) -or [string]::IsNullOrWhiteSpace($RepositoryRoot)) {
            throw 'Context-manifest mode requires NormalizedIssueJsonPath and RepositoryRoot.'
        }
        Invoke-ContextManifest -NormalizedIssueJsonPath $NormalizedIssueJsonPath -RepositoryRoot $RepositoryRoot -ManifestOutputRoot $ManifestOutputRoot | ConvertTo-Json -Compress
    }
    else {
        Invoke-IssueNormalization -Number $IssueNumber -FixturePath $IssueJsonPath | ConvertTo-Json -Depth 10
    }
}
