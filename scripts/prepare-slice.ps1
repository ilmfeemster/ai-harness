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
    [Parameter(ParameterSetName = 'DraftSlice')]
    [string]$NormalizedIssueJsonPath,

    [Parameter(ParameterSetName = 'ContextManifest')]
    [Parameter(ParameterSetName = 'DraftSlice')]
    [string]$RepositoryRoot,

    [Parameter(ParameterSetName = 'ContextManifest')]
    [string]$ManifestOutputRoot,

    [Parameter(ParameterSetName = 'DraftSlice')]
    [switch]$GenerateDraftSlice,

    [Parameter(ParameterSetName = 'DraftSlice')]
    [string]$ContextManifestPath,

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
        "# Context Manifest $([char]0x2014) Issue #$($Manifest.Source.Number)",
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

function New-DraftBlocker {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Category,

        [Parameter(Mandatory = $true)]
        [string]$Message,

        [AllowNull()]
        [string]$Path,

        [AllowNull()]
        [int]$IssueNumber
    )

    [pscustomobject]@{
        Category = $Category
        Message = $Message
        Path = $Path
        IssueNumber = if ($IssueNumber -gt 0) { $IssueNumber } else { $null }
    }
}

function Get-DraftResult {
    param(
        [Parameter(Mandatory = $true)]
        [int]$IssueNumber,

        [Parameter(Mandatory = $true)]
        [bool]$Generated,

        [Parameter(Mandatory = $true)]
        [string]$ManifestPath,

        [AllowNull()]
        [string]$OutputPath,

        [object[]]$Blockers
    )

    $safeBlockers = @($Blockers | ForEach-Object {
        [pscustomobject]@{
            Category = Get-SafeManifestText -Value ([string]$_.Category)
            Message = Get-SafeManifestText -Value ([string]$_.Message)
            Path = if ($null -ne $_.Path) { Get-SafeManifestText -Value ([string]$_.Path) } else { $null }
            IssueNumber = $_.IssueNumber
        }
    })
    [pscustomobject]@{
        IssueNumber = $IssueNumber
        Generated = $Generated
        Blocked = -not $Generated
        BlockerCount = $safeBlockers.Count
        Blockers = $safeBlockers
        OutputPath = $OutputPath
        ManifestPath = $ManifestPath
    }
}

function Get-DraftFullPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RepositoryRoot,

        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if ([IO.Path]::IsPathRooted($Path)) {
        return [IO.Path]::GetFullPath($Path)
    }
    return [IO.Path]::GetFullPath((Join-Path $RepositoryRoot $Path))
}

function Test-DraftPathUnderRoot {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Root,

        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $rootFull = [IO.Path]::GetFullPath($Root).TrimEnd('\', '/')
    $pathFull = [IO.Path]::GetFullPath($Path)
    return $pathFull.Equals($rootFull, [StringComparison]::OrdinalIgnoreCase) -or
        $pathFull.StartsWith($rootFull + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase) -or
        $pathFull.StartsWith($rootFull + [IO.Path]::AltDirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)
}

function Read-DraftUtf8Text {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [AllowNull()]
        [scriptblock]$FileReader
    )

    if ($null -ne $FileReader) {
        return [string](& $FileReader $Path)
    }
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw 'file is missing or inaccessible'
    }
    return [IO.File]::ReadAllText($Path, [Text.UTF8Encoding]::new($false))
}

function Write-DraftUtf8Atomic {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [string]$Content
    )

    $directory = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $directory -PathType Container)) {
        New-Item -ItemType Directory -Path $directory -Force | Out-Null
    }
    $temporary = Join-Path $directory ('.' + [IO.Path]::GetFileName($Path) + '.' + [guid]::NewGuid().ToString('N') + '.tmp')
    try {
        [IO.File]::WriteAllText($temporary, $Content, [Text.UTF8Encoding]::new($false))
        Move-Item -LiteralPath $temporary -Destination $Path -Force
    }
    finally {
        if (Test-Path -LiteralPath $temporary) {
            Remove-Item -LiteralPath $temporary -Force
        }
    }
}

