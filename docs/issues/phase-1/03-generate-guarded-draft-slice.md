---
title: "Phase 1: Generate guarded Draft slices"
work_type: "Feature"
readiness: "Ready"
phase: "phase-1"
sequence: "03"
depends_on: "01,02"
github_issue_number: "10"
github_issue_url: "https://github.com/ilmfeemster/ai-harness/issues/10"
---

# Phase 1: Generate guarded Draft slices

## Work type

Feature

## Goal

Generate a complete, structurally checked Draft active slice from a passing normalized Issue and context manifest without replacing unresolved work or approving execution.

## Context

The Phase 1 design requires the assistant to turn one Ready Issue into a `Draft` `docs/current-slice.md` while preserving the Issue's required outcome. This translation must be guarded by Issue readiness, document availability, and active-slice state, and it must distinguish mechanical scope checks from human semantic review.

## Scope

- Enforce readiness, dependency, required-document, and unresolved-active-slice guards before active-slice replacement.
- Generate every required slice section from the neutral schema and preserve the source Issue's context, goal, scope, non-goals, and acceptance criteria.
- Add bounded execution detail, validation/review guidance, and manifest links only from selected governing documents.
- Add deterministic structural, traceability, and source-to-slice scope checks, with fixtures for success and blocked cases.

## Non-goals

- Do not fetch or parse Issue forms independently of Issue 01.
- Do not perform broad document discovery independently of Issue 02.
- Do not set a slice to `Approved`, mark an Issue Active, run implementation, or write to GitHub.
- Do not claim semantic equivalence or replace human review with generated checks.

## Acceptance criteria

- [ ] A passing normalized Issue and manifest produce a complete `docs/current-slice.md` with status `Draft`, source traceability, and no unresolved scaffold markers.
- [ ] The generated slice preserves the source Issue's context, goal, scope, non-goals, and acceptance criteria without omission or material alteration.
- [ ] An unchecked readiness item, unresolved dependency, missing required document, closed Issue, or unresolved active slice prevents active-slice replacement and records the blocker in the manifest.
- [ ] Structural and source-to-slice checks identify missing required headings, invalid status, broken traceability, and altered or omitted contract sections.
- [ ] Tests demonstrate that preparation does not approve a slice, begin implementation, or write to GitHub.

## Dependencies

- **Phase-local prerequisites (`depends_on`):** 01 — Normalize supported GitHub Issue forms; 02 — Assemble bounded context manifests.
- **Promotion blockers:** Issues 01 and 02 must be Complete before this Issue is promoted into `docs/current-slice.md`. The approved Phase 1 design must remain available. These conditions do not make this planning draft unready for publication.

## Relevant project documents

- `docs/project.md`
- `docs/architecture.md`
- `docs/decisions.md`
- `docs/testing.md`
- `docs/design/phase-1-context-and-slice-assistance.md`
- `templates/docs/current-slice.md`
- `AGENTS.md`

## Readiness

- [x] The goal is singular and bounded.
- [x] Scope and non-goals are explicit.
- [x] Acceptance criteria are observable and reviewable.
- [x] Dependencies and their completion conditions are explicitly documented.
- [x] Relevant project documents are identified.
- [x] No unresolved product or architecture decision blocks execution.
- [x] The work is small enough for one implementation slice.
