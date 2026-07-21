# Phase 1: Normalize supported GitHub Issue forms

> **Project operational state:** This file is the active execution package for the AI Development Harness project. It implements the approved GitHub Issue #8 slice.

## Status

In progress

## Source Issue

- **Issue:** #8 - Phase 1: Normalize supported GitHub Issue forms
- **URL:** https://github.com/ilmfeemster/ai-harness/issues/8

## Context

Phase 1 preparation requires reliable Issue inputs before document discovery or slice drafting can occur. The approved design limits support to the repository's implementation and bug forms, preserves the authoritative source Issue, and requires clear failure when Issue data or expected fields cannot be read.

## Goal

Provide a read-only local path that converts a human-selected supported GitHub Issue into a traceable normalized work-item contract.

## Scope

- Read an explicitly supplied Issue through a read-only local GitHub CLI path.
- Parse the rendered bodies of the bundled implementation and bug forms.
- Normalize supported form fields into one contract while retaining Issue number, title, URL, state, and unparsed body traceability.
- Provide fixtures and deterministic tests for valid supported forms and actionable failures for unsupported or incomplete forms.

## Non-goals

- Do not select an Issue, change GitHub state, or publish an Issue.
- Do not support arbitrary third-party forms or label-based readiness.
- Do not discover local documents, write manifests, generate slices, or start implementation.
- Do not store credentials or issue content in a central service or database.

## Acceptance criteria

- [ ] An explicitly supplied open implementation-form Issue is normalized with its required form fields, source number, title, URL, state, and unparsed-body traceability.
- [ ] An explicitly supplied open bug-form Issue is normalized into the same contract without losing its observed, expected, evidence, or impact context.
- [ ] Missing required fields, unsupported headings, unreadable Issue data, and closed Issues produce actionable failures without changing GitHub or local active-slice state.
- [ ] Readiness confirmations are represented accurately for later preparation guards; labels do not establish readiness.
- [ ] Fixtures and deterministic tests cover supported forms and the defined failure cases.

## Implementation plan

1. Define a small project-local normalized Issue-contract shape for the fields required by the implementation and bug forms, including source metadata and unparsed-body traceability.
2. Add a read-only GitHub CLI adapter that accepts an explicit Issue number and returns only the Issue data needed for normalization; report unavailable CLI, authentication, fetch, and closed-Issue failures clearly.
3. Parse the rendered markdown emitted by the two bundled forms into the normalized contract, preserving bug evidence fields and readiness confirmations without deriving readiness from labels.
4. Add fixture-based deterministic tests for valid implementation and bug forms and for unsupported headings, missing required fields, unreadable Issue data, and closed Issues.
5. Document the local command's read-only boundary and verify that the new path neither writes GitHub state nor changes the active slice.

## Expected files

- `scripts/prepare-slice.ps1` — read-only Issue normalization boundary.
- `tests/prepare-slice.ps1` — deterministic parser and failure-path tests.
- `tests/fixtures/issues/` — representative submitted Issue-form fixtures.
- `docs/current-slice.md` — this Draft slice and later execution evidence only.

## Validation plan

Run from the repository root after implementation:

```powershell
powershell -NoProfile -File tests/prepare-slice.ps1
powershell -NoProfile -File scripts/validate.ps1
powershell -NoProfile -File tests/validate-structure.ps1
```

Manual checks:

- Use the local command with an explicit open Issue number and confirm its normalized output includes source number, title, URL, state, required form fields, readiness confirmations, and unparsed-body traceability.
- Repeat with a supported bug-form Issue and confirm observed behavior, expected behavior, evidence, and impact remain available in the normalized result.
- Confirm unsupported headings, missing required fields, unreadable Issue data, and a closed Issue report actionable failures.
- Confirm the command performs no GitHub write, does not select an Issue, and does not replace `docs/current-slice.md`.

## Failure conditions

Stop and revise before implementation or approval if:

- the implementation would need to support forms beyond the bundled implementation and bug forms;
- normalization would infer required field values or readiness from labels, titles, or unrelated repository text;
- the GitHub CLI adapter would write Issue state, store credentials, or require a hosted service;
- the normalized contract cannot retain source traceability or bug evidence without changing the Issue outcome;
- tests cannot exercise the parser and defined failures deterministically; or
- the work expands into context manifests, document discovery, slice generation, or automatic Issue selection.

## Review checklist

- Does the normalized contract retain all required fields and source metadata for both supported forms?
- Are all GitHub interactions read-only and limited to an explicit Issue number?
- Are readiness confirmations parsed from the Issue body rather than inferred from labels?
- Do failure paths remain actionable without changing GitHub or active-slice state?
- Are fixtures representative and deterministic, without credentials or remote test dependencies?
- Does the work avoid Issue selection, context discovery, manifest generation, slice generation, and implementation automation?
- Do tests and documentation preserve the Phase 1 architecture, project-local boundary, and human approval lifecycle?

## Completion evidence

**Implementation status:** In progress. The bounded implementation is complete and awaits formal validation.

**Acceptance-criteria status:** Not formally evaluated; focused development evidence is available.

**Files changed:** `docs/current-slice.md`, `scripts/prepare-slice.ps1`, `tests/prepare-slice.ps1`, and `tests/fixtures/issues/`.

**Validation results:** Development checks passed on 2026-07-21: `powershell -NoProfile -File scripts/prepare-slice.ps1 -IssueNumber 8`; `powershell -NoProfile -File tests/prepare-slice.ps1`; `powershell -NoProfile -File scripts/validate.ps1`; and `powershell -NoProfile -File tests/validate-structure.ps1`. Formal validation has not yet run.

**Manual checks:** GitHub Issue #8 was retrieved read-only on 2026-07-21. The normalizer returned its source number, title, URL, open state, unparsed body, all required implementation-form fields, and seven checked readiness confirmations. Fixture coverage confirmed equivalent bug-form preservation and defined error paths without live GitHub access.

**Implementation adjustments or deviations:** The normalizer exposes a local JSON-fixture input solely for deterministic tests; normal operation requires an explicit Issue number and uses the read-only GitHub CLI path. The Draft slice's expected paths were made concrete after implementation so structural validation could verify them without placeholder files.

**Known limitations or follow-up Issues:** Context discovery and manifests are deferred to Issue #9; guarded slice generation is deferred to Issue #10; end-to-end workflow integration is deferred to Issue #11.

**Implementation summary:** Added `scripts/prepare-slice.ps1`, which reads one explicit open GitHub Issue through `gh issue view` and normalizes only the supported implementation and bug forms. Added local submitted-form fixtures and `tests/prepare-slice.ps1` for valid and failure-path coverage. The tool performs no GitHub writes, Issue selection, document discovery, manifest generation, or slice generation.

## Dependencies and assumptions

- **Phase-local prerequisites:** None (`depends_on: ""`).
- The approved Phase 1 design remains available at `docs/design/phase-1-context-and-slice-assistance.md`.
- The GitHub CLI is expected to be available and authenticated only when the implemented read-only adapter runs; tests must not require live GitHub access.

## Relevant project documents

- `AGENTS.md`
- `docs/project.md`
- `docs/architecture.md`
- `docs/decisions.md`
- `docs/testing.md`
- `docs/design/phase-1-context-and-slice-assistance.md`
- `.github/ISSUE_TEMPLATE/implementation.yml`
- `.github/ISSUE_TEMPLATE/bug.yml`
- `skills/validate-slice/SKILL.md`

## Implementation constraints

- Preserve GitHub Issue #8's goal, scope, non-goals, and acceptance criteria.
- Keep all GitHub interactions read-only and initiated only for an explicit Issue number.
- Keep parser fixtures local and deterministic; do not require a live GitHub account to run tests.
- Do not create context manifests, alter GitHub Issues, or invoke implementation, validation, review, or finalization workflows from the new tool.
- This slice is `In progress`; formal validation owns the later transition to `Ready for review`.