function Get-DraftManifestSection {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Content,

        [Parameter(Mandatory = $true)]
        [string]$Heading
    )

    $match = [regex]::Match($Content, '(?ms)^##\s+' + [regex]::Escape($Heading) + '\s*\r?\n(?<section>.*?)(?=^##\s+|\z)')
    if (-not $match.Success) {
        return $null
    }
    return $match.Groups['section'].Value.Trim()
}

function Format-DraftBlockerLine {
    param(
        [Parameter(Mandatory = $true)]
        [psobject]$Blocker
    )

    $category = Get-SafeManifestText -Value ([string]$Blocker.Category)
    $message = Get-SafeManifestText -Value ([string]$Blocker.Message)
    $path = if ($null -ne $Blocker.Path) { Get-SafeManifestText -Value ([string]$Blocker.Path) } else { $null }
    $issue = if ($null -ne $Blocker.IssueNumber) { "Issue #$($Blocker.IssueNumber)" } else { $null }
    $parts = @("**$category**")
    if ($null -ne $path) { $parts += "path: $path" }
    if ($null -ne $issue) { $parts += $issue }
    $parts += $message
    return '- ' + ($parts -join '; ') + '.'
}

function Update-DraftManifestResult {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ManifestPath,

        [Parameter(Mandatory = $true)]
        [string]$ManifestContent,

        [Parameter(Mandatory = $true)]
        [string]$DraftStatus,

        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [object[]]$Blockers
    )

    $blockerSection = Get-DraftManifestSection -Content $ManifestContent -Heading 'Blockers'
    if ($null -eq $blockerSection) {
        throw 'context manifest is missing its Blockers section'
    }
    $existingLines = @()
    if (-not [string]::IsNullOrWhiteSpace($blockerSection) -and $blockerSection.Trim() -ne '- None.') {
        $existingLines = @($blockerSection.Trim() -split '\r?\n')
    }
    $newLines = @($Blockers | ForEach-Object { Format-DraftBlockerLine -Blocker $_ })
    $combinedLines = @($existingLines + $newLines)
    if ($combinedLines.Count -eq 0) {
        $combinedLines = @('- None.')
    }
    $newBlockerSection = "## Blockers`n`n" + ($combinedLines -join "`n") + "`n`n"
    $updated = [regex]::Replace($ManifestContent, '(?ms)^##\s+Blockers\s*\r?\n.*?(?=^##\s+|\z)', $newBlockerSection, 1)

    $outputSection = Get-DraftManifestSection -Content $updated -Heading 'Output'
    if ($null -eq $outputSection) {
        throw 'context manifest is missing its Output section'
    }
    $outputLines = @($outputSection -split '\r?\n' | Where-Object { $_ -notmatch '^\s*-\s*Draft output status:' -and $_ -notmatch '^\s*-\s*Draft output path:' })
    $outputLines += "- Draft output status: $DraftStatus."
    $outputLines += if ($DraftStatus -eq 'Draft') { '- Draft output path: docs/current-slice.md.' } else { '- Draft output path: Not written.' }
    $newOutputSection = "## Output`n`n" + (($outputLines | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }) -join "`n") + "`n`n"
    $updated = [regex]::Replace($updated, '(?ms)^##\s+Output\s*\r?\n.*?(?=^##\s+|\z)', $newOutputSection, 1)
    Write-DraftUtf8Atomic -Path $ManifestPath -Content $updated
}

