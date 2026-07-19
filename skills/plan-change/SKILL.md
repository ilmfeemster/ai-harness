# Plan Change

## Purpose

Perform bounded project planning, architecture work, or detailed design while preserving the distinction between deciding work and executing work.

This skill may produce or update planning and design artifacts when explicitly authorized. It does not create an implementation Issue, prepare a current slice, or implement code unless a separate handoff is explicitly requested.

## When to use

Use this skill for:

- project or phase planning;
- defining a capability or major change;
- changing current project scope;
- sequencing future work;
- architecture proposals or updates;
- durable technical decisions;
- detailed capability design;
- assessing alternatives, risks, boundaries, and acceptance implications.

## Do not use when

Do not use this skill to:

- create a GitHub Issue;
- promote an Issue;
- implement an approved slice;
- perform formal validation;
- review completed implementation;
- close an Issue.

Use the corresponding dedicated skill for those operations.

## Authority and boundaries

Read and obey `AGENTS.md` before using this skill.

Planning does not authorize implementation.

Do not:

- change project scope silently;
- present roadmap content as current project state;
- alter architecture merely to make a local implementation easier;
- create generic abstractions without proven need;
- introduce a central controller or multi-agent design without a demonstrated boundary;
- overwrite a durable decision without recording the new decision and rationale;
- create an Issue or slice unless a separate explicit handoff authorizes that operation.

## Planning modes

Classify the request into one primary mode.

### Project or phase planning

Use when defining:

- current goals;
- current scope or non-goals;
- phase outcomes;
- sequencing;
- work breakdown;
- exit criteria.

### Architecture work

Use when defining:

- system structure;
- component boundaries;
- dependency direction;
- interfaces between major parts;
- architectural constraints;
- durable structural tradeoffs.

### Design work

Use when defining:

- detailed behavior for one coherent capability;
- flows and edge cases;
- implementation-relevant boundaries;
- alternatives and risks;
- acceptance and validation implications.

A request may require more than one mode, but move between them deliberately and preserve the authority of each artifact.

## Required inputs

At minimum:

- a stated goal, problem, capability, or structural proposal;
- current project scope;
- known constraints.

For an artifact update, also require explicit authorization to modify that artifact.

## Required context

### For project or phase planning

Load:

- `docs/project.md`;
- `docs/roadmap.md`;
- `docs/architecture.md`;
- relevant entries in `docs/decisions.md`;
- relevant completed designs.

Load `docs/testing.md` when confidence or acceptance implications affect the plan.

Inspect code only when existing implementation behavior is needed to bound the proposal.

### For architecture work

Load:

- `docs/project.md`;
- `docs/architecture.md`;
- `docs/decisions.md`;
- relevant designs;
- relevant code.

Load `docs/testing.md` when the structural proposal affects validation or confidence.

Load `docs/roadmap.md` only when sequencing is part of the decision.

### For design work

Load:

- `docs/project.md`;
- `docs/architecture.md`;
- `docs/decisions.md`;
- relevant existing designs;
- relevant code;
- `docs/testing.md` when validation implications matter.

## Procedure

1. Classify the primary planning mode.
2. State the requested outcome and the concern governed by each relevant source.
3. Determine the current state from the authoritative documents and, when necessary, the code.
4. Identify:
   - goals;
   - constraints;
   - explicit non-goals;
   - unresolved decisions;
   - dependencies;
   - existing behavior that must be preserved.
5. Check for conflicts among project scope, architecture, decisions, designs, and implementation.
6. Recommend the simplest viable approach for the current project maturity.
7. Evaluate alternatives only when they affect a meaningful tradeoff.
8. Define acceptance and testing implications at the appropriate level.
9. Determine which project artifacts should change:
   - update `docs/project.md` only when current scope, goals, phase, or exit criteria change;
   - update `docs/roadmap.md` only when future direction or sequencing changes;
   - update `docs/architecture.md` when the current structural model changes;
   - update `docs/decisions.md` when future work must preserve a durable choice and rationale;
   - create or update a design when detailed behavior and boundaries need a durable specification.
10. Modify those artifacts only when explicitly authorized.
11. Propose a bounded work breakdown when the plan is ready for execution.
12. Stop before Issue creation unless a separate handoff invokes `create-work-item`.

## Validation

Check that the result:

- is compatible with current project scope or explicitly changes it;
- respects durable decisions or explicitly supersedes them;
- preserves a simple, project-local architecture and the self-contained project boundary;
- separates current work from future work;
- includes meaningful non-goals;
- defines acceptance implications;
- does not assume automation or tooling that does not exist;
- does not contain implementation presented as planning.

## Required outputs

Depending on the mode, provide one or more of:

- recommended approach;
- explicit non-goals;
- affected documents;
- work breakdown;
- architecture proposal or updated architecture description;
- durable decision and rationale;
- complete design document;
- risks and unresolved questions;
- acceptance and validation implications.

Clearly distinguish proposed text from changes actually applied.

## Failure and escalation behavior

Stop and request or identify a decision when:

- the goal materially conflicts with current project scope;
- authoritative architecture or decisions conflict;
- the proposed structure violates the self-contained project boundary;
- required existing behavior cannot be determined;
- the proposal depends on an unapproved scope change;
- the requested outcome is too broad to become a coherent plan;
- a design decision would be arbitrary without product input.

Do not proceed by embedding an undocumented assumption.

## Completion conditions

This skill is complete when:

- the requested planning, architecture, or design question is resolved as far as current authority permits;
- non-goals and constraints are explicit;
- affected artifacts are identified;
- any authorized artifact changes are complete;
- unresolved blockers are visible;
- no implementation or lifecycle transition has occurred.
