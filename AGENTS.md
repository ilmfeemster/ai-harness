# Repository AI Development Instructions

## 1. Purpose

This repository uses an opinionated, document-driven workflow for AI-assisted software development.

This file is the reusable workflow constitution. It defines how agents locate context, plan work, create work items, prepare slices, implement changes, validate results, and stop for human approval.

Keep product vision, roadmap, architecture, decisions, designs, active work, and implementation history in their project-owned sources rather than embedding them here.

## 2. Core philosophy

Project intelligence should live primarily in durable project documents rather than repeated prompts.

Prefer:

- explicit documents;
- bounded work items;
- small vertical slices;
- deterministic validation;
- reviewable changes;
- manual approval at important boundaries;
- abstraction only after repeated patterns are proven.

Do not optimize for autonomy for its own sake.

## 3. Template reuse boundary

The harness separates reusable workflow mechanics from project-specific intelligence.

### Reused as workflow assets

These should normally be copied into a new project with little or no project-specific content:

- `AGENTS.md`;
- `.github/ISSUE_TEMPLATE/`;
- `templates/docs/current-slice.md`;
- future structural validators and workflow scripts;
- reusable document schemas or starter headings.

### Initialized as project-owned documents

These paths may be created from reusable scaffolds, but their substantive content must describe the new project:

- `README.md`;
- `docs/project.md`;
- `docs/roadmap.md`;
- `docs/architecture.md`;
- `docs/decisions.md`;
- `docs/testing.md`;
- `docs/design/*.md`;
- `docs/current-slice.md`;
- GitHub Issues;
- source code and tests.

Do not copy another project's product context, roadmap, architecture, decisions, designs, active slice, or work-item contents into a new project merely because the file paths are part of the template.

## 4. Document responsibilities

Authority is determined **by concern**, not by one universal descending hierarchy.

| Source | Primary responsibility | Template treatment | Must not become |
| --- | --- | --- | --- |
| User request | Immediate intent, explicit scope changes, and approval | Not a repository artifact | An undocumented permanent project rule |
| `README.md` | Human entry point, project introduction, setup, and navigation | Reuse structure; replace project content | Workflow constitution, roadmap, or architecture specification |
| `AGENTS.md` | AI workflow, context loading, work modes, boundaries, and completion behavior | Reuse nearly verbatim | Product scope, architecture, backlog, or active implementation state |
| `docs/project.md` | Current product state, active phase, goals, scope, non-goals, and exit criteria | Reuse scaffold; replace content | Long-term roadmap, architecture specification, or task queue |
| `docs/roadmap.md` | Directional future phases, outcomes, and sequencing | Reuse scaffold; replace content | Active status board, detailed design, or execution plan |
| `docs/architecture.md` | Current system structure, boundaries, components, dependency direction, and architectural constraints | Reuse scaffold; replace content | Generic workflow governance, project backlog, or decision history |
| `docs/decisions.md` | Durable project decisions, rationale, and tradeoffs | Reuse empty format; replace entries | General notes, temporary planning, or status log |
| `docs/design/*.md` | Detailed approved design for a coherent capability or change | Reuse document pattern; create project-specific designs | Work queue, implementation transcript, or broad project roadmap |
| GitHub Issues | Project work queue and required outcome of bounded work items | Reuse Issue forms; create project-specific Issues | Full file-level execution package |
| `templates/docs/current-slice.md` | Reusable scaffold for initializing one project's active slice | Reuse scaffold; replace placeholders in project-owned `docs/current-slice.md` | Active Issue state, validation evidence, or harness-specific work history |
| `docs/current-slice.md` | One approved, bounded execution package for the active Issue | Reuse schema; reset active content | Backlog, multi-item plan, or authority to alter upstream constraints silently |
| `docs/testing.md` | Project-wide testing philosophy, validation standards, and confidence requirements | Reuse scaffold; specialize content | Slice-specific command results or substitute for acceptance criteria |
| Code and tests | Actual implemented behavior and executable evidence | Entirely project-specific | Product planning or undocumented policy |

A more detailed source may add specificity within its concern only when it remains compatible with sources governing other concerns.

## 5. Conflict handling

`docs/current-slice.md` is the execution package during implementation. It does not silently override:

- its source Issue;
- current project scope;
- architecture;
- durable decisions;
- an approved design;
- project-wide testing standards.

When authoritative sources materially conflict:

1. stop the affected work;
2. identify the conflicting statements;
3. state which concern each source governs;
4. correct the appropriate upstream source when authorized, or request a decision;
5. do not resolve the conflict through an undocumented assumption.

## 6. Normal information flow

Not every change requires every layer.

A design-heavy capability may flow through:

```text
docs/roadmap.md
↓
docs/project.md
↓
docs/architecture.md + docs/decisions.md
↓
docs/design/<capability>.md
↓
GitHub Issue
↓
docs/current-slice.md
↓
implementation
↓
validation + review
↓
human approval
```

A small, well-understood change may flow through:

```text
GitHub Issue
↓
docs/current-slice.md
↓
implementation
↓
validation + review
↓
human approval
```

