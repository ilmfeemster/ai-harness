# Phase 0.5 - Define planning modes

> **Project operational state:** This file is the active execution package for the AI Development Harness project. Reusable slice structure belongs in `templates/docs/current-slice.md`; this file contains only the current harness work item.

## Status

Draft

Implementation is not authorized. Issue #2 has an unchecked dependency-readiness item and requires human approval before the status can become `Approved`.

## Source Issue

- **Issue:** #2 - Phase 0.5 - Define planning modes
- **URL:** https://github.com/ilmfeemster/ai-harness/issues/2

## Context

`AGENTS.md` already defines preliminary work modes and context-loading rules. After the Issue and slice contracts are stable, those modes need to be reviewed as one operational interface so agents produce the correct artifact without reading or rewriting unnecessary project information.

Issue #2 is documentation-focused and remains within the reusable workflow constitution. It must keep reusable mode rules separate from project-specific product context.

## Goal

Finalize the reusable planning and context-loading modes so agents produce the correct artifact without reading or rewriting unnecessary project information.

## Scope

- Define the supported planning and execution modes.
- Define required and optional inputs for each mode.
- Define expected outputs and prohibited side effects.
- Define when context should expand.
- Define when project, roadmap, architecture, decision, design, Issue, slice, testing, and code sources are loaded.
- Keep reusable mode rules separate from project-specific context.

## Non-goals

- Do not implement automatic context discovery.
- Do not invoke models or agents automatically.
- Do not add multi-agent routing.
- Do not duplicate product context in `AGENTS.md`.

## Acceptance criteria

- Each mode has clear inputs, loading rules, outputs, and stop conditions.
- Planning does not silently become implementation.
- Implementation remains bounded by the approved slice.
- Small changes do not require every document layer.
- The rules remain reusable across software projects.

## Implementation plan

1. Review the existing work-mode and startup guidance in `AGENTS.md` against Issue #2 and the current document responsibilities.
2. Define the supported modes as an explicit operational interface, including required inputs, optional inputs, authoritative sources, expected outputs, prohibited side effects, and stop conditions.
3. Specify selective context-loading and expansion rules for repository orientation, planning, architecture, design, work-item creation, slice preparation, implementation, validation, and review.
4. Clarify the boundaries that prevent planning from authorizing implementation, prevent implementation from exceeding the approved slice, and keep project-specific context out of reusable rules.
5. Review the resulting rules against the project and architecture documents for contradictions. Record any required execution-only adjustment here before implementation.
6. Run the declared documentation checks and complete the review checklist before moving the slice to `Ready for review`.

## Expected files

- `AGENTS.md` - reusable planning, execution, context-loading, output, and stop-condition rules.
- `docs/current-slice.md` - this project-owned execution package and its eventual completion evidence.

No substantive change to `docs/project.md`, `docs/roadmap.md`, `docs/architecture.md`, `docs/decisions.md`, or `docs/testing.md` is expected unless implementation reveals a direct responsibility or architecture contradiction. Any such change must be reported and kept within the Issue outcome.

## Validation plan

Run from the repository root after implementation:

```powershell
git diff --check
git status --short
```

Manual checks:

- Every supported mode identifies its required and optional inputs, loading rules, outputs, prohibited side effects, and stop conditions.
- Context expands only when a missing dependency or contradiction requires it.
- Planning, slice preparation, implementation, validation, and review remain distinct operations.
- Small changes can use a narrow document set without loading every project source.
- `AGENTS.md` contains reusable rules and no copied product context.
- The rules do not introduce automatic discovery, model invocation, multi-agent routing, or implementation authorization.

## Failure conditions

Stop and revise before implementation or approval if:

- Issue #2's dependency readiness remains unresolved.
- The slice is moved to `Approved` without explicit human approval.
- A mode lacks a clear input, output, loading rule, prohibited side effect, or stop condition.
- Planning or slice preparation implicitly authorizes implementation.
- Implementation is permitted to exceed the approved slice.
- Small changes are forced through every document layer without a project-specific reason.
- Reusable rules copy product scope, roadmap content, architecture details, decisions, or other harness-specific context into `AGENTS.md`.
- The work introduces automatic context discovery, model or agent invocation, multi-agent routing, or unrelated Phase 0 work.
- The resulting rules contradict the Issue, project scope, architecture, durable decisions, or approved slice contract.

## Review checklist

- Does each supported mode have clear inputs, loading rules, outputs, prohibited side effects, and stop conditions?
- Are planning, implementation, validation, and review separated clearly enough to prevent accidental scope changes?
- Does selective loading avoid requiring every document for small, well-understood changes?
- Are context-expansion triggers explicit and limited to missing dependencies or contradictions?
- Do the rules preserve the authority of project-owned documents and the approved current slice?
- Can the modes be reused across projects without carrying AI Development Harness product context?
- Does the change remain manual and lightweight for Phase 0?
- Are the Issue #2 acceptance criteria met without adding automation or multi-agent behavior?

## Completion evidence

**Implementation status:** Pending. This turn prepared the Draft slice only; no implementation was performed.

**Acceptance-criteria status:** Pending implementation and review.

**Files changed:** `docs/current-slice.md` only for slice preparation.

**Validation results:** Not run. The validation commands above apply after the slice is approved and implemented.

**Manual checks:** Slice contents reviewed against Issue #2; implementation authorization remains withheld.

**Implementation adjustments or deviations:** None.

**Known limitations or follow-up Issues:** Issue #2 has an unchecked dependency-readiness item. Resolve that dependency before requesting approval for this slice.

**Implementation summary:** Created a bounded Draft execution package for Issue #2 without implementing the planning-mode changes.

## Dependencies and assumptions

- The source Issue identifies the Phase 0.4 slice standard as a dependency.
- Issue #2 is not ready for approval while its dependency-readiness checkbox remains unchecked.
- No linked design document was identified for Issue #2.
- Human approval is required before changing this slice to `Approved` or beginning implementation.

## Relevant project documents

- `AGENTS.md`
- `docs/project.md`
- `docs/roadmap.md`
- `docs/architecture.md`
- `docs/decisions.md`
- `docs/testing.md`
