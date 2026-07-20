# Phase 0.8 - Compare against the fantasy workflow

> **Project operational state:** This file is the active execution package for the AI Development Harness project. Reusable slice structure belongs in `templates/docs/current-slice.md`; this file contains only the current harness work item.

## Status

Complete

## Source Issue

- **Issue:** #5 - Phase 0.8 - Compare against the fantasy workflow
- **URL:** https://github.com/ilmfeemster/ai-harness/issues/5

## Context

The fantasy project in the sibling `live-draft-tool-v2` repository is the first proven testbed for this document-driven workflow. Its process includes selective document loading, explicit planning and implementation modes, task-to-slice promotion, current-slice execution guardrails, testing expectations, scope protection, and post-implementation reporting.

The harness now uses GitHub Issues instead of `tasks.md` as the authoritative work queue, plus reusable skills for lifecycle operations. This slice compares the proven fantasy workflow against the Phase 0 harness and incorporates only reusable, project-neutral improvements. Fantasy-football product scope, domain rules, task backlog, and obsolete `tasks.md` assumptions must remain excluded.

## Goal

Compare the Phase 0 harness workflow against the proven `live-draft-tool-v2` workflow and incorporate missing reusable rules without copying fantasy-football context.

## Scope

- Inventory relevant workflow documents and rules in the sibling `live-draft-tool-v2` repository.
- Compare document loading, planning, slice preparation, implementation, validation, review, and completion behavior.
- Identify missing reusable protections or useful friction reductions.
- Incorporate only proven project-neutral improvements.
- Record intentionally excluded domain-specific or obsolete patterns.

## Non-goals

- Do not migrate the fantasy repository yet.
- Do not copy fantasy product scope or design content.
- Do not add speculative abstractions.
- Do not begin a fantasy feature slice.

## Acceptance criteria

- The comparison is explicit and reviewable.
- Every adopted rule is project-neutral and justified by proven use.
- Domain-specific content is excluded.
- The Issue-based workflow remains intact.
- Phase 0 is at least as usable as the previous manual workflow.

## Implementation plan

1. Read the relevant fantasy workflow sources from the sibling repository, limited to workflow-facing documents such as AGENTS.md, CLAUDE.md, docs/tasks.md, docs/current-slice.md, docs/completed-tasks.md, docs/testing.md, docs/architecture.md, docs/decisions.md, docs/future_ideas.md, and QA or patch notes only when they clarify workflow mechanics.
2. Create a concise comparison artifact in docs/design/fantasy-workflow-comparison.md. Cover document loading, planning, work-item creation, slice promotion, implementation guardrails, validation, review, completion evidence, scope control, and migration differences from `tasks.md` to GitHub Issues.
3. In the comparison artifact, separate three categories:
   - adopted project-neutral rules or friction reductions;
   - already-covered harness behaviors that require no change;
   - intentionally excluded fantasy-specific, domain-specific, obsolete, or speculative patterns.
4. Update `AGENTS.md` only for reusable workflow rules that are proven by the fantasy process and missing or weaker in the harness constitution. Preserve the Issue-based lifecycle, human approval boundaries, authority-by-concern model, and one-work-item invariant.
5. Update the relevant skill files only when an adopted rule belongs in an operation procedure rather than the general constitution. Likely candidates are `skills/prepare-slice/SKILL.md`, `skills/implement-slice/SKILL.md`, `skills/validate-slice/SKILL.md`, `skills/review-slice/SKILL.md`, and `skills/finalize-work-item/SKILL.md`.
6. Update `docs/testing.md` if the comparison proves a reusable validation or review expectation that is not already represented in the harness testing standards.
7. Update `docs/architecture.md` or `docs/decisions.md` only if the adopted rule changes current workflow architecture or creates a durable decision. Do not use those documents as implementation notes.
8. Update `README.md` only if the resulting workflow changes the human operating model or repository map in a way a user must see at entry.
9. Extend `scripts/validate.ps1` and `tests/validate-structure.ps1` only if an adopted rule can be checked deterministically and locally without semantic judgment.
10. Update this slice during implementation only with execution-only adjustments and later completion evidence. Formal validation must use `skills/validate-slice/SKILL.md`; independent review must use `skills/review-slice/SKILL.md`.