function Get-DraftManifestInput {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RepositoryRoot,

        [Parameter(Mandatory = $true)]
        [string]$ManifestPath,

        [Parameter(Mandatory = $true)]
        [int]$IssueNumber,

        [AllowNull()]
        [scriptblock]$FileReader
    )

    $manifestRoot = Join-Path $RepositoryRoot 'docs/context-manifests'
    $fullPath = Get-DraftFullPath -RepositoryRoot $RepositoryRoot -Path $ManifestPath
    $relativePath = if ([IO.Path]::IsPathRooted($ManifestPath)) { $ManifestPath } else { $ManifestPath.Replace('\', '/') }
    $blockers = @()
    $canUpdate = $false
    $content = $null
    if (-not (Test-DraftPathUnderRoot -Root $manifestRoot -Path $fullPath)) {
        $blockers += New-DraftBlocker -Category 'Context manifest' -Path $relativePath -Message 'manifest path is outside docs/context-manifests and cannot be safely updated.'
        return [pscustomobject]@{ CanUpdate = $false; FullPath = $fullPath; RelativePath = $relativePath; Content = $null; SelectedPaths = @(); Blockers = @($blockers) }
    }
    if ([IO.Path]::GetFileNameWithoutExtension($fullPath) -ne [string]$IssueNumber) {
        $blockers += New-DraftBlocker -Category 'Context manifest' -Path $relativePath -Message 'manifest filename does not match the source Issue number.'
        return [pscustomobject]@{ CanUpdate = $false; FullPath = $fullPath; RelativePath = $relativePath; Content = $null; SelectedPaths = @(); Blockers = @($blockers) }
    }
    try {
        $content = Read-DraftUtf8Text -Path $fullPath -FileReader $FileReader
    }
    catch {
        $blockers += New-DraftBlocker -Category 'Context manifest' -Path $relativePath -Message 'matching context manifest is missing or inaccessible; no manifest can be safely updated.'
        return [pscustomobject]@{ CanUpdate = $false; FullPath = $fullPath; RelativePath = $relativePath; Content = $null; SelectedPaths = @(); Blockers = @($blockers) }
    }

    $header = "# Context Manifest $([char]0x2014) Issue #$IssueNumber"
    if ($content -notmatch '(?m)^' + [regex]::Escape($header) + '\s*$') {
        $blockers += New-DraftBlocker -Category 'Context manifest' -Path $relativePath -Message 'manifest source identity does not match the normalized Issue; no manifest can be safely updated.'
    }
    $blockerSection = Get-DraftManifestSection -Content $content -Heading 'Blockers'
    if ($null -eq $blockerSection) {
        $blockers += New-DraftBlocker -Category 'Context manifest' -Path $relativePath -Message 'manifest is missing its Blockers section.'
    }
    elseif ($blockerSection.Trim() -ne '- None.') {
        $blockers += New-DraftBlocker -Category 'Context manifest' -Path $relativePath -Message 'context assembly reported blockers; resolve them before generating a Draft slice.'
    }
    if ($content -notmatch '(?mi)^-\s+Downstream-ready:\s*True\s*$') {
        $blockers += New-DraftBlocker -Category 'Context manifest' -Path $relativePath -Message 'context manifest is not downstream-ready.'
    }

    $selectedSection = Get-DraftManifestSection -Content $content -Heading 'Selected governing documents'
    $selectedPaths = @()
    if ($null -ne $selectedSection) {
        $selectedPaths = @([regex]::Matches($selectedSection, '(?m)^-\s+\*\*(?<path>[^*]+)\*\*') | ForEach-Object { $_.Groups['path'].Value.Trim() })
    }
    foreach ($mandatory in @('AGENTS.md', 'docs/project.md', 'docs/architecture.md', 'docs/decisions.md', 'docs/testing.md', 'docs/current-slice.md')) {
        if (@($selectedPaths | Where-Object { $_.ToLowerInvariant() -eq $mandatory.ToLowerInvariant() }).Count -eq 0) {
            $blockers += New-DraftBlocker -Category 'Context manifest' -Path $mandatory -Message 'mandatory selected authority is absent from the manifest.'
        }
    }
    $safeSelected = @()
    foreach ($selectedPath in $selectedPaths) {
        $normalizedPath = $selectedPath.Replace('\', '/')
        if ($normalizedPath -match '^(?:[a-z][a-z0-9+.-]*:|/|\\)' -or ($normalizedPath -split '/') -contains '..') {
            $blockers += New-DraftBlocker -Category 'Context manifest' -Path $normalizedPath -Message 'manifest selected path is not a safe repository-relative path.'
            continue
        }
        $safeSelected += $normalizedPath
        $status = Get-ContextFileStatus -RepositoryRoot $RepositoryRoot -RelativePath $normalizedPath -FileReader $FileReader
        if (-not $status.Available) {
            $blockers += New-DraftBlocker -Category 'Selected document' -Path $normalizedPath -Message 'manifest-selected document is missing or inaccessible.'
        }
    }
    $canUpdate = $content -match '(?m)^' + [regex]::Escape($header) + '\s*$'
    [pscustomobject]@{
        CanUpdate = $canUpdate
        FullPath = $fullPath
        RelativePath = $relativePath
        Content = $content
        SelectedPaths = @($safeSelected | Select-Object -Unique)
        Blockers = @($blockers)
    }
}

function Get-DraftPhaseRecords {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RepositoryRoot,

        [AllowNull()]
        [scriptblock]$FileReader
    )

    $root = Join-Path $RepositoryRoot 'docs/issues'
    $records = @()
    if (-not (Test-Path -LiteralPath $root -PathType Container)) {
        return @($records)
    }
    foreach ($phaseDirectory in @(Get-ChildItem -LiteralPath $root -Directory | Sort-Object Name)) {
        foreach ($draft in @(Get-ChildItem -LiteralPath $phaseDirectory.FullName -File -Filter '*.md' | Sort-Object Name)) {
            try { $content = Read-DraftUtf8Text -Path $draft.FullName -FileReader $FileReader } catch { continue }
            $number = Get-FrontMatterValue -Content $content -Name 'github_issue_number'
            if ([string]::IsNullOrWhiteSpace($number)) { continue }
            $records += [pscustomobject]@{
                Path = $draft.FullName
                Number = $number
                Phase = Get-FrontMatterValue -Content $content -Name 'phase'
                Sequence = Get-FrontMatterValue -Content $content -Name 'sequence'
                DependsOn = Get-FrontMatterValue -Content $content -Name 'depends_on'
                Readiness = Get-FrontMatterValue -Content $content -Name 'readiness'
            }
        }
    }
    return @($records)
}

function Get-DraftDependencyState {
    param(
        [Parameter(Mandatory = $true)]
        [int]$IssueNumber,

        [AllowNull()]
        [scriptblock]$DependencyStateReader
    )

    try {
        if ($null -ne $DependencyStateReader) {
            return ([string](& $DependencyStateReader $IssueNumber)).ToUpperInvariant()
        }
        if ($null -eq (Get-Command gh -ErrorAction SilentlyContinue)) {
            throw 'GitHub CLI is unavailable'
        }
        $json = & gh issue view $IssueNumber --json state
        if ($LASTEXITCODE -ne 0) { throw 'GitHub Issue state could not be read' }
        return ([string](($json | ConvertFrom-Json).state)).ToUpperInvariant()
    }
    catch {
        throw 'dependency Issue state is unreadable'
    }
}

function Get-DraftCurrentSliceState {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RepositoryRoot,

        [AllowNull()]
        [scriptblock]$FileReader
    )

    $path = Join-Path $RepositoryRoot 'docs/current-slice.md'
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        return [pscustomobject]@{ Status = 'Empty'; Content = '' }
    }
    $content = Read-DraftUtf8Text -Path $path -FileReader $FileReader
    if ([string]::IsNullOrWhiteSpace($content)) {
        return [pscustomobject]@{ Status = 'Empty'; Content = $content }
    }
    $match = [regex]::Match($content, '(?ms)^##\s+Status\s*\r?\n(?<status>[^\r\n]+)')
    if (-not $match.Success) {
        return [pscustomobject]@{ Status = 'Invalid'; Content = $content }
    }
    return [pscustomobject]@{ Status = $match.Groups['status'].Value.Trim(); Content = $content }
}

