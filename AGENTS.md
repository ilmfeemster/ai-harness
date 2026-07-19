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
2. Identify the primary work mode from the request and the current slice, when one exists.
3. Load the required authoritative sources for that mode before optional context.
4. Reuse already loaded context instead of rereading the same source.
5. Treat optional sources as conditional inputs, not a checklist to complete by default.
6. Expand context only when a required dependency is missing, a referenced source is needed to evaluate behavior, or the loaded sources materially contradict one another.
7. Stop before a side effect when the required source, approval, or decision is missing.

## 8. Work modes and document loading

Each mode is a bounded operation with explicit inputs, loading rules, outputs, prohibited side effects, and stop conditions. A request may move from one mode to another, but a handoff must be explicit. Planning and preparation do not authorize implementation, and implementation does not authorize final approval or Issue closure.

Context loading is selective. Required sources are loaded first. Optional sources are loaded only when the request, a linked reference, a validation command, or a contradiction makes them relevant. Do not expand context merely for completeness.

### Repository orientation

**Required inputs:**

- repository root and the user's orientation question or stated area of interest.

**Load:**

- `AGENTS.md`;
- `README.md`;
- `docs/project.md`;
- `docs/architecture.md`;
- `docs/roadmap.md` only when future direction or sequencing matters.

Load `docs/current-slice.md`, `docs/decisions.md`, `docs/testing.md`, designs, or code only when the orientation request concerns active work, a durable decision, validation, a design, or an implementation area.

**Expected output:** A concise repository map, current scope and architecture summary, relevant constraints, and the next authoritative sources needed for the user's question.

**Prohibited side effects:** Do not modify files, Issues, slice status, dependencies, or workflow state during orientation.

**Stop conditions:** Stop after the requested orientation is answered. Expand only when a referenced path is missing from the loaded sources or a material contradiction prevents an accurate summary.

### Project or phase planning

**Required inputs:**

- a stated goal, problem, or phase outcome;
- current project scope.

**Load:**

- `docs/project.md`;
- `docs/roadmap.md`;
- `docs/architecture.md`;
- relevant entries in `docs/decisions.md`;
- relevant completed designs when they constrain the plan.

Load `docs/testing.md` when confidence, acceptance, or validation implications affect the plan. Load code only when existing behavior is needed to bound the change.

**Expected output:** A recommended approach, explicit non-goals, acceptance implications, affected project documents, and a proposed work breakdown. A planning result may recommend a design or Issue but does not become either artifact unless that handoff is requested.

**Prohibited side effects:** Do not implement code, create a current slice, or silently change project scope. Update `docs/project.md` only when the current goal or scope is explicitly being changed; update `docs/roadmap.md` only when future direction or sequencing is explicitly being changed.

**Stop conditions:** Stop for an unresolved product, architecture, or durable-decision conflict. Do not proceed to work-item creation until the outcome is singular enough to review.


### Architecture work

**Required inputs:**

- a proposed structural change, boundary, dependency, or architectural decision;
- the current project scope and architecture.

**Load:**

- `docs/project.md`;
- `docs/architecture.md`;
- `docs/decisions.md`;
- relevant designs and code.

Load `docs/testing.md` when the structural change affects confidence or validation. Load the roadmap only when sequencing is part of the decision.

**Expected output:** A bounded architecture change or decision proposal with affected boundaries, dependency direction, tradeoffs, and required follow-up documents. Update `docs/architecture.md` for the current structural model and record a durable choice in `docs/decisions.md` when future work must preserve its rationale or tradeoffs.

**Prohibited side effects:** Do not implement unrelated behavior, introduce a central controller, or change product scope to make a structural proposal fit.

**Stop conditions:** Stop when the proposed structure conflicts with current scope, a durable decision, or the self-contained project boundary, or when the required behavior cannot be understood from the loaded sources.

### Design work

**Required inputs:**

- a coherent capability or change to design;
- known goals, constraints, and relevant project scope.

**Load:**

- `docs/project.md`;
- `docs/architecture.md`;
- `docs/decisions.md`;
- relevant existing designs;
- relevant code;
- `docs/testing.md` when confidence or validation implications matter.

**Expected output:** A project-specific design that defines behavior, boundaries, flows, alternatives, risks, and acceptance implications. The design is a decision artifact, not the implementation queue.

**Prohibited side effects:** Do not implement the capability, create an Issue, or create a current slice unless that handoff is explicitly requested.

**Stop conditions:** Stop when a product or architecture decision is unresolved, when the design would require a scope change not approved by the project documents, or when the relevant existing behavior cannot be determined.

### Work-item creation

**Required inputs:**

- one singular, bounded outcome;
- its context, scope, non-goals, acceptance criteria, dependencies, and relevant documents.

**Load:**

- `docs/project.md`;
- the relevant approved design, when one exists;
- relevant `docs/architecture.md` and `docs/decisions.md` entries;
- relevant testing constraints from `docs/testing.md`.

