[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
. (Join-Path $repositoryRoot 'scripts/validate.ps1') -Library

function Assert-ValidationPass {
    param(
        [pscustomobject]$Result,
        [string]$Description
    )

    if (-not $Result.Passed) {
        throw "$Description failed: $($Result.Failures -join '; ')"
    }
}

function Assert-ValidationFailure {
    param(
        [pscustomobject]$Result,
        [string]$Description,
        [string]$ExpectedMessage
    )

    if ($Result.Passed) {
        throw "$Description unexpectedly passed."
    }

    if ($Result.Failures -notcontains $ExpectedMessage -and (($Result.Failures -join "`n") -notmatch [regex]::Escape($ExpectedMessage))) {
        throw "$Description did not report the expected actionable failure: $ExpectedMessage"
    }
}

function Write-FixtureFile {
    param(
        [string]$Path,
        [string]$Content
    )

    [System.IO.File]::WriteAllText($Path, $Content, (New-Object System.Text.UTF8Encoding($false)))
}

$fixtureRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('ai-harness-validation-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $fixtureRoot | Out-Null

try {
    foreach ($item in Get-ChildItem -LiteralPath $repositoryRoot -Force) {
        if ($item.Name -in @('.git', '.agents')) {
            continue
        }

        Copy-Item -LiteralPath $item.FullName -Destination (Join-Path $fixtureRoot $item.Name) -Recurse -Force
    }

    Assert-ValidationPass (Get-ValidationResult $fixtureRoot) 'valid repository fixture'

    $slicePath = Join-Path $fixtureRoot 'docs/current-slice.md'
    $originalSlice = [System.IO.File]::ReadAllText($slicePath)

    if ([string]::IsNullOrWhiteSpace($originalSlice)) {
        $originalSlice = @'
# Fixture Work Item

## Status

Draft

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

## Implementation plan

1. Perform the fixture step.

## Expected files

- `README.md`
- `skills/validate-slice/SKILL.md`

## Validation plan

```powershell
powershell -NoProfile -File scripts/validate.ps1
```

## Failure conditions

Stop if the fixture fails.

## Review checklist

- Does the fixture remain bounded?

## Completion evidence

Pending.
'@
        Write-FixtureFile $slicePath $originalSlice
    }

    Write-FixtureFile $slicePath ''
    Assert-ValidationPass (Get-ValidationResult $fixtureRoot) 'empty current slice fixture'
    Write-FixtureFile $slicePath $originalSlice

    $missingSection = $originalSlice -replace '(?ms)^## Review checklist\r?\n.*?(?=^## Completion evidence)', ''
    Write-FixtureFile $slicePath $missingSection
    Assert-ValidationFailure (Get-ValidationResult $fixtureRoot) 'missing slice section fixture' 'current-slice.md is missing required section: ## Review checklist'

    Write-FixtureFile $slicePath ($originalSlice + "`r`n[Work Item Title]`r`n")
    Assert-ValidationFailure (Get-ValidationResult $fixtureRoot) 'unresolved placeholder fixture' 'current-slice.md contains an unresolved scaffold placeholder matching: \[Work Item Title\]'

    Write-FixtureFile $slicePath $originalSlice
    $implementationPath = Join-Path $fixtureRoot '.github/ISSUE_TEMPLATE/implementation.yml'
    $implementation = [System.IO.File]::ReadAllText($implementationPath)
    Remove-Item -LiteralPath $implementationPath -Force
    Assert-ValidationFailure (Get-ValidationResult $fixtureRoot) 'missing Issue template fixture' 'Missing required file: .github/ISSUE_TEMPLATE/implementation.yml'
    Write-FixtureFile $implementationPath $implementation

    $templatePath = Join-Path $fixtureRoot 'templates/docs/current-slice.md'
    $template = [System.IO.File]::ReadAllText($templatePath)
    Write-FixtureFile $templatePath ($template + "`r`nAI Development Harness`r`n")
    Assert-ValidationFailure (Get-ValidationResult $fixtureRoot) 'reusable asset leakage fixture' 'Reusable asset contains harness-specific active state'

    Write-FixtureFile $templatePath $template

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
    Assert-ValidationFailure (Get-ValidationResult $fixtureRoot -InitializedProject) 'initialized project leakage fixture' 'Project-owned document contains source-context leakage'
    Write-FixtureFile $projectDocumentPath $projectDocument

    Write-FixtureFile $slicePath '# Copied active state'
    Assert-ValidationFailure (Get-ValidationResult $fixtureRoot -InitializedProject -CleanInitialization) 'non-empty clean initialization slice fixture' 'Clean initialized project must leave docs/current-slice.md empty.'
    Write-FixtureFile $slicePath ''

    $startProjectPath = Join-Path $fixtureRoot 'skills/start-project/SKILL.md'
    $startProjectSkill = [System.IO.File]::ReadAllText($startProjectPath)
    Remove-Item -LiteralPath $startProjectPath -Force
    Assert-ValidationFailure (Get-ValidationResult $fixtureRoot) 'missing project-start skill fixture' 'Missing required file: skills/start-project/SKILL.md'
    Write-FixtureFile $startProjectPath $startProjectSkill

    Write-FixtureFile $slicePath $originalSlice
    Remove-Item -LiteralPath (Join-Path $fixtureRoot 'skills/validate-slice/SKILL.md') -Force
    Assert-ValidationFailure (Get-ValidationResult $fixtureRoot) 'missing referenced path fixture' 'current-slice.md references a missing local path: skills/validate-slice/SKILL.md'

    Write-Output 'Validator tests passed.'
    exit 0
} finally {
    if (Test-Path -LiteralPath $fixtureRoot) {
        Remove-Item -LiteralPath $fixtureRoot -Recurse -Force
    }
}