function Get-DraftGeneratedSection {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Content,

        [Parameter(Mandatory = $true)]
        [string]$Heading
    )

    $match = [regex]::Match($Content, '(?ms)^##\s+' + [regex]::Escape($Heading) + '\s*\r?\n(?<section>.*?)(?=^##\s+|\z)')
    if (-not $match.Success) { return $null }
    return $match.Groups['section'].Value.Trim()
}

function ConvertTo-DraftSliceMarkdown {
    param(
        [Parameter(Mandatory = $true)]
        [psobject]$NormalizedIssue,

        [Parameter(Mandatory = $true)]
        [string[]]$SelectedPaths
    )

    $title = [string]$NormalizedIssue.Source.Title
    $lines = @(
        "# $title",
        '',
        '> **Project-owned operational state:** This generated execution package is a Draft. Human review and explicit approval are required before implementation.',
        '',
        '## Status',
        '',
        'Draft',
        '',
        '## Source Issue',
        '',
        "- **Issue:** #$($NormalizedIssue.Source.Number) - $title",
        "- **URL:** $($NormalizedIssue.Source.Url)",
        '',
        '## Context',
        '',
        [string]$NormalizedIssue.Context,
        '',
        '## Goal',
        '',
        [string]$NormalizedIssue.Goal,
        '',
        '## Scope',
        '',
        [string]$NormalizedIssue.Scope,
        '',
        '## Non-goals',
        '',
        [string]$NormalizedIssue.NonGoals,
        '',
        '## Acceptance criteria',
        '',
        [string]$NormalizedIssue.AcceptanceCriteria,
        '',
        '## Governing-rule reconciliation',
        '',
        '| Rule | Governing source | Slice interpretation | Difference |',
        '| --- | --- | --- | --- |',
        '| Issue contract preservation | Normalized source Issue | Preserve Context, Goal, Scope, Non-goals, and Acceptance criteria exactly. | None |',
        '| Bounded context | Matching context manifest | Use only selected governing document references; do not rediscover or infer relevance. | None |',
        '| Human approval boundary | `AGENTS.md` and approved design | Generated status is Draft and approval/completion evidence remains pending. | None |',
        '',
        '## Implementation plan',
        '',
        '1. Use the normalized Issue contract and selected governing-document references as the bounded preparation inputs.',
        '2. Identify and refine file-level implementation detail during human review only where the selected authorities support it; do not infer product, semantic, API, or relevance policy from free text.',
        '3. Implement the Issue outcome within the approved scope, then run the declared validation and review workflow.',
        '',
        '## Expected files',
        '',
        '- Human review must identify the concrete implementation files; this preparation path does not infer them from free text.',
        '',
        '## Documentation impact',
        '',
        '| Source | Impact | Required action |',
        '| --- | --- | --- |',
        '| `README.md` | None | None |',
        '| `docs/project.md` | None | None |',
        '| `docs/architecture.md` | None | None |',
        '| `docs/decisions.md` | None | None |',
        '| `docs/design/*.md` | None | None |',
        '| `docs/testing.md` | None | None |',
        '',
        '## Validation plan',
        '',
        'Run from repository root:',
        '',
        '```powershell',
        'powershell -NoProfile -ExecutionPolicy Bypass -File tests/prepare-slice.ps1',
        'powershell -NoProfile -ExecutionPolicy Bypass -File scripts/validate.ps1',
        'powershell -NoProfile -ExecutionPolicy Bypass -File tests/validate-structure.ps1',
        '```',
        '',
        'Manual checks:',
        '',
        '- Confirm the generated source sections preserve the normalized contract and selected-document references remain bounded.',
        '- Confirm unresolved active-slice, dependency, manifest, readiness, and required-document guards prevent replacement and record sanitized blockers.',
        '- Confirm no generation path approves, implements, changes GitHub state, or replaces an unresolved active slice.',
        '',
        '## Failure conditions',
        '',
        'Stop and revise before approval or implementation if a required source, dependency, document, guard, interface, or semantic decision cannot be verified from the bounded inputs.',
        '',
        '## Review checklist',
        '',
        '- Does the generated slice preserve the source contract without claiming semantic equivalence?',
        '- Are selected documents, warnings, blockers, side effects, and lifecycle boundaries explicit?',
        '- Are human decisions surfaced rather than inferred by the generator?',
        '',
        '## Approval evidence',
        '',
        '**Slice approval:** Pending.',
        '',
        '**Slice approved by:** Pending.',
        '',
        '**Slice approval basis:** Pending.',
        '',
        '**Slice approved at:** Pending.',
        '',
        '**Final approval:** Pending.',
        '',
        '**Final approved by:** Pending.',
        '',
        '**Final approval basis:** Pending.',
        '',
        '**Final approved at:** Pending.',
        '',
        '## Completion evidence',
        '',
        '**Implementation status:** Pending.',
        '',
        '**Acceptance-criteria status:** Pending.',
        '',
        '**Files changed:** Pending.',
        '',
        '**Validation results:** Not run.',
        '',
        '**Manual checks:** Pending.',
        '',
        '**Documentation-impact result:** Pending.',
        '',
        '**Review result:** Pending.',
        '',
        '**Implementation adjustments or deviations:** None.',
        '',
        '**Known limitations or follow-up Issues:** Human review must resolve any file-level plan that selected documents do not establish.',
        '',
        '**Issue closure:** Pending.',
        '',
        '**Implementation summary:** Generated Draft from normalized Issue and bounded context manifest. Approval and implementation have not begun.'
    )
    $lines += @('', '## Dependencies', '', [string]$NormalizedIssue.Dependencies, '', '## Relevant documents', '')
    if (@($SelectedPaths).Count -eq 0) { $lines += '- None.' } else { $lines += @($SelectedPaths | ForEach-Object { '- `' + $_ + '`' }) }
    $lines += @('', '## Generation warnings', '', '- File-level expected files and semantic equivalence are not inferred automatically; human review owns those judgments.', '')
    return ($lines -join "`n")
}

