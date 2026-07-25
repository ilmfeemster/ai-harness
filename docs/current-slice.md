# Phase 1: Assemble bounded context manifests

> **Project operational state:** This file is the active execution package for the AI Development Harness project. It is a Draft translation of GitHub Issue #9 and does not authorize implementation.

## Status

Draft

## Source Issue

- **Issue:** #9 - Phase 1: Assemble bounded context manifests
- **URL:** https://github.com/ilmfeemster/ai-harness/issues/9

## Context

An Issue parser alone cannot show which project documents constrain a future slice. The approved design requires a project-local manifest that records selected documents, design selection reasoning, candidate exclusions, missing paths, warnings, and blockers without becoming a database or loading unrelated repository content.

## Goal

For a normalized Issue, discover its bounded local governing context and write an inspectable per-Issue context manifest.

## Scope

- Discover the mandatory Phase 1 authority documents and local documents explicitly referenced by a normalized Issue.
- Enumerate local design documents and apply the approved-design selection rules.
- Write one per-Issue Markdown manifest in the project-owned context-manifest directory, with source traceability, selection reasons, warnings, blockers, and draft-output status.
- Add deterministic fixtures and tests for selection, exclusion, absent documents, Draft-design handling, and manifest overwrite behavior.

## Non-goals

- Do not parse or fetch the Issue contract beyond consuming Issue 01's normalized result.
- Do not replace `docs/current-slice.md`, approve work, or start implementation.
- Do not discover all repository files, sibling repositories, or remote project context.
- Do not add a database, general run-record system, or automated retention process.

## Acceptance criteria

- [ ] For a normalized Issue, the manifest records the mandatory authority sources, Issue-linked local documents, selected designs, and the reason for each selection.
- [ ] Draft designs can be recorded as candidates but are excluded from governing context; approved applicable designs are selected according to the design rules.
- [ ] Missing referenced local documents, inaccessible paths, and ambiguous selection conditions are reported as actionable warnings or blockers.
- [ ] The manifest contains no credentials, tokens, or copied full Issue/document contents and is limited to the Issue's project-local traceability.
- [ ] Deterministic tests cover bounded discovery, design selection, missing-path reporting, and repeat preparation for the same Issue.

## Implementation plan

1. Extend the local preparation tool with a context-discovery boundary that consumes the normalized contract from Issue #8 rather than re-parsing or re-fetching an Issue.
2. Define the bounded mandatory authority set, inspect Issue-linked local document paths, and enumerate only local design documents.
3. Apply the approved-design selection rules, recording selected documents with reasons and Draft or irrelevant designs as candidates excluded from governing context.
4. Write a concise per-Issue Markdown manifest containing source traceability, the normalized readiness result, selected and excluded documents, warnings, blockers, and Draft-output status; overwrite only the same Issue's prior manifest.
5. Add fixture-based tests for bounded discovery, approved and Draft design treatment, missing paths, ambiguous design selection, and repeat writes; document that the operation neither changes GitHub nor replaces the active slice.

## Expected files

- A context-discovery and manifest-writing extension to the local preparation script.
- A deterministic manifest-discovery test script and repository fixtures.
- A project-owned context-manifest directory created only by the explicit manifest operation.
- `docs/current-slice.md` — this Draft slice and later execution evidence only.

## Validation plan

Run from the repository root after implementation:

```powershell
powershell -NoProfile -File scripts/validate.ps1
powershell -NoProfile -File tests/validate-structure.ps1
```

Manual checks:

- Run the deterministic context-manifest test command after it is added and record its exact command and result in this slice during implementation.
- Provide a normalized Issue with explicit document references and confirm the manifest records the mandatory authorities, the references that exist locally, and a reason for every selected document.
- Confirm an approved applicable design is selected while a Draft design is recorded as excluded from governing context.
- Confirm missing paths and ambiguous selections become actionable warnings or blockers without writing an active slice or changing GitHub.
- Repeat preparation for the same Issue and confirm only that Issue's manifest is overwritten, with no credentials, tokens, or copied full document contents.

## Failure conditions

Stop and revise before implementation or approval if:

- discovery expands to unrelated source files, sibling repositories, or a whole-repository crawl;
- a Draft design influences governing context;
- a required authority source or Issue-linked document is missing and the result would silently continue as complete;
- the manifest would contain credentials, authentication tokens, full copied Issue bodies, or full copied document contents;
- the work needs to re-parse Issue forms, write GitHub state, replace `docs/current-slice.md`, or create a general run-record system; or
- design-selection ambiguity cannot be reported without inventing product requirements.

## Review checklist

- Does discovery use only the mandatory authorities, Issue-linked local paths, and local design documents?
- Is each selected or excluded document accompanied by an inspectable reason?
- Are Draft designs excluded from governing context and recorded only as candidates when relevant?
- Do missing paths and ambiguous selections produce actionable warnings or blockers?
- Does the manifest omit secrets and copied full source content?
- Are repeat writes limited to the same Issue's manifest, with no GitHub or active-slice write?
- Do the fixtures demonstrate bounded selection and retain the Phase 1 project-local boundary?

## Completion evidence

**Implementation status:** Pending human approval and implementation authorization.

**Acceptance-criteria status:** Pending.

**Files changed:** `docs/current-slice.md` (Draft preparation only).

**Validation results:** Not run.

**Manual checks:** GitHub Issue #9 was retrieved read-only on 2026-07-24. It is open, contains all required Issue-contract sections, and has every readiness confirmation checked. GitHub Issue #8 is closed, satisfying the sole phase-local prerequisite.

**Implementation adjustments or deviations:** None.

**Known limitations or follow-up Issues:** Guarded Draft-slice generation remains deferred to Issue #10. End-to-end workflow integration remains deferred to Issue #11.

**Implementation summary:** Draft slice prepared from GitHub Issue #9. Implementation has not started.

## Dependencies and assumptions

- **Phase-local prerequisite:** Issue #8 — Normalize supported GitHub Issue forms — is Complete and closed.
- The approved Phase 1 design remains available at `docs/design/phase-1-context-and-slice-assistance.md`.
- Context discovery consumes the normalized contract supplied by Issue #8; it does not duplicate the Issue reader or parser.

## Relevant project documents

- `AGENTS.md`
- `docs/project.md`
- `docs/architecture.md`
- `docs/decisions.md`
- `docs/testing.md`
- `docs/design/phase-1-context-and-slice-assistance.md`
- `scripts/prepare-slice.ps1`
- `skills/validate-slice/SKILL.md`

## Implementation constraints

- Preserve GitHub Issue #9's goal, scope, non-goals, and acceptance criteria.
- Keep discovery project-local, bounded, and explainable; do not load unrelated repositories or all source files.
- Treat approved applicable designs as governing input and Draft designs only as excluded candidates.
- Do not replace the active slice, change GitHub state, approve work, or start implementation from the manifest operation.
- This slice remains `Draft` until explicit human approval; implementation requires separate explicit authorization after approval.
