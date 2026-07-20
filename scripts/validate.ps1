[CmdletBinding()]
param(
    [string]$Root,
    [switch]$Library
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($Root)) {
    $Root = Split-Path -Parent $PSScriptRoot
}

function Add-ValidationFailure {
    param(
        [System.Collections.Generic.List[string]]$Failures,
        [string]$Message
    )

    [void]$Failures.Add($Message)
}

function Get-RepositoryText {
    param(
        [string]$RepositoryRoot,
        [string]$RelativePath
    )

    $path = Join-Path $RepositoryRoot $RelativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        return $null
    }

    return [System.IO.File]::ReadAllText((Resolve-Path -LiteralPath $path).Path)
}

function Assert-RequiredFile {
    param(
        [System.Collections.Generic.List[string]]$Failures,
        [string]$RepositoryRoot,
        [string]$RelativePath
    )

    if (-not (Test-Path -LiteralPath (Join-Path $RepositoryRoot $RelativePath) -PathType Leaf)) {
        Add-ValidationFailure $Failures "Missing required file: $RelativePath"
    }
}

function Assert-RequiredDirectory {
    param(
        [System.Collections.Generic.List[string]]$Failures,
        [string]$RepositoryRoot,
        [string]$RelativePath
    )

    if (-not (Test-Path -LiteralPath (Join-Path $RepositoryRoot $RelativePath) -PathType Container)) {
        Add-ValidationFailure $Failures "Missing required directory: $RelativePath"
    }
}

function Assert-Pattern {
    param(
        [System.Collections.Generic.List[string]]$Failures,
        [string]$Text,
        [string]$Pattern,
        [string]$Description
    )

    if ($null -eq $Text -or $Text -notmatch $Pattern) {
        Add-ValidationFailure $Failures $Description
    }
}

function Test-CurrentSlice {
    param(
        [System.Collections.Generic.List[string]]$Failures,
        [string]$RepositoryRoot
    )

    $slice = Get-RepositoryText $RepositoryRoot 'docs/current-slice.md'
    if ($null -eq $slice) {
        return
    }

    $requiredHeadings = @(
        '## Status',
        '## Source Issue',
        '## Context',
        '## Goal',
        '## Scope',
        '## Non-goals',
        '## Acceptance criteria',
        '## Implementation plan',
        '## Expected files',
        '## Validation plan',
        '## Failure conditions',
        '## Review checklist',
        '## Completion evidence'
    )

    foreach ($heading in $requiredHeadings) {
        Assert-Pattern $Failures $slice ('(?m)^' + [regex]::Escape($heading) + '\s*$') "current-slice.md is missing required section: $heading"
    }

    $statusMatch = [regex]::Match($slice, '(?ms)^## Status\s*\r?\n(?<status>[^\r\n]+)')
    $allowedStatuses = @('Draft', 'Approved', 'In progress', 'Blocked', 'Ready for review', 'Complete')
    if (-not $statusMatch.Success) {
        Add-ValidationFailure $Failures 'current-slice.md does not declare a lifecycle status.'
    } elseif ($allowedStatuses -notcontains $statusMatch.Groups['status'].Value.Trim()) {
        Add-ValidationFailure $Failures "current-slice.md uses an invalid lifecycle status: $($statusMatch.Groups['status'].Value.Trim())"
    }

    Assert-Pattern $Failures $slice '(?m)^- \*\*Issue:\*\* #\d+ - .+$' 'current-slice.md is missing source Issue number and title.'
    Assert-Pattern $Failures $slice '(?m)^- \*\*URL:\*\* https://github\.com/[^/]+/[^/]+/issues/\d+\s*$' 'current-slice.md is missing a valid source Issue URL.'
    Assert-Pattern $Failures $slice '(?ms)^## Validation plan\s*.*?```' 'current-slice.md does not declare a validation command block.'

    $placeholderPatterns = @(
        '\[Work Item Title\]',
        '\[Issue number\]',
        '\[Issue title\]',
        '\[Issue URL\]',
        '\[Included work\]',
        '\[Explicitly excluded work\]',
        '\[Observable criterion[^\]]*\]',
        '\[Step\]',
        '\[Path expected[^\]]*\]',
        '\[command\]',
        '\[Manual review[^\]]*\]',
        '\[Condition that[^\]]*\]',
        '\[Review question\]'
    )

    foreach ($pattern in $placeholderPatterns) {
        if ($slice -match $pattern) {
            Add-ValidationFailure $Failures "current-slice.md contains an unresolved scaffold placeholder matching: $pattern"
        }
    }

    $pathMatches = [regex]::Matches($slice, '(?<!https?://)`((?:AGENTS\.md|README\.md|docs/|scripts/|tests/|skills/|templates/|\.github/)[^`]+)`')
    foreach ($match in $pathMatches) {
        $relativePath = $match.Groups[1].Value
        if (-not (Test-Path -LiteralPath (Join-Path $RepositoryRoot $relativePath))) {
            Add-ValidationFailure $Failures "current-slice.md references a missing local path: $relativePath"
        }
    }
}