function Test-DraftGeneratedSlice {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Content,

        [Parameter(Mandatory = $true)]
        [psobject]$NormalizedIssue
    )

    $errors = @()
    foreach ($heading in @('## Status', '## Source Issue', '## Context', '## Goal', '## Scope', '## Non-goals', '## Acceptance criteria', '## Governing-rule reconciliation', '## Implementation plan', '## Expected files', '## Documentation impact', '## Validation plan', '## Failure conditions', '## Review checklist', '## Approval evidence', '## Completion evidence')) {
        if ($Content -notmatch '(?m)^' + [regex]::Escape($heading) + '\s*$') {
            $errors += "generated Draft is missing required heading '$heading'"
        }
    }
    if ($Content -notmatch '(?ms)^##\s+Status\s*\r?\nDraft\s*$') { $errors += 'generated slice status is not Draft' }
    if ($Content -notmatch '(?m)^-\s+\*\*Issue:\*\*\s+#' + [int]$NormalizedIssue.Source.Number + '\s+-\s+') { $errors += 'generated slice source Issue traceability is missing' }
    if ($Content -notmatch '(?m)^-\s+\*\*URL:\*\*\s+' + [regex]::Escape([string]$NormalizedIssue.Source.Url) + '\s*$') { $errors += 'generated slice source Issue URL traceability is missing' }
    $sectionMap = @{
        Context = 'Context'
        Goal = 'Goal'
        Scope = 'Scope'
        NonGoals = 'Non-goals'
        AcceptanceCriteria = 'Acceptance criteria'
    }
    foreach ($property in $sectionMap.Keys) {
        $actual = Get-DraftGeneratedSection -Content $Content -Heading $sectionMap[$property]
        if ($null -eq $actual -or $actual -cne ([string]$NormalizedIssue.$property).Trim()) {
            $errors += "generated section '$($sectionMap[$property])' does not preserve the normalized source contract"
        }
    }
    foreach ($placeholder in @('\[Work Item Title\]', '\[Brief execution background\]', '\[Singular expected outcome preserved from the Issue\.\]', '\[Included work\]', '\[Explicitly excluded work\]')) {
        if ($Content -match $placeholder) { $errors += "generated slice contains neutral-schema placeholder '$placeholder'" }
    }
    return @($errors)
}

