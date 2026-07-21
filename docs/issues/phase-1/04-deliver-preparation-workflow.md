---
title: "Phase 1: Deliver the manual slice-preparation workflow"
work_type: "Feature"
readiness: "Ready"
phase: "phase-1"
sequence: "04"
depends_on: "01,02,03"
github_issue_number: ""
github_issue_url: ""
---

# Phase 1: Deliver the manual slice-preparation workflow

## Work type

Feature

## Goal

Deliver and exercise the single manually invoked Phase 1 workflow that prepares a Draft slice from one explicit Ready Issue.

## Context

The preceding outcomes establish individual components. Phase 1 is not complete until an operator can use one coherent local command, understand its prerequisites and output, and verify that it preserves the human-controlled Issue-to-slice lifecycle in a representative end-to-end path.

## Scope

- Integrate the normalized Issue reader, context-manifest assembly, and guarded Draft-slice generation behind one foreground local operator path.
- Document required GitHub CLI access, explicit Issue selection, output locations, warnings/blockers, and the required human approval handoff.
- Add end-to-end fixtures or a controlled representative workflow test covering successful preparation and a blocked preparation path.
- Run the existing structural checks and the new focused test suite against the integrated workflow.

## Non-goals

- Do not add automatic Issue selection, batch preparation, background execution, or workflow scheduling.
- Do not implement a feature from a generated slice, automate validation or repair, or change GitHub Issue state.
- Do not add remote services, databases, cross-repository control, or general-purpose agent abstractions.
- Do not close Phase 1 or advance to a subsequent Issue automatically.

## Acceptance criteria

- [ ] An operator can invoke one documented local path for an explicit Ready Issue and receive an inspectable context manifest plus a Draft slice when all guards pass.
- [ ] The integrated workflow reports actionable prerequisite, parser, discovery, and guard failures without overwriting an unresolved active slice or changing GitHub state.
- [ ] Documentation makes clear that the output remains Draft and requires explicit human approval before implementation authorization.
- [ ] Focused tests and the repository structural validation pass for successful and blocked end-to-end preparation scenarios.
- [ ] Manual review confirms the workflow stays project-local, does not select work automatically, and preserves existing validation, review, and finalization boundaries.

## Dependencies

- **Phase-local prerequisites (`depends_on`):** 01 — Normalize supported GitHub Issue forms; 02 — Assemble bounded context manifests; 03 — Generate guarded Draft slices.
- **Promotion blockers:** Issues 01, 02, and 03 must be Complete before this Issue is promoted into `docs/current-slice.md`. The approved Phase 1 design must remain available. These conditions do not make this planning draft unready for publication.

## Relevant project documents

- `docs/project.md`
- `docs/architecture.md`
- `docs/decisions.md`
- `docs/testing.md`
- `docs/design/phase-1-context-and-slice-assistance.md`
- `AGENTS.md`
- `skills/prepare-slice/SKILL.md`

## Readiness

- [x] The goal is singular and bounded.
- [x] Scope and non-goals are explicit.
- [x] Acceptance criteria are observable and reviewable.
- [x] Dependencies and their completion conditions are explicitly documented.
- [x] Relevant project documents are identified.
- [x] No unresolved product or architecture decision blocks execution.
- [x] The work is small enough for one implementation slice.