**Expected output:** One meaningful, reviewable GitHub Issue using the reusable form, with its goal, context, scope, non-goals, acceptance criteria, dependencies, relevant documents, and readiness confirmation. The Issue describes the outcome; file-level execution detail belongs in `docs/current-slice.md`.

**Prohibited side effects:** Do not create multiple Issues for one outcome, promote an Issue into a slice, or begin implementation. Do not mark readiness complete by assumption when a dependency or decision is unresolved.

**Stop conditions:** Stop when the outcome is not singular, acceptance cannot be evaluated, dependencies are unknown or unsatisfied, relevant documents are missing, or an unresolved decision blocks execution.

### Slice preparation

**Required inputs:**

- one ready GitHub Issue;
- the Issue's approved outcome, scope, non-goals, and acceptance criteria.

**Load:**

- the source GitHub Issue;
- its linked design document, when one exists;
- `docs/project.md`;
- relevant architecture, decisions, and testing rules;
- nearby code only when needed to make the slice executable.

**Expected output:** A `Draft` `docs/current-slice.md` containing the required sections, source Issue traceability, file-level implementation steps, expected files, validation commands, failure conditions, and review checks. The slice may add execution detail but must preserve the source outcome and upstream constraints.

**Prohibited side effects:** Do not change the Issue outcome, authorize implementation, modify unrelated project documents, or prepare a second active slice. Promotion creates `Draft`; only explicit human approval changes it to `Approved`.

**Stop conditions:** Stop when the Issue is not ready, a dependency or authority conflict remains unresolved, the expected work is not bounded to one reviewable slice, or the slice would need to change the Issue rather than refine execution detail.

### Implementation

**Required inputs:**

- an `Approved` `docs/current-slice.md`;
- explicit authorization to implement the approved work.

**Load:**

- `docs/current-slice.md`;
- only the documents and code it references or clearly requires.

Verify the source Issue, expected files, implementation constraints, and validation plan before editing. Change the slice status to `In progress` when implementation begins.

**Expected output:** The implementation within the expected files, meaningful tests or documentation checks where required, validation results, and completion evidence. After implementation and declared validation pass, change the slice status to `Ready for review`; do not mark it `Complete` without human approval.

**Prohibited side effects:** Do not expand scope, alter the source Issue outcome, bypass acceptance criteria, weaken tests, update dependencies without need, begin another Issue, or close the source Issue. Treat the approved slice as the bounded execution package even when additional work is discoverable.

**Stop conditions:** Stop when the slice is not `Approved`, a required source or approval is missing, implementation reveals a material contradiction, work would exceed the slice, or unrelated validation failures prevent a trustworthy result.

### Validation

**Required inputs:**

- the implemented slice;
- its acceptance criteria and declared validation plan.

**Load:**

- validation commands and acceptance criteria in `docs/current-slice.md`;
- `docs/testing.md`;
- relevant test configuration or code.

**Expected output:** Command exit codes and results, manual-check results where required, acceptance-criteria status, known limitations, and evidence suitable for review. Run the most specific declared commands first; project-wide standards supplement rather than replace slice-specific checks.

**Prohibited side effects:** Do not weaken tests, rewrite acceptance criteria, hide command failures, or treat passing mechanical checks as human approval. Corrective implementation is a separate explicit handoff.

**Stop conditions:** Stop when a declared command fails, required evidence cannot be collected, the implementation does not match the slice, or validation exposes a scope or authority conflict.

### Review

**Required inputs:**

- the source Issue;
- `docs/current-slice.md`;
- the implementation diff and validation results.

**Load:**

- changed files and diff;
- validation results;
- relevant architecture, decisions, designs, and testing rules.

**Expected output:** Findings first, ordered by severity, followed by acceptance-criteria status, open questions or assumptions, validation gaps, and a concise change summary. Review whether the result is correct, in scope, structurally compatible, meaningfully tested, and maintainable for the current project maturity.

**Prohibited side effects:** Do not close the Issue, change the slice to `Complete`, or silently authorize follow-up work. Review findings may request changes, but implementation remains a separate bounded action.

**Stop conditions:** Stop when the source Issue or slice cannot be evaluated from the available evidence, when a material contradiction is found, or when human approval is still required for the requested lifecycle transition.

### Context expansion rules

Expand beyond a mode's required sources only when:

- a required source links to another artifact needed to understand the approved outcome or expected behavior;
- a validation command, test configuration, or changed file requires additional context;
- the loaded sources contain a material contradiction that cannot be resolved within the current concern;
- existing behavior must be inspected to determine whether the requested change is in scope;
- a newly discovered dependency affects the mode's stop conditions or acceptance evidence.

When context expands, preserve the original mode boundary and record a meaningful execution adjustment in `docs/current-slice.md` when the work is inside an active slice. Expansion must not become a reason to read every project document or to begin an unrelated work item.

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
