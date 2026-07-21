---
title: "Phase 1: Assemble bounded context manifests"
work_type: "Feature"
readiness: "Ready"
phase: "phase-1"
sequence: "02"
depends_on: "01"
github_issue_number: "9"
github_issue_url: "https://github.com/ilmfeemster/ai-harness/issues/9"
---

# Phase 1: Assemble bounded context manifests

## Work type

Feature

## Goal

For a normalized Issue, discover its bounded local governing context and write an inspectable per-Issue context manifest.

## Context

An Issue parser alone cannot show which project documents constrain a future slice. The approved design requires a project-local manifest that records selected documents, design selection reasoning, candidate exclusions, missing paths, warnings, and blockers without becoming a database or loading unrelated repository content.

## Scope

- Discover the mandatory Phase 1 authority documents and local documents explicitly referenced by a normalized Issue.
- Enumerate local design documents and apply the approved-design selection rules.
- Write `docs/context-manifests/<issue-number>.md` with source traceability, selection reasons, warnings, blockers, and draft-output status.
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

## Dependencies

- **Phase-local prerequisites (`depends_on`):** 01 — Normalize supported GitHub Issue forms.
- **Promotion blockers:** Issue 01 must be Complete before this Issue is promoted into `docs/current-slice.md`. The approved Phase 1 design must remain available. These conditions do not make this planning draft unready for publication.

## Relevant project documents

- `docs/project.md`
- `docs/architecture.md`
- `docs/decisions.md`
- `docs/testing.md`
- `docs/design/phase-1-context-and-slice-assistance.md`
- `AGENTS.md`

## Readiness

- [x] The goal is singular and bounded.
- [x] Scope and non-goals are explicit.
- [x] Acceptance criteria are observable and reviewable.
- [x] Dependencies and their completion conditions are explicitly documented.
- [x] Relevant project documents are identified.
- [x] No unresolved product or architecture decision blocks execution.
- [x] The work is small enough for one implementation slice.