function Invoke-DraftSliceGeneration {
    param(
        [Parameter(Mandatory = $true)]
        [string]$NormalizedIssueJsonPath,

        [Parameter(Mandatory = $true)]
        [string]$ContextManifestPath,

        [Parameter(Mandatory = $true)]
        [string]$RepositoryRoot,

        [AllowNull()]
        [scriptblock]$DependencyStateReader,

        [AllowNull()]
        [scriptblock]$FileReader
    )

    $root = (Resolve-Path -LiteralPath $RepositoryRoot).Path
    $normalized = $null
    try {
        $normalized = Get-NormalizedIssueContractFromFile -Path $NormalizedIssueJsonPath
    }
    catch {
        return Get-DraftResult -IssueNumber 0 -Generated $false -ManifestPath $ContextManifestPath -Blockers @(
            (New-DraftBlocker -Category 'Normalized contract' -Message 'normalized Issue contract is missing or invalid; no active slice was written.')
        )
    }
    $issueNumber = [int]$normalized.Source.Number
    $manifest = Get-DraftManifestInput -RepositoryRoot $root -ManifestPath $ContextManifestPath -IssueNumber $issueNumber -FileReader $FileReader
    $blockers = @($manifest.Blockers)

    if ($normalized.Source.PSObject.Properties['State'] -and [string]$normalized.Source.State -ne 'OPEN') {
        $blockers += New-DraftBlocker -Category 'Source Issue' -IssueNumber $issueNumber -Message 'normalized source Issue is not open.'
    }
    $readiness = @($normalized.Readiness)
    foreach ($confirmation in @($readiness | Where-Object { -not $_.Checked })) {
        $blockers += New-DraftBlocker -Category 'Readiness' -IssueNumber $issueNumber -Message "readiness confirmation '$($confirmation.Label)' is unchecked."
    }

    $phaseRecords = Get-DraftPhaseRecords -RepositoryRoot $root -FileReader $FileReader
    $sourceDrafts = @($phaseRecords | Where-Object { $_.Number -eq [string]$issueNumber })
    if ($sourceDrafts.Count -ne 1) {
        $blockers += New-DraftBlocker -Category 'Dependency mapping' -IssueNumber $issueNumber -Message 'exactly one local phase draft must map to the source Issue.'
    }
    else {
        $sourceDraft = $sourceDrafts[0]
        if ($sourceDraft.Readiness -ne 'Ready') { $blockers += New-DraftBlocker -Category 'Readiness' -Path $sourceDraft.Path -Message 'local phase draft is not marked Ready.' }
        $tokens = @()
        if (-not [string]::IsNullOrWhiteSpace($sourceDraft.DependsOn)) {
            $tokens = @($sourceDraft.DependsOn -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ } | Select-Object -Unique)
        }
        foreach ($token in $tokens) {
            $matches = @($phaseRecords | Where-Object { $_.Phase -eq $sourceDraft.Phase -and $_.Sequence -eq $token })
            if ($matches.Count -ne 1) {
                $blockers += New-DraftBlocker -Category 'Dependency mapping' -Path $token -Message 'dependency sequence does not map to exactly one local phase draft.'
                continue
            }
            try { $dependencyState = Get-DraftDependencyState -IssueNumber ([int]$matches[0].Number) -DependencyStateReader $DependencyStateReader }
            catch { $blockers += New-DraftBlocker -Category 'Dependency state' -IssueNumber ([int]$matches[0].Number) -Message 'dependency Issue state is unreadable.'; continue }
            if ($dependencyState -ne 'CLOSED') {
                $blockers += New-DraftBlocker -Category 'Dependency state' -IssueNumber ([int]$matches[0].Number) -Message 'mapped dependency Issue is not closed.'
            }
        }
    }

    try {
        $sliceState = Get-DraftCurrentSliceState -RepositoryRoot $root -FileReader $FileReader
        if ($sliceState.Status -notin @('Empty', 'Complete')) {
            $blockers += New-DraftBlocker -Category 'Active slice' -Path 'docs/current-slice.md' -Message "existing active slice status '$($sliceState.Status)' is unresolved and cannot be replaced."
        }
    }
    catch {
        $blockers += New-DraftBlocker -Category 'Active slice' -Path 'docs/current-slice.md' -Message 'existing active slice is missing or inaccessible.'
    }
    if (-not (Test-Path -LiteralPath (Join-Path $root 'templates/docs/current-slice.md') -PathType Leaf)) {
        $blockers += New-DraftBlocker -Category 'Schema' -Path 'templates/docs/current-slice.md' -Message 'neutral current-slice schema is missing or inaccessible.'
    }

    $outputPath = Join-Path $root 'docs/current-slice.md'
    if ($blockers.Count -gt 0) {
        if ($manifest.CanUpdate) {
            try { Update-DraftManifestResult -ManifestPath $manifest.FullPath -ManifestContent $manifest.Content -DraftStatus 'Blocked' -Blockers $blockers } catch { }
        }
        return Get-DraftResult -IssueNumber $issueNumber -Generated $false -ManifestPath $manifest.RelativePath -OutputPath 'docs/current-slice.md' -Blockers $blockers
    }

    $draftContent = ConvertTo-DraftSliceMarkdown -NormalizedIssue $normalized -SelectedPaths $manifest.SelectedPaths
    $selfCheck = @(Test-DraftGeneratedSlice -Content $draftContent -NormalizedIssue $normalized)
    if ($selfCheck.Count -gt 0) {
        $blockers = @($selfCheck | ForEach-Object { New-DraftBlocker -Category 'Generated slice' -Message $_ })
        if ($manifest.CanUpdate) {
            try { Update-DraftManifestResult -ManifestPath $manifest.FullPath -ManifestContent $manifest.Content -DraftStatus 'Blocked' -Blockers $blockers } catch { }
        }
        return Get-DraftResult -IssueNumber $issueNumber -Generated $false -ManifestPath $manifest.RelativePath -OutputPath 'docs/current-slice.md' -Blockers $blockers
    }

    $oldExists = Test-Path -LiteralPath $outputPath -PathType Leaf
    $oldContent = if ($oldExists) { Read-DraftUtf8Text -Path $outputPath -FileReader $FileReader } else { $null }
    try {
        Write-DraftUtf8Atomic -Path $outputPath -Content $draftContent
        Update-DraftManifestResult -ManifestPath $manifest.FullPath -ManifestContent $manifest.Content -DraftStatus 'Draft' -Blockers @()
    }
    catch {
        if ($oldExists) { Write-DraftUtf8Atomic -Path $outputPath -Content $oldContent } elseif (Test-Path -LiteralPath $outputPath) { Remove-Item -LiteralPath $outputPath -Force }
        $blockers = @(New-DraftBlocker -Category 'Draft generation' -Message 'Draft or matching manifest write failed; the prior active slice was restored.')
        return Get-DraftResult -IssueNumber $issueNumber -Generated $false -ManifestPath $manifest.RelativePath -OutputPath 'docs/current-slice.md' -Blockers $blockers
    }
    return Get-DraftResult -IssueNumber $issueNumber -Generated $true -ManifestPath $manifest.RelativePath -OutputPath 'docs/current-slice.md' -Blockers @()
}

