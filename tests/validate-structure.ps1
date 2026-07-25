[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
. (Join-Path $repositoryRoot 'scripts/validate.ps1') -Library

function Assert-ValidationPass {
    param([pscustomobject]$Result, [string]$Description)
    if (-not $Result.Passed) {
        throw "$Description failed: $($Result.Failures -join '; ')"
    }
}

function Assert-ValidationFailure {
    param([pscustomobject]$Result, [string]$Description, [string]$ExpectedMessage)
    if ($Result.Passed) { throw "$Description unexpectedly passed." }
    if ($Result.Failures -notcontains $ExpectedMessage -and
        (($Result.Failures -join "`n") -notmatch [regex]::Escape($ExpectedMessage))) {
        throw "$Description did not report: $ExpectedMessage"
    }
}

function Write-FixtureFile {
    param([string]$Path, [string]$Content)
    $parent = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    [System.IO.File]::WriteAllText($Path, $Content, (New-Object System.Text.UTF8Encoding($false)))
}

function Get-ValidSlice {
    param([string]$Status = 'Draft')

    $sliceApproval = if ($Status -eq 'Draft') {
@'
**Slice approval:** Pending.

**Slice approved by:** Pending.

**Slice approval basis:** Pending.

**Slice approved at:** Pending.
'@
    } else {
@'
**Slice approval:** Approved.

**Slice approved by:** Repository owner.

**Slice approval basis:** Approved fixture slice.

**Slice approved at:** 2026-07-24.
'@
    }

    $finalApproval = if ($Status -eq 'Complete') {
@'
**Final approval:** Approved.

**Final approved by:** Repository owner.

**Final approval basis:** Approved completed fixture result.

**Final approved at:** 2026-07-24.
'@
    } else {
@'
**Final approval:** Pending.

**Final approved by:** Pending.

**Final approval basis:** Pending.

**Final approved at:** Pending.
'@
    }

    $acceptance = if ($Status -in @('Ready for review', 'Complete')) { 'Passed.' } else { 'Pending.' }
    $validation = if ($Status -in @('Ready for review', 'Complete')) { 'All declared checks passed.' } else { 'Not run.' }
    $docImpact = if ($Status -in @('Ready for review', 'Complete')) { 'Resolved.' } else { 'Pending.' }
    $review = if ($Status -eq 'Complete') { 'Completed with no blocking findings.' } else { 'Pending.' }
    $closure = if ($Status -eq 'Complete') { 'Issue #1 closed.' } else { 'Pending.' }
    $fence = '```'
    $blocker = if ($Status -eq 'Blocked') {
@'
## Blockers and known limitations

**Blocker:** Fixture dependency is unavailable.

**Required resolution:** Restore the fixture dependency and authorize resumed implementation.
'@
    } else { '' }

@"
# Fixture Work Item

## Status

$Status

## Source Issue

- **Issue:** #1 - Fixture work item
- **URL:** https://github.com/example/project/issues/1

## Context

Fixture context.

## Goal

Fixture goal.

## Scope

- Fixture scope.

## Non-goals

- Fixture non-goal.

## Acceptance criteria

- Fixture criterion.

## Governing-rule reconciliation

| Rule | Governing source | Slice interpretation | Difference |
| --- | --- | --- | --- |
| Preserve fixture behavior | Source Issue | Preserve fixture behavior | None |

## Implementation plan

1. Perform the fixture step.

## Expected files

- README.md
- skills/validate-slice/SKILL.md

## Documentation impact

| Source | Impact | Required action |
| --- | --- | --- |
| README.md | None | None |
| docs/project.md | None | None |
| docs/architecture.md | None | None |
| docs/decisions.md | None | None |
| docs/design/*.md | None | None |
| docs/testing.md | None | None |

## Validation plan

${fence}powershell
powershell -NoProfile -File scripts/validate.ps1
$fence

## Failure conditions

Stop if the fixture fails.

## Review checklist

- Does the fixture remain bounded?

## Approval evidence

$sliceApproval
$finalApproval

## Completion evidence

**Implementation status:** Pending.

**Acceptance-criteria status:** $acceptance

**Files changed:** Pending.

**Validation results:** $validation

**Manual checks:** Pending.

**Documentation-impact result:** $docImpact

**Review result:** $review

**Implementation adjustments or deviations:** None.

**Known limitations or follow-up Issues:** None.

**Issue closure:** $closure

**Implementation summary:** Pending.

$blocker
"@
}

$fixtureRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('ai-harness-validation-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $fixtureRoot | Out-Null

try {
    foreach ($item in Get-ChildItem -LiteralPath $repositoryRoot -Force) {
        if ($item.Name -in @('.git', '.agents')) { continue }
        Copy-Item -LiteralPath $item.FullName -Destination (Join-Path $fixtureRoot $item.Name) -Recurse -Force
    }

    Assert-ValidationPass (Get-ValidationResult $fixtureRoot) 'valid repository fixture'

    $slicePath = Join-Path $fixtureRoot 'docs/current-slice.md'
    $draft = Get-ValidSlice 'Draft'

    Write-FixtureFile $slicePath ''
    Assert-ValidationPass (Get-ValidationResult $fixtureRoot) 'empty current slice fixture'

    Write-FixtureFile $slicePath $draft
    Assert-ValidationPass (Get-ValidationResult $fixtureRoot) 'valid Draft fixture'

    foreach ($state in @('Approved', 'In progress', 'Blocked', 'Ready for review', 'Complete')) {
        Write-FixtureFile $slicePath (Get-ValidSlice $state)
        Assert-ValidationPass (Get-ValidationResult $fixtureRoot) "valid $state fixture"
    }

    $missingSection = $draft -replace '(?ms)^## Review checklist\r?\n.*?(?=^## Approval evidence)', ''
    Write-FixtureFile $slicePath $missingSection
    Assert-ValidationFailure (Get-ValidationResult $fixtureRoot) 'missing section' 'current-slice.md is missing required section: ## Review checklist'

    Write-FixtureFile $slicePath ($draft + "`r`n[Work Item Title]`r`n")
    Assert-ValidationFailure (Get-ValidationResult $fixtureRoot) 'placeholder' 'current-slice.md contains an unresolved scaffold placeholder matching: \[Work Item Title\]'

    $badApproved = $draft -replace '(?ms)^## Status\s*\r?\nDraft', "## Status`r`n`r`nApproved"
    Write-FixtureFile $slicePath $badApproved
    Assert-ValidationFailure (Get-ValidationResult $fixtureRoot) 'Approved without evidence' "current-slice.md status 'Approved' requires complete slice-approval evidence."

    $badReady = (Get-ValidSlice 'Ready for review') -replace '\*\*Validation results:\*\* All declared checks passed\.', '**Validation results:** Not run.'
    Write-FixtureFile $slicePath $badReady
    Assert-ValidationFailure (Get-ValidationResult $fixtureRoot) 'Ready without validation' "current-slice.md status 'Ready for review' requires completed validation evidence."

    $badComplete = (Get-ValidSlice 'Complete') -replace '\*\*Final approval:\*\* Approved\.', '**Final approval:** Pending.'
    Write-FixtureFile $slicePath $badComplete
    Assert-ValidationFailure (Get-ValidationResult $fixtureRoot) 'Complete without approval' "current-slice.md status 'Complete' requires complete final-approval evidence."

    $badBlocked = (Get-ValidSlice 'Blocked') -replace '(?ms)^## Blockers and known limitations.*\z', ''
    Write-FixtureFile $slicePath $badBlocked
    Assert-ValidationFailure (Get-ValidationResult $fixtureRoot) 'Blocked without blocker' "current-slice.md status 'Blocked' requires concrete Blocker and Required resolution fields."

    Write-FixtureFile $slicePath $draft
    $approvePath = Join-Path $fixtureRoot 'skills/approve-slice/SKILL.md'
    $approveText = [System.IO.File]::ReadAllText($approvePath)
    Remove-Item -LiteralPath $approvePath -Force
    Assert-ValidationFailure (Get-ValidationResult $fixtureRoot) 'missing approval skill' 'Missing required file: skills/approve-slice/SKILL.md'
    Write-FixtureFile $approvePath $approveText

    $templatePath = Join-Path $fixtureRoot 'templates/docs/current-slice.md'
    $template = [System.IO.File]::ReadAllText($templatePath)
    Write-FixtureFile $templatePath ($template + "`r`nAI Development Harness`r`n")
    Assert-ValidationFailure (Get-ValidationResult $fixtureRoot) 'reusable leakage' 'Reusable asset contains source-project active state'
    Write-FixtureFile $templatePath $template

    Write-FixtureFile $slicePath $draft
    $implementationPath = Join-Path $fixtureRoot '.github/ISSUE_TEMPLATE/implementation.yml'
    $implementationText = [System.IO.File]::ReadAllText($implementationPath)
    Remove-Item -LiteralPath $implementationPath -Force
    Assert-ValidationFailure (Get-ValidationResult $fixtureRoot) 'missing Issue template' 'Missing required file: .github/ISSUE_TEMPLATE/implementation.yml'
    Write-FixtureFile $implementationPath $implementationText

    $cleanReadme = [System.IO.File]::ReadAllText((Join-Path $fixtureRoot 'templates/README.md'))
    Write-FixtureFile (Join-Path $fixtureRoot 'README.md') $cleanReadme
    foreach ($document in @('project', 'roadmap', 'architecture', 'decisions', 'testing')) {
        $templateDocument = Join-Path $fixtureRoot ('templates/docs/' + $document + '.md')
        Write-FixtureFile (Join-Path $fixtureRoot ('docs/' + $document + '.md')) ([System.IO.File]::ReadAllText($templateDocument))
    }
    $designTarget = Join-Path $fixtureRoot 'docs/design/initial-design.md'
    $designTemplate = Join-Path $fixtureRoot 'templates/docs/design.md'
    Write-FixtureFile $designTarget ([System.IO.File]::ReadAllText($designTemplate))
    Write-FixtureFile $slicePath ''
    Assert-ValidationPass (Get-ValidationResult $fixtureRoot -InitializedProject -CleanInitialization) 'clean initialized project fixture'

    $projectDocumentPath = Join-Path $fixtureRoot 'docs/project.md'
    $projectDocument = [System.IO.File]::ReadAllText($projectDocumentPath)
    Write-FixtureFile $projectDocumentPath ($projectDocument + "`r`nAI Development Harness`r`n")
    Assert-ValidationFailure (Get-ValidationResult $fixtureRoot -InitializedProject) 'initialized project leakage' 'Project-owned document contains source-context leakage'
    Write-FixtureFile $projectDocumentPath $projectDocument

    Write-FixtureFile $slicePath '# Copied active state'
    Assert-ValidationFailure (Get-ValidationResult $fixtureRoot -InitializedProject -CleanInitialization) 'non-empty clean slice' 'Clean initialized project must leave docs/current-slice.md empty.'

    Write-FixtureFile $slicePath $draft
    $missingReferenceSlice = $draft -replace '## Expected files\r?\n\r?\n- README.md\r?\n- skills/validate-slice/SKILL.md', "## Expected files`r`n`r`n- README.md"
    $missingReferenceSlice = $missingReferenceSlice -replace '## Review checklist', "## Relevant project documents`r`n`r`n- ``skills/missing-skill/SKILL.md```r`n`r`n## Review checklist"
    Write-FixtureFile $slicePath $missingReferenceSlice
    Assert-ValidationFailure (Get-ValidationResult $fixtureRoot) 'missing referenced path' 'current-slice.md references a missing local path: skills/missing-skill/SKILL.md'

    Write-Output 'Validator tests passed.'
    exit 0
} finally {
    if (Test-Path -LiteralPath $fixtureRoot) {
        Remove-Item -LiteralPath $fixtureRoot -Recurse -Force
    }
}
