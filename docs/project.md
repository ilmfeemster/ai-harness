# Project

> **Project-context document:** This file describes the current AI Development Harness product and phase. A future project may reuse the scaffold, but must replace this content with its own scope and state.

## Product

AI Development Harness

## Current phase

**Harness Phase 1 — Context and slice assistance**

## Vision

Create a reusable project starting point that helps produce consistently high-quality AI-assisted software development through durable documentation, bounded execution packages, deterministic validation, and explicit human approval.

The long-term workflow is:

```text
Select a work item
→
load the correct documentation
→
generate a bounded execution package
→
produce implementation output
→
validate and evaluate
→
repair if necessary
→
present a near-complete result for approval
```

The objective is quality and leverage, not autonomy for its own sake.

## Current Phase 1 goal

Enable a Ready GitHub Issue to become a high-quality `docs/current-slice.md` with little repetitive prompting, reducing manual orchestration and preparing future controlled execution loops.

Phase 1 should assist the human-operated workflow by assembling the relevant project context, identifying missing information, and producing a structurally and scope-checked slice draft. Implementation remains a separately invoked manual operation.

## Target user

Initially, the template is optimized for the repository owner's workflow as a solo developer using AI planning and implementation agents.

It is not yet intended to be a universal development framework.

## Phase 1 scope

- Local document discovery.
- Parsing the reusable GitHub Issue forms into an execution-ready work-item contract.
- Context manifests that make selected and missing context inspectable.
- Selection of relevant approved design documents.
- Drafting `docs/current-slice.md` from a Ready Issue and assembled context.
- Structural and scope checks for the proposed slice.
- Missing-information warnings.
- Explicit human approval before a drafted slice becomes executable.

## Phase 1 non-goals

- Automatic issue selection.
- Automatic implementation or automatic model invocation for implementation.
- Automatic repair.
- Automatic commits or pull requests.
- Multi-agent coordination.
- Cross-repository control.
- A hosted service or dashboard.
- Generic plugin architecture.
- Changing GitHub Issues as the authoritative work queue or `docs/current-slice.md` as the active execution package.
- Replacing the required human approval for a Draft slice.

## Product principles

1. Intelligence lives in project documents.
2. Reusable workflow mechanics remain separate from project context.
3. Each project remains self-contained.
4. Human approval remains explicit.
5. Work is executed in small, bounded slices.
6. Validation and review are separate concepts.
7. Reusable mechanics are extracted only after proven repetition.
8. Every phase must leave the harness usable.

## Current Phase 1 exit criteria

Phase 1 is complete when:

- a Ready GitHub Issue can be interpreted into a complete, inspectable work-item contract;
- relevant local project documents and approved designs can be discovered and recorded in a context manifest;
- the harness can produce a Draft `docs/current-slice.md` that preserves the source Issue's outcome, scope, non-goals, and acceptance criteria;
- structural and scope checks identify invalid drafts and missing information before approval;
- a human can review and explicitly approve a proposed slice before implementation begins;
- the existing manual implementation, validation, review, approval, and finalization boundaries remain intact.

## Phase 1 constraints and preserved behavior

- The Phase 0 document-driven workflow remains usable throughout Phase 1.
- GitHub Issues remain the authoritative work queue; local retained drafts remain traceability only.
- `docs/current-slice.md` remains the single bounded execution package, and at most one active implementation effort is allowed.
- All project intelligence remains local to the project repository.
- Deterministic structural validation and human review remain distinct from semantic judgment and approval.

## Phase 1 dependencies and open questions

- Phase 0 is complete, as confirmed by the user on 2026-07-20.
- The approved Phase 1 design must determine the local interfaces and data contracts for Issue parsing, document discovery, manifests, design selection, draft generation, and warnings.
- The design must specify how tooling reads GitHub Issue information while preserving the existing authority and approval boundaries.

## Phase preparation

- **Design requirement:** Required
- **Design basis:** Phase 1 introduces shared contracts and workflow behavior for Issue parsing, context manifests, design selection, slice drafting, and structural and scope warnings. These must be decided consistently before Phase work can be divided into independent Issues.
- **Expected design:** `docs/design/phase-1-context-and-slice-assistance.md`
- **Issue planning:** Drafted
- **GitHub publication:** Not started