function Test-IssueTemplates {
    param(
        [System.Collections.Generic.List[string]]$Failures,
        [string]$RepositoryRoot
    )

    $implementation = Get-RepositoryText $RepositoryRoot '.github/ISSUE_TEMPLATE/implementation.yml'
    $bug = Get-RepositoryText $RepositoryRoot '.github/ISSUE_TEMPLATE/bug.yml'

    if ($null -ne $implementation) {
        foreach ($id in @('work_type', 'goal', 'context', 'scope', 'non_goals', 'acceptance', 'dependencies', 'documents', 'readiness')) {
            Assert-Pattern $Failures $implementation ('(?m)^\s+id:\s+' + [regex]::Escape($id) + '\s*$') "implementation.yml is missing required field id: $id"
        }

        if (([regex]::Matches($implementation, '(?m)^[ \t]+required:[ \t]+true[ \t]*$')).Count -lt 8) {
            Add-ValidationFailure $Failures 'implementation.yml does not mark all required contract fields as required.'
        }
    }

    if ($null -ne $bug) {
        foreach ($id in @('summary', 'observed', 'expected', 'evidence', 'impact', 'scope', 'non_goals', 'acceptance', 'dependencies', 'documents', 'readiness')) {
            Assert-Pattern $Failures $bug ('(?m)^\s+id:\s+' + [regex]::Escape($id) + '\s*$') "bug.yml is missing required field id: $id"
        }

        if (([regex]::Matches($bug, '(?m)^[ \t]+required:[ \t]+true[ \t]*$')).Count -lt 10) {
            Add-ValidationFailure $Failures 'bug.yml does not mark all required contract fields as required.'
        }
    }
}

function Test-ReusableAssets {
    param(
        [System.Collections.Generic.List[string]]$Failures,
        [string]$RepositoryRoot
    )

    $reusablePaths = @('AGENTS.md', 'skills', 'templates', '.github/ISSUE_TEMPLATE')
    $forbiddenPatterns = @(
        'AI Development Harness',
        'ilmfeemster/ai-harness/issues/\d+',
        'Harness Phase 0',
        'Phase 0\.[0-9]+'
    )

    foreach ($relativePath in $reusablePaths) {
        $path = Join-Path $RepositoryRoot $relativePath
        if (-not (Test-Path -LiteralPath $path)) {
            continue
        }

        $files = if (Test-Path -LiteralPath $path -PathType Leaf) {
            @([System.IO.FileInfo](Get-Item -LiteralPath $path))
        } else {
            @(Get-ChildItem -LiteralPath $path -File -Recurse)
        }

        foreach ($file in $files) {
            $text = [System.IO.File]::ReadAllText($file.FullName)
            foreach ($pattern in $forbiddenPatterns) {
                if ($text -match $pattern) {
                    $displayPath = $file.FullName.Substring($RepositoryRoot.Length).TrimStart('\', '/')
                    Add-ValidationFailure $Failures "Reusable asset contains harness-specific active state: $displayPath"
                    break
                }
            }
        }
    }
}

function Get-ValidationResult {
    param(
        [string]$RepositoryRoot
    )

    $resolvedRoot = (Resolve-Path -LiteralPath $RepositoryRoot).Path
    $failures = New-Object 'System.Collections.Generic.List[string]'

    foreach ($relativePath in @(
        'AGENTS.md',
        'README.md',
        'docs/project.md',
        'docs/roadmap.md',
        'docs/architecture.md',
        'docs/decisions.md',
        'docs/testing.md',
        'docs/current-slice.md',
        'templates/docs/current-slice.md',
        '.github/ISSUE_TEMPLATE/implementation.yml',
        '.github/ISSUE_TEMPLATE/bug.yml',
        'scripts/validate.ps1',
        'tests/validate-structure.ps1'
    )) {
        Assert-RequiredFile $failures $resolvedRoot $relativePath
    }

    foreach ($relativePath in @('docs', 'docs/design', 'skills', 'templates/docs', '.github/ISSUE_TEMPLATE', 'scripts', 'tests')) {
        Assert-RequiredDirectory $failures $resolvedRoot $relativePath
    }

    Test-CurrentSlice $failures $resolvedRoot
    Test-IssueTemplates $failures $resolvedRoot
    Test-ReusableAssets $failures $resolvedRoot

    [pscustomobject]@{
        Passed = ($failures.Count -eq 0)
        Failures = @($failures)
    }
}

function Invoke-RepositoryValidation {
    param(
        [string]$RepositoryRoot
    )

    $result = Get-ValidationResult $RepositoryRoot
    if ($result.Passed) {
        Write-Host 'Structural validation passed.'
        return 0
    }

    Write-Host 'Structural validation failed:'
    foreach ($failure in $result.Failures) {
        Write-Host "- $failure"
    }

    return 1
}

if (-not $Library) {
    exit (Invoke-RepositoryValidation -RepositoryRoot $Root)
}
