[CmdletBinding()]
param(
    [ValidateRange(1, [int]::MaxValue)]
    [int]$IssueNumber,

    [string]$IssueJsonPath,

    [switch]$NoRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

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

if (-not $NoRun) {
    Invoke-IssueNormalization -Number $IssueNumber -FixturePath $IssueJsonPath | ConvertTo-Json -Depth 10
}