## 7. Startup procedure

At the beginning of repository work:

1. Read this file.
2. Identify the requested work mode.
3. Load only the authoritative project sources required for that mode.
4. Reuse already loaded context.
5. Do not read every document by default.
6. Expand context only when a missing dependency or contradiction requires it.

## 8. Work modes and document loading

### Repository orientation

Read:

- `README.md`;
- `docs/project.md`;
- `docs/architecture.md`;
- `docs/roadmap.md` only when future direction matters.

### Project or phase planning

Read:

- `docs/project.md`;
- `docs/roadmap.md`;
- `docs/architecture.md`;
- relevant durable decisions;
- relevant completed designs when they constrain the plan.

Update `docs/project.md` when current goals or scope change. Update `docs/roadmap.md` when future direction changes.

### Architecture work

Read:

- `docs/project.md`;
- `docs/architecture.md`;
- `docs/decisions.md`;
- relevant designs and code.

Update `docs/architecture.md` for the current structural model. Record a decision in `docs/decisions.md` when future work must preserve the choice, rationale, or tradeoffs.

### Design work

Read:

- `docs/project.md`;
- `docs/architecture.md`;
- `docs/decisions.md`;
- relevant existing designs;
- relevant code;
- `docs/testing.md` when confidence or validation implications matter.

A design document should define behavior, boundaries, flows, alternatives, risks, and acceptance implications. It should not act as the implementation queue.

### Work-item creation

Read:

- `docs/project.md`;
- the relevant approved design, when one exists;
- relevant architecture and decisions;
- relevant testing constraints.

Create one meaningful, reviewable outcome per Issue. Do not duplicate the complete file-level execution plan that belongs in `docs/current-slice.md`.

### Slice preparation

Read:

- the source GitHub Issue;
- its linked design document, when one exists;
- `docs/project.md`;
- relevant architecture, decisions, and testing rules;
- nearby code only when needed to make the slice executable.

The slice may add implementation detail but must preserve the source outcome and upstream constraints.

### Implementation

Read:

- `docs/current-slice.md`;
- only the documents and code it references or clearly requires.

Treat the approved slice as the bounded execution package. Do not expand scope merely because additional work is discoverable.

### Validation

Read:

- validation commands and acceptance criteria in `docs/current-slice.md`;
- `docs/testing.md`;
- relevant test configuration or code.

Run the most specific declared commands first. Project-wide standards supplement rather than replace slice-specific checks.

### Review

Read:

- the source Issue;
- `docs/current-slice.md`;
- changed files and diff;
- validation results;
- relevant architecture, decisions, designs, and testing rules.

Review whether the result is correct, in scope, structurally compatible, meaningfully tested, and maintainable for the current project maturity.

## 9. Planning rules

For new features or major changes:

1. Clarify the goal and constraints.
2. Recommend the simplest viable approach.
3. Define non-goals.
4. Establish acceptance criteria.
5. Update project scope, architecture, or decisions only when their concerns change.
6. Create or update a design document when detailed design adds value.
7. Break approved work into small GitHub Issues.
8. Promote only one ready Issue into `docs/current-slice.md`.

Do not start implementation during planning unless explicitly requested.

Not every work item requires a new design document or decision record.

## 10. GitHub Issue contract

GitHub Issues are the authoritative project work queue.

Use the implementation form for features, refactors, documentation, infrastructure, and other planned changes. Use the bug form for incorrect existing behavior.

Every Issue form captures the following concerns. An Issue becomes ready only after every readiness checkbox is checked:

- goal or expected outcome;
- context;
- included scope;
- explicit non-goals;
- acceptance criteria;
- dependencies;
- relevant project documents;
- readiness confirmation.

Issue forms are reusable workflow assets. Each submitted Issue is project-specific state.

### Issue lifecycle

An Issue moves through these conceptual states:

1. **Draft** — required information, decisions, or dependencies are incomplete, or one or more readiness boxes remain unchecked.
2. **Ready** — required fields are complete, dependencies are satisfied, and every readiness item is checked.
3. **Active** — the Issue is referenced by the one approved `docs/current-slice.md`.
4. **Complete** — implementation is validated, reviewed, human-approved, and the Issue is closed.

Do not use labels as the authoritative workflow state. Phase 0 requires no custom labels. Existing labels such as `bug`, `enhancement`, or `documentation` may classify work, but readiness comes from the Issue contract and active status comes from `current-slice.md`.

### Readiness requirements

An Issue may be promoted only when:

- the outcome is singular and bounded;
- scope and non-goals are explicit;
- acceptance criteria can be evaluated;
- dependencies are satisfied or explicitly handled by the slice;
- relevant documents are linked;
- no unresolved product or architecture decision blocks execution;
- the Issue is small enough for one reviewable slice.

### Promotion to current slice

When promoting an Issue:

1. verify readiness;
2. place the Issue number, title, and URL in `docs/current-slice.md`;
3. preserve the Issue's goal, scope, non-goals, and acceptance criteria;
4. add file-level steps, commands, failure conditions, and review checks in the slice;
5. create or update the slice with status `Draft`;
6. obtain human approval before changing the slice status to `Approved`;
7. leave every other Issue unpromoted.

If the required outcome changes materially after promotion, update the Issue, revise the slice, return the slice to `Draft`, and obtain human approval again. If only execution detail changes, update the slice and record the adjustment.

Newly discovered work outside the Issue scope becomes a separate Issue rather than silently expanding the active slice.

Close the Issue only after human approval of the completed implementation.

## 11. Current slice rules

`docs/current-slice.md` is the single bounded execution package for the active Issue. It is project-owned operational state initialized from a reusable scaffold, not reusable project content.

### Required active-slice sections

Every active slice must include these sections. A section may state that evidence is pending when the slice has not reached that lifecycle stage, but required sections must not be silently omitted.

- work-item title;
- status;
- source Issue number, title, and URL;
- context;
- goal;
- scope;
- non-goals;
- acceptance criteria;
- implementation plan;
- expected files;
- validation plan;
- failure conditions;
- review checklist;
- completion evidence.

### Optional active-slice sections

Include these only when they add useful execution context:

- dependencies and assumptions;
- relevant project documents;
- linked design documents;
- implementation constraints;
- implementation adjustments;
- blockers and known limitations;
- rollback or migration notes.

Optional sections should be brief and should not duplicate large amounts of upstream documentation.

### Slice status values

Use only these status values:

1. **Draft** - the Issue has been translated into a candidate slice, but implementation is not authorized.
2. **Approved** - a human has approved the slice; the source Issue is now the single active work item and implementation may begin.
3. **In progress** - implementation has begun within the approved boundaries.
4. **Blocked** - implementation cannot continue without resolving a stated dependency, conflict, or decision.
5. **Ready for review** - implementation and declared validation are complete, completion evidence is recorded, and human review is required.
6. **Complete** - the result has received human approval and the source Issue has been closed.

Do not use contradictory states such as `Complete - awaiting human approval`. Work awaiting final approval is `Ready for review`.

A slice must be independently reviewable and small enough to complete without broad reinterpretation.

The slice may specify how to implement the source outcome. It may not quietly change what outcome was approved.

An active approved slice may not contain unresolved scaffold placeholders. The reusable scaffold may contain placeholders only because it is not an approved execution package.

### Execution refinements and reapproval

The active slice may refine execution details without changing the approved Issue outcome. Record meaningful execution-only changes under implementation adjustments.

A material change to the required outcome, scope, non-goals, or acceptance criteria requires:

1. updating the source Issue;
2. revising the slice;
3. returning the slice to `Draft`;
4. obtaining human approval again.

Newly discovered out-of-scope work must become a separate Issue.

### Completion evidence

Before a slice becomes `Ready for review`, its completion evidence must report:

- acceptance-criteria status;
- files changed;
- validation commands executed and their results;
- manual checks performed;
- implementation adjustments or deviations;
- blockers, known limitations, or follow-up Issues;
- a concise implementation summary.

The source Issue remains open until the result receives human approval.

## 12. Implementation rules

When implementing a slice:

- follow the listed steps sequentially unless repository evidence requires a clearly reported adjustment;
- remain inside the stated scope;
- preserve architecture, durable decisions, and approved design;
- prefer small local changes over new abstractions;
- do not clean up unrelated code;
- do not rename unrelated files, components, types, or APIs;
- do not update dependencies unless required;
- do not begin the next slice automatically;
- stop and report material contradictions or unrelated validation failures.

Do not satisfy acceptance criteria through hardcoding, bypasses, weakened tests, or placeholder functionality unless explicitly required.

## 13. Validation and review

Validation asks whether declared mechanical checks pass.

Review asks whether the implementation:

- satisfies the source Issue and slice;
- preserves scope;
- respects architecture, decisions, and approved design;
- uses meaningful tests;
- avoids unsupported shortcuts;
- is maintainable enough for the current project maturity.

Passing tests alone does not prove the work is acceptable.

## 14. Completion behavior

After implementation:

1. report acceptance-criteria status;
2. list files changed;
3. report validation results;
4. identify blockers or known limitations;
5. record completion notes in the slice when requested;
6. set the slice status to `Ready for review` when implementation and declared validation are complete;
7. stop for human approval;
8. after approval, close the source Issue and set the slice status to `Complete`.

Do not automatically select or begin another Issue.

## 15. Scope management

Aggressively distinguish:

- current phase;
- future phase;
- useful idea;
- unnecessary complexity.

Move valid deferred ideas to the roadmap or a new Issue rather than expanding the active slice.

## 16. Architecture philosophy

Prefer:

- simple systems;
- explicit behavior;
- boring technology;
- small abstractions;
- vertical slices;
- inspectability;
- fast feedback.

Avoid:

- premature frameworks;
- generic adapters before multiple real implementations exist;
- central orchestration before project-local workflows prove insufficient;
- multi-agent systems without a demonstrated role boundary;
- solving hypothetical scaling problems.
