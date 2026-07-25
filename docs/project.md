# Project

> **Project-context document:** This file describes the current product and phase. A future project may reuse the scaffold but must replace this content.

## Product

AI Development Harness

## Current phase

**Harness Phase 1 — Context and slice assistance**

## Vision

Create a reusable project starting point that consistently produces high-quality AI-assisted software development through durable documentation, bounded execution packages, deterministic validation, independent review, and explicit human approval.

The long-term workflow is:

```text
Select a work item
→ load the correct documentation
→ generate a bounded execution package
→ produce implementation output
→ validate and evaluate
→ repair if necessary
→ present a near-complete result for approval
```

The objective is quality and leverage, not autonomy for its own sake.

A central design principle is to resolve expensive reasoning upstream, preserve it in inspectable artifacts, and reduce rediscovery during implementation.

## Current Phase 1 goal

Enable one explicitly selected Ready GitHub Issue to become a high-quality `docs/current-slice.md` with little repetitive prompting while preserving manual approval and implementation boundaries.

Phase 1 normalizes the Issue contract, assembles relevant project context, identifies missing information, writes an inspectable context manifest, and produces a structurally and scope-checked Draft slice.

Implementation remains separately authorized.

## Target user

Initially optimized for the repository owner's solo workflow using AI planning and implementation agents. It is not yet a universal framework.

## Phase 1 scope

- Local document discovery.
- Parsing supported Issue forms into a normalized work-item contract.
- Context manifests recording selected, excluded, missing, warning, and blocker information.
- Explainable selection of relevant approved designs.
- Drafting `docs/current-slice.md` from one Ready Issue and assembled context.
- Structural, traceability, lifecycle-consistency, and bounded scope checks.
- Missing-information warnings.
- Explicit human approval before a Draft becomes executable.

## Phase 1 non-goals

- Automatic Issue selection.
- Automatic implementation or repair.
- Automatic commits or pull requests.
- Multi-agent coordination.
- Cross-repository control.
- Hosted service or dashboard.
- Generic plugin architecture.
- Replacing Issues as the work queue or the slice as the execution package.
- Removing human approval.
- Automatically advancing to later work.

## Product principles

1. Intelligence lives in project documents.
2. Reusable mechanics remain separate from project context.
3. Each project remains self-contained.
4. Human approval remains explicit and inspectable.
5. Work is executed in bounded slices.
6. Reasoning is resolved by the stage that owns it.
7. Validation and review are separate.
8. Governing documents remain current with behavior.
9. Reusable mechanics are extracted only after proven repetition.
10. Every phase leaves the harness usable.

## Current Phase 1 exit criteria

Phase 1 is complete when:

- a Ready Issue becomes a complete normalized contract;
- relevant local documents and approved designs are recorded in a context manifest;
- a complete Draft slice preserves Issue outcome, scope, non-goals, and criteria;
- generated deterministic rules remain traceable to authority;
- structural and scope checks detect invalid drafts, lifecycle contradictions, and missing information;
- a human explicitly approves a proposed slice before separately authorizing implementation;
- implementation, validation, review, final approval, and finalization remain distinct;
- one representative end-to-end preparation path is exercised.

## Phase 1 constraints and preserved behavior

- The complete Phase 0 workflow remains usable.
- GitHub Issues remain authoritative.
- Local Issue drafts remain traceability only.
- One current slice and one implementation effort remain active.
- Project intelligence remains local.
- Mechanical validation remains distinct from semantic judgment.
- Phase 1 does not write GitHub state, approve, or start implementation.
- Reusable assets remain project-neutral.

## Phase 1 dependencies and open questions

- Phase 0 is complete, confirmed on 2026-07-20.
- The Phase 1 design is approved at `docs/design/phase-1-context-and-slice-assistance.md`.
- Phase 1 Issue planning is published.
- Issue #8, normalized Issue parsing, is complete.
- Issue #9, context-manifest assembly, is complete and its GitHub Issue is closed.
- Issue #10 owns guarded Draft-slice generation.
- Issue #11 owns the coherent manual end-to-end preparation workflow.
- Ambiguous active-phase design applicability must be surfaced rather than guessed.

## Phase preparation

- **Design requirement:** Required
- **Design basis:** Shared contracts are required for Issue parsing, context manifests, design selection, Draft generation, warnings, blockers, and scope checks.
- **Expected design:** `docs/design/phase-1-context-and-slice-assistance.md`
- **Design status:** Approved
- **Issue planning:** Published
- **GitHub publication:** Complete
