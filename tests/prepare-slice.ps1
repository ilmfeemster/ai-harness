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
$testRepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

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

$draftRepository = Join-Path ([IO.Path]::GetTempPath()) ('draft-slice-tests-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $draftRepository -Force | Out-Null
Copy-Item -LiteralPath (Join-Path $contextFixtureDirectory 'repository') -Destination $draftRepository -Recurse

try {
    $draftRoot = Join-Path $draftRepository 'repository'
    $draftCurrentSlice = Join-Path $draftRoot 'docs/current-slice.md'
    New-Item -ItemType Directory -Path (Join-Path $draftRoot 'templates/docs') -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $testRepositoryRoot 'templates/docs/current-slice.md') -Destination (Join-Path $draftRoot 'templates/docs/current-slice.md')
    [IO.File]::WriteAllText($draftCurrentSlice, "## Status`nComplete`n", (New-Object Text.UTF8Encoding($false)))
    $normalized10 = Get-NormalizedIssueContractFromFile -Path (Join-Path $contextFixtureDirectory 'normalized/issue-10.json')
    $draftManifest = Resolve-ContextManifest -NormalizedIssue $normalized10 -RepositoryRoot $draftRoot -OutputPath 'docs/context-manifests/10.md'
    Write-ContextManifest -Manifest $draftManifest -ManifestOutputRoot (Join-Path $draftRoot 'docs/context-manifests') | Out-Null
    $dependencyNumbers = New-Object 'System.Collections.Generic.List[int]'
    $dependencyReader = {
        param($number)
        $dependencyNumbers.Add([int]$number)
        return 'CLOSED'
    }

    $generated = Invoke-DraftSliceGeneration `
        -NormalizedIssueJsonPath (Join-Path $contextFixtureDirectory 'normalized/issue-10.json') `
        -ContextManifestPath 'docs/context-manifests/10.md' `
        -RepositoryRoot $draftRoot `
        -DependencyStateReader $dependencyReader
    Assert-True $generated.Generated 'A valid bounded context should generate a Draft slice.'
    Assert-Equal (Get-DraftCurrentSliceState -RepositoryRoot $draftRoot -FileReader $null).Status 'Draft' 'Generated slice should have Draft status.'
    $generatedContent = Get-Content -Raw -LiteralPath $draftCurrentSlice
    Assert-True ($generatedContent -match 'The current phase needs guarded drafting.') 'Generated slice should preserve the normalized Context.'
    Assert-True ($generatedContent -match '(?m)^- \*\*Issue:\*\* #10 - Draft a bounded slice$') 'Generated slice should retain source Issue traceability.'
    Assert-True ($generatedContent -match '(?m)^- `AGENTS.md`$') 'Generated slice should retain selected governing documents.'
    Assert-True (($dependencyNumbers -join ',') -eq '8,9') 'Dependencies should normalize, deduplicate, and resolve in sequence order.'
    $updatedManifest = Get-Content -Raw -LiteralPath (Join-Path $draftRoot 'docs/context-manifests/10.md')
    Assert-True ($updatedManifest -match '(?m)^-\s+Draft output status:\s+Draft\.$') 'Successful generation should record Draft output in the matching manifest.'

    $priorDraft = Get-Content -Raw -LiteralPath $draftCurrentSlice
    [IO.File]::WriteAllText($draftCurrentSlice, "## Status`nApproved`n", (New-Object Text.UTF8Encoding($false)))
    $blocked = Invoke-DraftSliceGeneration `
        -NormalizedIssueJsonPath (Join-Path $contextFixtureDirectory 'normalized/issue-10.json') `
        -ContextManifestPath 'docs/context-manifests/10.md' `
        -RepositoryRoot $draftRoot `
        -DependencyStateReader $dependencyReader
    Assert-True (-not $blocked.Generated) 'An unresolved current slice should block replacement.'
    Assert-True ((Get-Content -Raw -LiteralPath $draftCurrentSlice) -match '(?m)^Approved$') 'A blocked generation must preserve the active slice.'
    Assert-True (@($blocked.Blockers | Where-Object { $_.Category -eq 'Active slice' }).Count -eq 1) 'Blocked generation should report the active-slice guard.'
    $blockedManifest = Get-Content -Raw -LiteralPath (Join-Path $draftRoot 'docs/context-manifests/10.md')
    Assert-True ($blockedManifest -match '(?m)^-\s+Draft output status:\s+Blocked\.$') 'Blocked generation should update only the matching manifest result.'

    [IO.File]::WriteAllText($draftCurrentSlice, $priorDraft, (New-Object Text.UTF8Encoding($false)))
    $openDependencyReader = { param($number) if ([int]$number -eq 9) { return 'OPEN' } return 'CLOSED' }
    $dependencyBlocked = Invoke-DraftSliceGeneration `
        -NormalizedIssueJsonPath (Join-Path $contextFixtureDirectory 'normalized/issue-10.json') `
        -ContextManifestPath 'docs/context-manifests/10.md' `
        -RepositoryRoot $draftRoot `
        -DependencyStateReader $openDependencyReader
    Assert-True (-not $dependencyBlocked.Generated) 'An open dependency should block generation.'
    Assert-True (@($dependencyBlocked.Blockers | Where-Object { $_.Category -eq 'Dependency state' }).Count -eq 1) 'Open dependencies should produce a dependency-state blocker.'

    $resetManifestContent = ConvertTo-ManifestMarkdown -Manifest $draftManifest
    [IO.File]::WriteAllText((Join-Path $draftRoot 'docs/context-manifests/10.md'), $resetManifestContent, (New-Object Text.UTF8Encoding($false)))
    [IO.File]::WriteAllText($draftCurrentSlice, "## Status`nComplete`n", (New-Object Text.UTF8Encoding($false)))
    $closedSource = $normalized10 | ConvertTo-Json -Depth 10 | ConvertFrom-Json
    $closedSource.Source.State = 'CLOSED'
    $closedPath = Join-Path $draftRepository 'closed-source.json'
    [IO.File]::WriteAllText($closedPath, ($closedSource | ConvertTo-Json -Depth 10), (New-Object Text.UTF8Encoding($false)))
    $closedBlocked = Invoke-DraftSliceGeneration `
        -NormalizedIssueJsonPath $closedPath `
        -ContextManifestPath 'docs/context-manifests/10.md' `
        -RepositoryRoot $draftRoot `
        -DependencyStateReader $dependencyReader
    Assert-True (@($closedBlocked.Blockers | Where-Object { $_.Category -eq 'Source Issue' }).Count -eq 1) 'A closed normalized source Issue should block generation.'

    [IO.File]::WriteAllText((Join-Path $draftRoot 'docs/context-manifests/10.md'), $resetManifestContent, (New-Object Text.UTF8Encoding($false)))
    $uncheckedSource = $normalized10 | ConvertTo-Json -Depth 10 | ConvertFrom-Json
    $uncheckedSource.Readiness[0].Checked = $false
    $uncheckedPath = Join-Path $draftRepository 'unchecked-source.json'
    [IO.File]::WriteAllText($uncheckedPath, ($uncheckedSource | ConvertTo-Json -Depth 10), (New-Object Text.UTF8Encoding($false)))
    $uncheckedBlocked = Invoke-DraftSliceGeneration `
        -NormalizedIssueJsonPath $uncheckedPath `
        -ContextManifestPath 'docs/context-manifests/10.md' `
        -RepositoryRoot $draftRoot `
        -DependencyStateReader $dependencyReader
    Assert-True (@($uncheckedBlocked.Blockers | Where-Object { $_.Category -eq 'Readiness' }).Count -eq 1) 'An unchecked readiness confirmation should block generation.'

    $manifestWithMissingPath = $resetManifestContent -replace '(?m)^- \*\*docs/testing\.md\*\*.*$', '- **docs/missing.md** - selected'
    [IO.File]::WriteAllText((Join-Path $draftRoot 'docs/context-manifests/10.md'), $manifestWithMissingPath, (New-Object Text.UTF8Encoding($false)))
    $missingDocumentBlocked = Invoke-DraftSliceGeneration `
        -NormalizedIssueJsonPath (Join-Path $contextFixtureDirectory 'normalized/issue-10.json') `
        -ContextManifestPath 'docs/context-manifests/10.md' `
        -RepositoryRoot $draftRoot `
        -DependencyStateReader $dependencyReader
    Assert-True (@($missingDocumentBlocked.Blockers | Where-Object { $_.Category -eq 'Selected document' }).Count -eq 1) 'A missing selected document should block generation.'

    [IO.File]::WriteAllText((Join-Path $draftRoot 'docs/context-manifests/10.md'), $resetManifestContent, (New-Object Text.UTF8Encoding($false)))
    foreach ($unresolvedStatus in @('Draft', 'Approved', 'In progress', 'Blocked', 'Ready for review')) {
        [IO.File]::WriteAllText($draftCurrentSlice, "## Status`n$unresolvedStatus`n", (New-Object Text.UTF8Encoding($false)))
        $statusBlocked = Invoke-DraftSliceGeneration `
            -NormalizedIssueJsonPath (Join-Path $contextFixtureDirectory 'normalized/issue-10.json') `
            -ContextManifestPath 'docs/context-manifests/10.md' `
            -RepositoryRoot $draftRoot `
            -DependencyStateReader $dependencyReader
        Assert-True (@($statusBlocked.Blockers | Where-Object { $_.Category -eq 'Active slice' }).Count -eq 1) "Active slice status '$unresolvedStatus' should block replacement."
    }
}
finally {
    if (Test-Path -LiteralPath $draftRepository) { Remove-Item -LiteralPath $draftRepository -Recurse -Force }
}

