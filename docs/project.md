# Project

> **Project-context document:** This file describes the current product and phase. A future project may reuse the scaffold but must replace this content.

## Product

AI Development Harness

## Current phase

**Harness Phase 2 — Controlled implementation**

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

## Current Phase 2 goal

Enable one explicitly authorized `Approved` slice to be executed through a project-local implementation runner with minimal human intervention, followed by deterministic validation and a structured completion or blocker result.

Phase 2 must preserve the existing Issue, slice, approval, documentation-currency, validation, review, and finalization boundaries. Activation begins planning for this capability; it does not claim that an implementation runner exists or authorize implementation.

## Target user

Initially optimized for the repository owner's solo workflow using AI planning and implementation agents. It is not yet a universal framework.

## Current capabilities and Phase 2 scope

The complete Phase 0 workflow and Phase 1 preparation path remain available. Existing capability includes:

- parsing one explicitly selected supported Ready Issue into a normalized contract;
- bounded local document discovery and explainable approved-design selection;
- per-Issue context manifests with selected, excluded, missing, warning, and blocker information;
- guarded generation of one structurally and scope-checked Draft `docs/current-slice.md`;
- explicit human slice approval and separate implementation authorization;
- structural validation and the distinct implementation, validation, review, final-approval, and finalization operations.

Phase 2 must add:

- one supported project-local implementation-runner path for an explicitly authorized `Approved` slice;
- bounded repository access;
- an explicit allowed-command configuration and enforcement contract;
- changed-file tracking;
- deterministic validation execution after implementation;
- structured completion and blocker states; and
- a documented decision on optional branch or worktree isolation.

## Phase 2 non-goals

- Automatic repair or repeated repair attempts.
- Independent semantic evaluation of implementation results.
- Automatic Issue selection, prioritization, or progression to another work item.
- Automatic commits, pull requests, merge, deployment, or Issue closure.
- Removing explicit slice approval, implementation authorization, review, final approval, or finalization.
- Multiple concurrent active slices or implementation efforts.
- Cross-repository control, a hosted service, background workers, or a workflow database.
- Provider-neutral agent or plugin abstractions before repeated use demonstrates a stable need.
- Treating deterministic validation as semantic review or human approval.

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

## Current Phase 2 exit criteria

Phase 2 is complete when:

- one separately authorized `Approved` slice can be executed through the supported project-local runner path;
- the runner confines repository access to its designed boundary and rejects disallowed commands;
- changed files are recorded against a deterministic baseline;
- the slice-declared validation is executed deterministically after implementation;
- the run produces a stable, sanitized structured result that distinguishes completion from actionable blockers;
- implementation and validation evidence remain traceable to the source Issue, approved slice, governing documents, commands, and changed files;
- automatic repair is absent and failures stop for human-directed follow-up;
- the chosen branch or worktree isolation behavior is explicit, tested where supported, and safely optional where deferred;
- documentation impact is assessed and the existing review, final approval, finalization, and one-active-work-item boundaries remain intact; and
- one representative successful path and the material blocked or rejected paths are exercised without weakening the retained Phase 0 and Phase 1 workflows.

## Phase 2 constraints and preserved behavior

- The complete Phase 0 workflow and Phase 1 preparation workflow remain usable.
- GitHub Issues remain authoritative outcomes; the approved slice remains the bounded execution package.
- A runner may act only after explicit human slice approval and separate implementation authorization.
- One current slice and one implementation effort remain active.
- Project intelligence, execution policy, and evidence remain project-local and inspectable.
- Authority by concern, deterministic-rule provenance, and documentation currency continue to govern execution.
- Mechanical validation remains distinct from independent semantic review and human approval.
- Phase 2 must not write GitHub delivery state or begin another work item automatically.
- Existing architecture and dependency direction remain governing until an approved Phase 2 design authorizes a specific change.
- Reusable assets remain project-neutral, and new abstractions require demonstrated repetition.

## Phase 2 dependencies and open questions

- Phase 0 is complete, confirmed on 2026-07-20.
- Phase 1 is complete based on finalized Issues #8 through #11; the final Phase 1 slice records passed validation, independent review, explicit final approval, and verified closure of Issue #11 on 2026-07-27.
- The approved Phase 1 design and delivered preparation workflow remain inputs to the new execution boundary.
- The Phase 2 design must define the supported runner invocation and execution boundary.
- The Phase 2 design must define the allowed-command configuration, normalization, ordering, rejection, and sanitized-failure rules.
- The Phase 2 design must define changed-file baselining and tracking, validation-command execution, result schema, side effects, idempotency or resume behavior, and the relationship between runner results and existing slice lifecycle states.
- The Phase 2 design must decide whether branch or worktree isolation is included initially, optional by configuration, or explicitly deferred without weakening bounded repository access.
- Issue planning cannot begin until the Phase 2 design is approved.

## Phase preparation

- **Design requirement:** Required
- **Design basis:** Phase 2 introduces a project-local implementation runner, bounded repository and command-execution policies, changed-file and validation contracts, structured completion and blocker states, and an isolation decision. These shared interfaces, lifecycle interactions, failure rules, and security boundaries must be decided consistently before the phase can be divided into Issues.
- **Expected design:** `docs/design/phase-2-controlled-implementation.md`
- **Design status:** Not started
- **Issue planning:** Not started
- **GitHub publication:** Not started
