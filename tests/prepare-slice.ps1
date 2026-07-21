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

Write-Output 'Prepare-slice parser tests passed.'