$workflowRepository = Join-Path ([IO.Path]::GetTempPath()) ('manual-workflow-tests-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $workflowRepository -Force | Out-Null
Copy-Item -LiteralPath (Join-Path $contextFixtureDirectory 'repository') -Destination $workflowRepository -Recurse

try {
    $workflowRoot = Join-Path $workflowRepository 'repository'
    New-Item -ItemType Directory -Path (Join-Path $workflowRoot 'templates/docs') -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $testRepositoryRoot 'templates/docs/current-slice.md') -Destination (Join-Path $workflowRoot 'templates/docs/current-slice.md')
    Copy-Item -LiteralPath (Join-Path $workflowRoot 'docs/design/approved.md') -Destination (Join-Path $workflowRoot 'docs/design/phase-1-context-and-slice-assistance.md')
    $workflowSlicePath = Join-Path $workflowRoot 'docs/current-slice.md'
    [IO.File]::WriteAllText($workflowSlicePath, "## Status`nComplete`n", (New-Object Text.UTF8Encoding($false)))
    New-Item -ItemType Directory -Path (Join-Path $workflowRoot 'docs/context-manifests') -Force | Out-Null
    $otherManifestPath = Join-Path $workflowRoot 'docs/context-manifests/10.md'
    [IO.File]::WriteAllText($otherManifestPath, 'issue-10-sentinel', (New-Object Text.UTF8Encoding($false)))
    $otherManifestBefore = Get-Content -Raw -LiteralPath $otherManifestPath
    $workflowIssueFixture = Join-Path $fixtureDirectory 'manual-workflow.json'
    $workflowIssueReader = { param($number) Get-IssueSnapshotFromFile -Path $workflowIssueFixture }
    $workflowDependencyReader = { param($number) return 'CLOSED' }
    $workflowResult = Invoke-PreparationWorkflow `
        -IssueNumber 11 `
        -RepositoryRoot $workflowRoot `
        -IssueSnapshotReader $workflowIssueReader `
        -DependencyStateReader $workflowDependencyReader
    Assert-True $workflowResult.Prepared 'Integrated workflow should prepare a valid explicit Issue.'
    Assert-Equal $workflowResult.Stage 'Draft' 'Integrated success should report Draft stage.'
    Assert-Equal $workflowResult.ManifestPath 'docs/context-manifests/11.md' 'Integrated success should report the matching manifest path.'
    Assert-Equal $workflowResult.DraftPath 'docs/current-slice.md' 'Integrated success should report the fixed Draft path.'
    Assert-Equal $workflowResult.BlockerCount 0 'Integrated success should have no blockers.'
    Assert-True (Test-Path -LiteralPath (Join-Path $workflowRoot 'docs/context-manifests/11.md') -PathType Leaf) 'Integrated success should write the matching context manifest.'
    Assert-Equal (Get-Content -Raw -LiteralPath $otherManifestPath) $otherManifestBefore 'Integrated success should not modify another Issue manifest.'
    Assert-True ((Get-DraftCurrentSliceState -RepositoryRoot $workflowRoot -FileReader $null).Status -eq 'Draft') 'Integrated success should write a Draft active slice.'
    Assert-True ((Get-Content -Raw -LiteralPath $workflowSlicePath) -match 'Deliver and exercise the single manually invoked Phase 1 workflow') 'Integrated success should preserve the normalized source contract.'
    $firstWorkflowDraft = Get-Content -Raw -LiteralPath $workflowSlicePath

    $priorWorkflowSlice = Get-Content -Raw -LiteralPath $workflowSlicePath
    [IO.File]::WriteAllText($workflowSlicePath, "## Status`nApproved`n", (New-Object Text.UTF8Encoding($false)))
    $workflowBlocked = Invoke-PreparationWorkflow `
        -IssueNumber 11 `
        -RepositoryRoot $workflowRoot `
        -IssueSnapshotReader $workflowIssueReader `
        -DependencyStateReader $workflowDependencyReader
    Assert-True (-not $workflowBlocked.Prepared) 'Integrated workflow should block an unresolved active slice.'
    Assert-Equal $workflowBlocked.Stage 'Draft' 'Active-slice failure should be reported by the Draft stage.'
    Assert-True (@($workflowBlocked.Blockers | Where-Object { $_.Category -eq 'Active slice' }).Count -eq 1) 'Integrated active-slice failure should preserve the guard category.'
    Assert-True ((Get-Content -Raw -LiteralPath $workflowSlicePath) -match '(?m)^Approved$') 'Integrated active-slice failure should preserve the prior slice.'

    [IO.File]::WriteAllText($workflowSlicePath, "## Status`nComplete`n", (New-Object Text.UTF8Encoding($false)))
    $workflowRepeat = Invoke-PreparationWorkflow `
        -IssueNumber 11 `
        -RepositoryRoot $workflowRoot `
        -IssueSnapshotReader $workflowIssueReader `
        -DependencyStateReader $workflowDependencyReader
    Assert-True $workflowRepeat.Prepared 'Integrated workflow should succeed again after a permitted Complete reset.'
    Assert-Equal (Get-Content -Raw -LiteralPath $workflowSlicePath) $firstWorkflowDraft 'Repeated integrated success should produce byte-identical Draft content.'
    Assert-Equal (Get-Content -Raw -LiteralPath $otherManifestPath) $otherManifestBefore 'Repeated integrated success should preserve another Issue manifest.'

    [IO.File]::WriteAllText($workflowSlicePath, $priorWorkflowSlice, (New-Object Text.UTF8Encoding($false)))
    Remove-Item -LiteralPath (Join-Path $workflowRoot 'docs/testing.md') -Force
    $workflowContextBlocked = Invoke-PreparationWorkflow `
        -IssueNumber 11 `
        -RepositoryRoot $workflowRoot `
        -IssueSnapshotReader $workflowIssueReader `
        -DependencyStateReader $workflowDependencyReader
    Assert-True (-not $workflowContextBlocked.Prepared) 'Integrated workflow should block missing context authority.'
    Assert-Equal $workflowContextBlocked.Stage 'Context' 'Missing context authority should be reported by the Context stage.'
    Assert-True (@($workflowContextBlocked.Blockers | Where-Object { $_.Path -eq 'docs/testing.md' }).Count -ge 1) 'Integrated context failure should identify the missing authority.'
    Assert-True ((Get-Content -Raw -LiteralPath $workflowSlicePath) -match '(?m)^Draft$') 'Integrated context failure should preserve the prior active slice.'

    $failureRepository = Join-Path ([IO.Path]::GetTempPath()) ('manual-workflow-prerequisite-' + [guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $failureRepository -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $contextFixtureDirectory 'repository') -Destination $failureRepository -Recurse
    try {
        $failureRoot = Join-Path $failureRepository 'repository'
        $failureReader = { param($number) throw 'fixture source unavailable' }
        $failureResult = Invoke-PreparationWorkflow -IssueNumber 11 -RepositoryRoot $failureRoot -IssueSnapshotReader $failureReader
        Assert-True (-not $failureResult.Prepared) 'Source prerequisite failure should not prepare a workflow.'
        Assert-Equal $failureResult.Stage 'Normalization' 'Source prerequisite failure should report Normalization stage.'
        Assert-True (-not (Test-Path -LiteralPath (Join-Path $failureRoot 'docs/context-manifests/11.md'))) 'Source prerequisite failure should not write a manifest.'
        Assert-True ($failureResult.Blockers[0].Message -notmatch 'fixture source unavailable') 'Workflow failures should sanitize reader exception details.'

        $parserReader = {
            param($number)
            return [pscustomobject]@{ number = 11; title = 'Invalid fixture'; url = 'https://github.com/ilmfeemster/ai-harness/issues/11'; state = 'OPEN'; body = '## Unsupported form`n`nNo supported headings.' }
        }
        $parserResult = Invoke-PreparationWorkflow -IssueNumber 11 -RepositoryRoot $failureRoot -IssueSnapshotReader $parserReader
        Assert-True (-not $parserResult.Prepared) 'Parser failure should not prepare a workflow.'
        Assert-Equal $parserResult.Stage 'Normalization' 'Parser failure should report Normalization stage.'
        Assert-Equal $parserResult.Blockers[0].Category 'Parser' 'Parser failure should report the Parser category.'
        Assert-True (-not (Test-Path -LiteralPath (Join-Path $failureRoot 'docs/context-manifests/11.md'))) 'Parser failure should not write a manifest.'
    }
    finally {
        if (Test-Path -LiteralPath $failureRepository) { Remove-Item -LiteralPath $failureRepository -Recurse -Force }
    }
}
finally {
    if (Test-Path -LiteralPath $workflowRepository) { Remove-Item -LiteralPath $workflowRepository -Recurse -Force }
}

Write-Output 'Prepare-slice parser tests passed.'
