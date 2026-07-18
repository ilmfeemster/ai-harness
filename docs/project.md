# Project

## Product

AI Development Harness

## Current phase

**Harness Phase 0 — Usable document-driven workflow template**

## Vision

Create a reusable project starting point that helps produce consistently high-quality AI-assisted software development through durable documentation, bounded execution packages, deterministic validation, and explicit human approval.

The long-term workflow is:

```text
Select a work item
↓
load the correct documentation
↓
generate a bounded execution package
↓
produce implementation output
↓
validate and evaluate
↓
repair if necessary
↓
present a near-complete result for approval
```

The objective is quality and leverage, not autonomy for its own sake.

## Current Phase 0 goal

Produce a self-contained project template that is at least as usable as the current document-driven workflow in `live-draft-tool-v2`.

Phase 0 should support:

```text
project.md
→ design document
→ GitHub Issues
→ current-slice.md
→ manual implementation
→ validation
→ review
→ approval
```

## Target user

Initially, the template is optimized for the repository owner's workflow as a solo developer using AI planning and implementation agents.

It is not yet intended to be a universal development framework.

## Phase 0 scope

- Repository constitution through `AGENTS.md`.
- Clear document responsibilities.
- GitHub Issues as the work queue.
- A reusable `current-slice.md` execution contract.
- Selective context-loading rules.
- Planning, implementation, validation, and review boundaries.
- Lightweight structural validation.
- Instructions for starting new projects.
- Real-world testing through `live-draft-tool-v2`.

## Phase 0 non-goals

- Automatic issue selection.
- Automatic model invocation.
- Automatic repair.
- Automatic commits or pull requests.
- Multi-agent coordination.
- Cross-repository control.
- A hosted service or dashboard.
- Generic plugin architecture.
- Supporting every project type before repeated patterns emerge.

## Product principles

1. Intelligence lives in project documents.
2. Each project remains self-contained.
3. Human approval remains explicit.
4. Work is executed in small, bounded slices.
5. Validation and review are separate concepts.
6. Reusable mechanics are extracted only after proven repetition.
7. Every phase must leave the harness usable.

## Phase 0 success criteria

Phase 0 is complete when:

- a new repository can begin from this template;
- its project and architecture can be documented without inventing a workflow;
- work can be represented as GitHub Issues;
- one issue can be promoted into a strong implementation slice;
- an implementation agent can execute that slice manually;
- validation and review expectations are explicit;
- the next real fantasy-project slice can be run through this workflow;
- friction found during real use has been incorporated into the template.