## Expected files

- docs/current-slice.md - this promoted Draft slice and later lifecycle/evidence notes.
- docs/design/fantasy-workflow-comparison.md - explicit comparison, adopted rules, already-covered behaviors, and exclusions.
- `AGENTS.md` - only if reusable workflow authority needs a proven project-neutral improvement.
- `skills/prepare-slice/SKILL.md` - only if promotion procedure needs a proven project-neutral improvement.
- `skills/implement-slice/SKILL.md` - only if implementation procedure needs a proven project-neutral improvement.
- `skills/validate-slice/SKILL.md` - only if validation procedure needs a proven project-neutral improvement.
- `skills/review-slice/SKILL.md` - only if review procedure needs a proven project-neutral improvement.
- `skills/finalize-work-item/SKILL.md` - only if completion procedure needs a proven project-neutral improvement.
- `docs/testing.md` - only if project-wide validation standards need a proven project-neutral improvement.
- `docs/architecture.md` - only if the workflow architecture boundary changes.
- `docs/decisions.md` - only if a durable workflow decision is added or revised.
- `README.md` - only if the human entry point or operating model changes.
- `scripts/validate.ps1` - only if a new adopted rule is mechanically checkable.
- `tests/validate-structure.ps1` - only if validator behavior changes.

Do not edit fantasy repository files. Do not add fantasy product documents, source code, or domain-specific design content to this repository.

## Validation plan

Run from the repository root after implementation:

```powershell
powershell -NoProfile -File scripts/validate.ps1
powershell -NoProfile -File tests/validate-structure.ps1
git diff --check
git status --short
```

Manual checks:

- Confirm the comparison artifact identifies the fantasy workflow sources reviewed and keeps the comparison explicit and reviewable.
- Confirm each adopted rule is project-neutral, justified by proven use, and placed in the correct authority source.
- Confirm excluded patterns include fantasy product scope, fantasy domain knowledge, `tasks.md`-specific backlog mechanics that conflict with the Issue-based workflow, and speculative automation not proven by repeated use.
- Confirm the Issue-based workflow remains intact: GitHub Issues define outcomes, current slices define execution, human approval remains required, and Issue closure remains a finalization step.
- Confirm the resulting Phase 0 workflow is at least as usable as the prior manual workflow for document loading, slice execution, validation evidence, review, and completion handoff.
- Confirm no implementation work begins for a fantasy feature slice and no migration of `live-draft-tool-v2` is attempted.

Formal validation must follow `skills/validate-slice/SKILL.md`; it owns completion evidence and the transition to `Ready for review`. Independent review must follow `skills/review-slice/SKILL.md` and must not close Issue #5 or set this slice to `Complete`.

## Failure conditions

Stop and revise before implementation or approval if:

- the source Issue outcome, scope, non-goals, or acceptance criteria would need to change;
- the comparison cannot be made explicit and reviewable without copying fantasy product or domain content;
- an adopted rule would weaken the Issue-based workflow, human approval boundaries, authority-by-concern model, or one-work-item invariant;
- a useful fantasy pattern depends on obsolete `tasks.md` behavior and cannot be translated cleanly to GitHub Issues;
- a proposed change adds speculative automation, central orchestration, multi-agent coordination, synchronization, or a generic plugin architecture;
- a proposed validation check would require semantic judgment that belongs in review rather than deterministic local tooling;
- expected file changes grow beyond reusable workflow rules and comparison evidence;
- implementation requires editing the fantasy repository, starting a fantasy feature slice, or migrating that project.

## Review checklist