if (-not $NoRun) {
    if ($GenerateDraftSlice) {
        if ([string]::IsNullOrWhiteSpace($NormalizedIssueJsonPath) -or [string]::IsNullOrWhiteSpace($ContextManifestPath) -or [string]::IsNullOrWhiteSpace($RepositoryRoot)) {
            throw 'Draft-generation mode requires NormalizedIssueJsonPath, ContextManifestPath, and RepositoryRoot.'
        }
        Invoke-DraftSliceGeneration -NormalizedIssueJsonPath $NormalizedIssueJsonPath -ContextManifestPath $ContextManifestPath -RepositoryRoot $RepositoryRoot | ConvertTo-Json -Depth 8 -Compress
    }
    elseif ($ContextManifest) {
        if ([string]::IsNullOrWhiteSpace($NormalizedIssueJsonPath) -or [string]::IsNullOrWhiteSpace($RepositoryRoot)) {
            throw 'Context-manifest mode requires NormalizedIssueJsonPath and RepositoryRoot.'
        }
        Invoke-ContextManifest -NormalizedIssueJsonPath $NormalizedIssueJsonPath -RepositoryRoot $RepositoryRoot -ManifestOutputRoot $ManifestOutputRoot | ConvertTo-Json -Compress
    }
    else {
        Invoke-IssueNormalization -Number $IssueNumber -FixturePath $IssueJsonPath | ConvertTo-Json -Depth 10
    }
}
