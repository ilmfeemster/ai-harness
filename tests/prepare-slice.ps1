[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
. (Join-Path $repositoryRoot 'scripts/prepare-slice.ps1') -NoRun

function Assert-Equal {
    param(
        $Actual,
        $Expected,
        [string]$Description
    )

    if ($Actual -ne $Expected) {
        throw "$Description. Expected '$Expected'; received '$Actual'."
    }
}

function Assert-True {
    param(
        [bool]$Condition,
        [string]$Description
    )

    if (-not $Condition) {
        throw $Description
    }
}

function Assert-Throws {
    param(
        [scriptblock]$Action,
        [string]$ExpectedMessage,
        [string]$Description
    )

    try {
        & $Action
    }
    catch {
        if ($_.Exception.Message -notmatch [regex]::Escape($ExpectedMessage)) {
            throw "$Description. Expected error containing '$ExpectedMessage'; received '$($_.Exception.Message)'."
        }
        return
    }

    throw "$Description unexpectedly succeeded."
}

$fixtureDirectory = Join-Path $PSScriptRoot 'fixtures/issues'
$contextFixtureDirectory = Join-Path $PSScriptRoot 'fixtures/context'

$implementation = Invoke-IssueNormalization -FixturePath (Join-Path $fixtureDirectory 'implementation.json')
Assert-Equal $implementation.IssueType 'Implementation' 'Implementation fixture type'
Assert-Equal $implementation.Source.Number 101 'Implementation fixture source number'
Assert-Equal $implementation.WorkType 'Feature' 'Implementation fixture work type'
Assert-True (@($implementation.Readiness).Count -eq 7) 'Implementation fixture should retain every readiness confirmation.'
Assert-True (@($implementation.Readiness | Where-Object { -not $_.Checked }).Count -eq 0) 'Implementation fixture should retain checked readiness confirmations.'
Assert-True ($implementation.Source.UnparsedBody -match '## Goal') 'Implementation fixture should retain the unparsed body.'

$bug = Invoke-IssueNormalization -FixturePath (Join-Path $fixtureDirectory 'bug.json')
Assert-Equal $bug.IssueType 'Bug' 'Bug fixture type'
Assert-Equal $bug.WorkType 'Bug' 'Bug fixture work type'
Assert-True ($bug.Bug.ObservedBehavior -match 'parser') 'Bug fixture should preserve observed behavior.'
Assert-True ($bug.Bug.ExpectedBehavior -match 'required') 'Bug fixture should preserve expected behavior.'
Assert-True ($bug.Bug.Evidence -match 'fixture') 'Bug fixture should preserve evidence.'
Assert-True ($bug.Bug.Impact -match 'promotion') 'Bug fixture should preserve impact.'

Assert-Throws { Invoke-IssueNormalization -FixturePath (Join-Path $fixtureDirectory 'unsupported.json') } 'does not match exactly one supported' 'Unsupported-form fixture'
Assert-Throws { Invoke-IssueNormalization -FixturePath (Join-Path $fixtureDirectory 'missing-goal.json') } "missing required section '## Goal'" 'Missing-field fixture'
Assert-Throws { Invoke-IssueNormalization -FixturePath (Join-Path $fixtureDirectory 'closed.json') } 'is not open' 'Closed-Issue fixture'
Assert-Throws { Invoke-IssueNormalization -FixturePath (Join-Path $fixtureDirectory 'missing.json') } 'does not exist' 'Unreadable-data fixture'

$pathInput = @'
- `docs/linked.md`
- docs/linked.md
- scripts/prepare-slice.ps1
- https://example.test/a.md
- ../escape.md
- `docs/other.md`
'@
$paths = @(Get-RelevantDocumentPaths -RelevantDocuments $pathInput)
Assert-True (@($paths | Where-Object { $_.Accepted -and $_.Path -eq 'docs/linked.md' }).Count -eq 1) 'Path parser should retain the first accepted spelling.'
Assert-True (@($paths | Where-Object { $_.Classification -eq 'Duplicate' }).Count -eq 1) 'Path parser should report duplicate entries.'
Assert-True (@($paths | Where-Object { $_.Classification -eq 'Rejected' }).Count -eq 2) 'Path parser should reject URLs and traversal paths.'
Assert-True (@($paths | Where-Object { $_.Path -eq 'scripts/prepare-slice.ps1' }).Count -eq 1) 'Path parser should preserve outside-boundary paths for classification.'

$contextRepository = Join-Path ([IO.Path]::GetTempPath()) ('context-manifest-tests-' + [guid]::NewGuid().ToString('N'))
$contextOutput = Join-Path $contextRepository 'manifests'
New-Item -ItemType Directory -Path $contextRepository -Force | Out-Null
Copy-Item -LiteralPath (Join-Path $contextFixtureDirectory 'repository') -Destination $contextRepository -Recurse

try {
    $normalized9 = Get-NormalizedIssueContractFromFile -Path (Join-Path $contextFixtureDirectory 'normalized/issue-9.json')
    $manifest9 = Resolve-ContextManifest -NormalizedIssue $normalized9 -RepositoryRoot (Join-Path $contextRepository 'repository') -OutputPath 'manifests/9.md'
    Assert-True (@($manifest9.Selected | Where-Object { $_.Path -eq 'AGENTS.md' }).Count -eq 1) 'Manifest should select mandatory authority.'
    Assert-True (@($manifest9.Selected | Where-Object { $_.Path -eq 'docs/linked.md' -and $_.Reason -eq 'linked by source Issue' }).Count -eq 1) 'Manifest should select an allowed linked document.'
    Assert-True (@($manifest9.Selected | Where-Object { $_.Path -eq 'docs/design/approved.md' }).Count -eq 1) 'Manifest should select an explicitly linked Approved design.'
    Assert-True (@($manifest9.Considered | Where-Object { $_.Path -eq 'docs/design/draft.md' }).Count -eq 1) 'Manifest should retain Draft designs as excluded candidates.'
    Assert-True (@($manifest9.Warnings | Where-Object { $_.Path -eq 'docs/design/unlinked.md' }).Count -eq 1) 'Manifest should warn about unlinked Approved designs.'
    Assert-True ($manifest9.DownstreamReady) 'Complete context fixture should be downstream-ready.'

    $rendered9 = ConvertTo-ManifestMarkdown -Manifest $manifest9
    Assert-True ($rendered9 -match [regex]::Escape("# Context Manifest $([char]0x2014) Issue #9")) 'Manifest should render the required em-dash top-level heading.'
    foreach ($heading in @('## Preparation', '## Source Issue', '## Readiness', '## Selected governing documents', '## Considered but not selected', '## Warnings', '## Blockers', '## Output')) {
        Assert-True ($rendered9 -match [regex]::Escape($heading)) "Manifest should render heading '$heading'."
    }
    Assert-True ($rendered9 -notmatch 'The manifest records bounded local authority') 'Manifest must not copy full document content.'

    $missingLinked = $normalized9 | ConvertTo-Json -Depth 10 | ConvertFrom-Json
    $missingLinked.RelevantDocuments = 'docs/missing.md'
    $missingManifest = Resolve-ContextManifest -NormalizedIssue $missingLinked -RepositoryRoot (Join-Path $contextRepository 'repository') -OutputPath 'manifests/missing.md'
    Assert-True (@($missingManifest.Blockers | Where-Object { $_.Path -eq 'docs/missing.md' }).Count -eq 1) 'Missing linked documents should block context readiness.'
    Assert-True (-not $missingManifest.DownstreamReady) 'Missing linked documents should make downstream readiness false.'

    Remove-Item -LiteralPath (Join-Path $contextRepository 'repository/docs/testing.md') -Force
    $missingMandatory = Resolve-ContextManifest -NormalizedIssue $normalized9 -RepositoryRoot (Join-Path $contextRepository 'repository') -OutputPath 'manifests/mandatory.md'
    Assert-True (@($missingMandatory.Blockers | Where-Object { $_.Path -eq 'docs/testing.md' }).Count -eq 1) 'Missing mandatory authority should block context readiness.'

    $a1Repository = Join-Path ([IO.Path]::GetTempPath()) ('context-manifest-a1-' + [guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $a1Repository -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $contextFixtureDirectory 'repository') -Destination $a1Repository -Recurse
    $normalized10 = Get-NormalizedIssueContractFromFile -Path (Join-Path $contextFixtureDirectory 'normalized/issue-10.json')
    $a1Manifest = Resolve-ContextManifest -NormalizedIssue $normalized10 -RepositoryRoot (Join-Path $a1Repository 'repository') -OutputPath 'manifests/10.md'
    Assert-True (@($a1Manifest.Selected | Where-Object { $_.Path -eq 'docs/design/approved.md' -and $_.Reason -match 'Assumption A-1' }).Count -eq 1) 'Exact active-phase mapping should select the expected Approved design through A-1.'
    Assert-True (@($a1Manifest.Warnings | Where-Object { $_.Path -eq 'docs/design/approved.md' -and $_.Message -match 'human review' }).Count -eq 1) 'A-1 selection should require human review.'
    Remove-Item -LiteralPath (Join-Path $a1Repository 'repository/docs/issues/phase-1/issue-10.md') -Force
    $unmapped = Resolve-ContextManifest -NormalizedIssue $normalized10 -RepositoryRoot (Join-Path $a1Repository 'repository') -OutputPath 'manifests/10-unmapped.md'
    Assert-True (@($unmapped.Selected | Where-Object { $_.Path -eq 'docs/design/approved.md' }).Count -eq 0) 'Unmapped expected designs must remain non-governing.'
    Assert-True (@($unmapped.Warnings | Where-Object { $_.Path -eq 'docs/design/approved.md' -and $_.Message -match 'incomplete' }).Count -eq 1) 'Unmapped expected designs should produce an actionable warning.'
    Remove-Item -LiteralPath $a1Repository -Recurse -Force

    $secretIssue = $normalized9 | ConvertTo-Json -Depth 10 | ConvertFrom-Json
    $secretIssue.RelevantDocuments = 'C:\Users\Focus Mode\secret-token.txt'
    $secretManifest = Resolve-ContextManifest -NormalizedIssue $secretIssue -RepositoryRoot (Join-Path $contextRepository 'repository') -OutputPath 'manifests/secret.md'
    $secretRendered = ConvertTo-ManifestMarkdown -Manifest $secretManifest
    Assert-True ($secretRendered -notmatch 'secret-token|Focus Mode') 'Manifest should sanitize rooted and sensitive rejected entries.'

    $reader = {
        param($path)
        if ($path -match 'docs[\\/]linked\.md') { throw 'token=fixture-secret' }
        return Get-Content -Raw -LiteralPath $path
    }
    $inaccessible = Resolve-ContextManifest -NormalizedIssue $normalized9 -RepositoryRoot (Join-Path $contextRepository 'repository') -OutputPath 'manifests/inaccessible.md' -FileReader $reader
    Assert-True (@($inaccessible.Blockers | Where-Object { $_.Path -eq 'docs/linked.md' }).Count -eq 1) 'Injected reader failures should become sanitized blockers.'
    Assert-True ((ConvertTo-ManifestMarkdown -Manifest $inaccessible) -notmatch 'fixture-secret|token=') 'Manifest should not render reader exception details.'

    $written9 = Write-ContextManifest -Manifest $manifest9 -ManifestOutputRoot $contextOutput
    $normalized10ForWrite = Get-NormalizedIssueContractFromFile -Path (Join-Path $contextFixtureDirectory 'normalized/issue-10.json')
    $manifest10ForWrite = Resolve-ContextManifest -NormalizedIssue $normalized10ForWrite -RepositoryRoot (Join-Path $contextRepository 'repository') -OutputPath 'manifests/10.md'
    $written10 = Write-ContextManifest -Manifest $manifest10ForWrite -ManifestOutputRoot $contextOutput
    $issue10Before = Get-Content -Raw -LiteralPath $written10
    $manifest9.PreparationTimestamp = 'fixed-for-overwrite-test'
    Write-ContextManifest -Manifest $manifest9 -ManifestOutputRoot $contextOutput | Out-Null
    Assert-True ((Get-Content -Raw -LiteralPath $written10) -eq $issue10Before) 'Writing Issue 9 must not alter Issue 10 manifest.'
    Assert-True ((Get-Content -Raw -LiteralPath $written9) -match 'fixed-for-overwrite-test') 'Writing the same Issue should overwrite only its own manifest.'
}
finally {
    if (Test-Path -LiteralPath $contextRepository) { Remove-Item -LiteralPath $contextRepository -Recurse -Force }
}

Write-Output 'Prepare-slice parser tests passed.'