- Is the comparison explicit enough for a reviewer to see what was adopted, already covered, and excluded?
- Does every adopted rule have a project-neutral justification grounded in the fantasy workflow?
- Were fantasy product scope, domain rules, task backlog, and design content excluded?
- Does the Issue-based workflow remain authoritative, with `tasks.md` treated only as legacy source context from the fantasy repo?
- Do changes preserve the harness authority model, one active slice, and human approval boundaries?
- Are reusable rules placed in `AGENTS.md` or the appropriate skill instead of buried in project-specific documents?
- Are project-owned documents updated only when their concern actually changes?
- Are any validator changes local, deterministic, and tested?
- Does the result avoid unsupported shortcuts, speculative abstractions, and unrelated cleanup?
- Does the workflow remain understandable for a human operator using Phase 0 manually?

## Completion evidence

**Implementation status:** In progress. Implementation was explicitly authorized after human approval.

**Acceptance-criteria status:** Pending.

**Files changed:** `AGENTS.md`, `docs/current-slice.md`, and `docs/design/fantasy-workflow-comparison.md`.

**Validation results:** Not run.

**Manual checks:** Issue #5 readiness checked against the Issue body; Phase 0.7 dependency checked against the previous completed current slice; required harness context and relevant fantasy workflow documents were sampled for slice preparation.

**Implementation adjustments or deviations:** Added one project-neutral interrupted-work handoff rule in `AGENTS.md`. The comparison found the remaining proven sibling workflow protections already covered or superseded by the Issue-based harness, so no skill, testing-standard, architecture, decision, README, or validator change was needed.

**Known limitations or follow-up Issues:** None identified.

**Implementation summary:** In progress. The explicit comparison artifact documents adopted, already-covered, and intentionally excluded workflow patterns without importing fantasy product context.

## Dependencies and assumptions

- Phase 0.7 project-start instructions are complete, based on the prior `docs/current-slice.md` state.
- The sibling comparison target is available at `C:\Users\Focus Mode\OneDrive\Documents\Code\live-draft-tool-v2`.
- No linked approved design document was identified for Issue #5.
- The comparison artifact is documentation work inside this repository; it must not modify or migrate the fantasy repository.
- Human approval is required before this Draft slice becomes Approved, and implementation remains unauthorized until explicitly requested after approval.

## Relevant project documents

- `AGENTS.md`
- `README.md`
- `docs/project.md`
- `docs/roadmap.md`
- `docs/architecture.md`
- `docs/decisions.md`
- `docs/testing.md`
- `templates/docs/current-slice.md`
- `scripts/validate.ps1`
- `tests/validate-structure.ps1`
- Sibling workflow source: `C:\Users\Focus Mode\OneDrive\Documents\Code\live-draft-tool-v2\AGENTS.md`
- Sibling workflow source: `C:\Users\Focus Mode\OneDrive\Documents\Code\live-draft-tool-v2\CLAUDE.md`
- Sibling workflow source: `C:\Users\Focus Mode\OneDrive\Documents\Code\live-draft-tool-v2\docs\tasks.md`
- Sibling workflow source: `C:\Users\Focus Mode\OneDrive\Documents\Code\live-draft-tool-v2\docs\current-slice.md`
- Sibling workflow source: `C:\Users\Focus Mode\OneDrive\Documents\Code\live-draft-tool-v2\docs\completed-tasks.md`

## Implementation constraints

- Follow `skills/implement-slice/SKILL.md` for authorized implementation and leave this slice `In progress` afterward.
- Follow `skills/validate-slice/SKILL.md` for formal validation; do not set `Ready for review` during implementation.
- Follow `skills/review-slice/SKILL.md` for independent review; do not close Issue #5 or set this slice `Complete` during review.
- Preserve Issue #5's goal, scope, non-goals, and acceptance criteria.
- Treat `live-draft-tool-v2` as evidence for proven workflow mechanics, not as a source of reusable product context.
