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

    $missingSection = $originalSlice -replace '(?ms)^## Review checklist\r?\n.*?(?=^## Completion evidence)', ''
    Write-FixtureFile $slicePath $missingSection
    Assert-ValidationFailure (Get-ValidationResult $fixtureRoot) 'missing slice section fixture' 'current-slice.md is missing required section: ## Review checklist'

    Write-FixtureFile $slicePath ($originalSlice + "`r`n[Work Item Title]`r`n")
    Assert-ValidationFailure (Get-ValidationResult $fixtureRoot) 'unresolved placeholder fixture' 'current-slice.md contains an unresolved scaffold placeholder matching: \[Work Item Title\]'

    Write-FixtureFile $slicePath $originalSlice
    Remove-Item -LiteralPath (Join-Path $fixtureRoot '.github/ISSUE_TEMPLATE/implementation.yml') -Force
    Assert-ValidationFailure (Get-ValidationResult $fixtureRoot) 'missing Issue template fixture' 'Missing required file: .github/ISSUE_TEMPLATE/implementation.yml'

    $templatePath = Join-Path $fixtureRoot 'templates/docs/current-slice.md'
    $template = [System.IO.File]::ReadAllText($templatePath)
    Write-FixtureFile $templatePath ($template + "`r`nAI Development Harness`r`n")
    Assert-ValidationFailure (Get-ValidationResult $fixtureRoot) 'reusable asset leakage fixture' 'Reusable asset contains harness-specific active state'

    Write-FixtureFile $templatePath $template
    Remove-Item -LiteralPath (Join-Path $fixtureRoot 'skills/validate-slice/SKILL.md') -Force
    Assert-ValidationFailure (Get-ValidationResult $fixtureRoot) 'missing referenced path fixture' 'current-slice.md references a missing local path: skills/validate-slice/SKILL.md'

    Write-Output 'Validator tests passed.'
    exit 0
} finally {
    if (Test-Path -LiteralPath $fixtureRoot) {
        Remove-Item -LiteralPath $fixtureRoot -Recurse -Force
    }
}
