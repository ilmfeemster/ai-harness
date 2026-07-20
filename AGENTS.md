# Repository AI Development Instructions

## 1. Purpose

This repository uses an opinionated, document-driven workflow for AI-assisted software development.

`AGENTS.md` is the reusable workflow constitution. It defines authority, invariants, lifecycle, approval boundaries, context rules, scope rules, and required skill use.

Repeatable procedures live in `skills/*/SKILL.md`.

Keep product vision, roadmap, architecture, decisions, designs, active work, and implementation history in their project-owned sources.

## 2. Core philosophy

Project intelligence should live primarily in durable repository documents rather than repeated prompts.

Prefer:

- explicit documents;
- bounded work items;
- small vertical slices;
- deterministic validation;
- independent review;
- reviewable changes;
- human approval at meaningful boundaries;
- abstraction only after repeated patterns are proven.

Do not optimize for autonomy for its own sake. Optimize for reliable, high-quality leverage.

## 3. Reuse boundary

### Reusable workflow assets

These should normally transfer to a new project with little or no project-specific content:

- `AGENTS.md`;
- `skills/`;
- `.github/ISSUE_TEMPLATE/`;
- `templates/` neutral document and active-slice scaffolds;
- structural validators and workflow scripts;
- reusable schemas and starter headings.

### Project-owned artifacts

These may use reusable scaffolds, but their substantive content must describe the current project:

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

Do not copy another project's product context, roadmap, architecture, decisions, designs, active slice, work items, or implementation history merely because the paths are reusable.

## 4. Authority by concern

Authority is determined by concern, not by one universal hierarchy.

| Source | Governing concern | Must not become |
| --- | --- | --- |
| User request | Immediate intent, authorization, scope changes, and human approval | An undocumented permanent project rule |
| `README.md` | Human entry point, setup, introduction, and navigation | Workflow constitution, roadmap, or architecture specification |
| `AGENTS.md` | Workflow authority, invariants, lifecycle, boundaries, and skill invocation | Product scope, backlog, or active implementation state |
| `skills/*/SKILL.md` | How an authorized operation is performed | New authority or permission beyond this constitution |
| `docs/project.md` | Current product state, active phase, goals, scope, non-goals, and exit criteria | Long-term roadmap, architecture specification, or task queue |
| `docs/roadmap.md` | Future phases, outcomes, and sequencing | Active status board, detailed design, or execution plan |
| `docs/architecture.md` | Current structure, boundaries, components, dependency direction, and constraints | Workflow governance, backlog, or decision history |
| `docs/decisions.md` | Durable project decisions, rationale, and tradeoffs | Temporary notes or status log |
| `docs/design/*.md` | Approved detailed design for a coherent capability or change | Work queue or implementation transcript |
| GitHub Issues | Work queue and required outcomes of bounded work items | Full file-level execution package |
| `templates/` | Reusable neutral document and active-slice scaffolds | Active project state or completion evidence |
| `docs/current-slice.md` | One bounded execution package for the active Issue | Backlog, multi-item plan, or silent override of upstream constraints |
| `docs/testing.md` | Project-wide validation standards and confidence requirements | Slice-specific results or substitute acceptance criteria |
| Code and tests | Actual implemented behavior and executable evidence | Product planning or undocumented policy |

A detailed source may add specificity within its concern only when compatible with sources governing other concerns.

A skill is subordinate to this constitution.

## 5. Universal invariants

### 5.1 One work item at a time

Maintain at most:

- one current slice;
- one active Issue;
- one implementation effort governed by that slice.

Do not prepare, approve, implement, or complete a second work item while another current slice remains unresolved.

Completion does not authorize selecting or beginning the next Issue.

### 5.2 Explicit operation handoffs

Orientation, planning, work-item creation, slice preparation, implementation, validation, review, and finalization are distinct operations.

Completion of one operation does not automatically authorize the next.

One user request may explicitly authorize several sequential operations, but agents must still stop at every human-approval boundary.

### 5.3 Human approval boundaries

Human approval is required:

- before a `Draft` slice becomes `Approved`;
- before a material change to an approved outcome proceeds;
- before a `Ready for review` slice becomes `Complete`;
- before the source Issue is closed.

Planning approval is not implementation authorization.

Implementation authorization is not completion approval.

Passing validation or review is not human approval.

### 5.4 Scope preservation

Do not silently change:

- project scope;
- Issue outcome;
- included scope;
- non-goals;
- acceptance criteria;
- architecture;
- durable decisions;
- approved design;
- testing standards.

Execution may refine implementation detail without reapproval only when the approved outcome remains unchanged.

New out-of-scope work belongs in a separate Issue. Do not implement or create it automatically.

### 5.5 No unsupported shortcuts

Do not satisfy acceptance criteria through:

- hardcoding that bypasses intended behavior;
- weakened or removed tests;
- hidden failures;
- unapproved placeholder functionality;
- undocumented assumptions;
- unrelated changes presented as necessary;
- automation or tools that do not exist.

### 5.6 Conflict handling

`docs/current-slice.md` does not silently override its source Issue, current scope, architecture, durable decisions, approved design, or project-wide testing standards.

When authoritative sources materially conflict:

1. stop the affected work;
2. identify the conflicting statements;
3. state which concern each source governs;
4. correct the appropriate upstream source when authorized, or request a decision;
5. do not resolve the conflict through assumption.

If a skill conflicts with this constitution, this constitution governs.

### 5.7 Stop before unauthorized side effects

Stop before changing repository state when a required source, approval, decision, or authorization is missing.

An informational request does not imply permission to modify files, Issues, dependencies, or lifecycle state.

## 6. Context loading

At the beginning of repository work:

1. read this file;
2. identify the requested operation;
3. read the complete required skill;
4. load that skill's required authoritative sources before optional context;
5. reuse already loaded context;
6. stop before a side effect when a required source, approval, or decision is missing.

Expand context only when:

- a required source links to another artifact needed to understand the work;
- a validation command, test configuration, or changed file requires it;
- loaded sources materially conflict;
- existing behavior must be inspected to determine scope or correctness;
- a newly discovered dependency affects a stop condition or acceptance evidence.

Do not expand context merely for completeness. Context expansion does not authorize another operation or unrelated work.

## 7. Workflow and required skills

A design-heavy capability may flow through:

```text
roadmap
→ project
→ architecture + decisions
→ design
→ GitHub Issue
→ current slice
→ human approval
→ implementation
→ validation
→ review
→ human approval
```

A small, well-understood change may begin at the Issue.

Before acting, read the complete skill for the operation:

| Operation | Required skill | Primary output |
| --- | --- | --- |
| Project initialization | `skills/start-project/SKILL.md` | Self-contained project with reusable assets and clean project-owned scaffolds |
| Repository orientation | `skills/orient-repository/SKILL.md` | Grounded repository map |
| Project, architecture, or design planning | `skills/plan-change/SKILL.md` | Plan or authorized planning artifact |
| Work-item creation | `skills/create-work-item/SKILL.md` | One Draft or Ready Issue |
| Slice preparation | `skills/prepare-slice/SKILL.md` | Complete `Draft` slice |
| Implementation or correction | `skills/implement-slice/SKILL.md` | Bounded implementation |
| Formal validation | `skills/validate-slice/SKILL.md` | Evidence and possible `Ready for review` transition |
| Independent review | `skills/review-slice/SKILL.md` | Findings and approval-readiness assessment |
| Finalization | `skills/finalize-work-item/SKILL.md` | Closed Issue and `Complete` slice |

Do not substitute a similarly named skill or improvise a new lifecycle operation.

A skill may identify a required handoff but may not authorize the next operation implicitly.

## 8. Planning boundaries

For new features or major changes:

1. clarify the goal and constraints;
2. recommend the simplest viable approach;
3. define non-goals;
4. establish acceptance implications;
5. update project scope, architecture, or decisions only when their concerns change;
6. create or update a design only when detailed design adds durable value;
7. break approved work into small Issues;
8. promote only one Ready Issue.

Not every work item requires a design or decision record.

Planning does not authorize Issue creation, slice preparation, or implementation unless those handoffs are separately explicit.

## 9. GitHub Issue contract

GitHub Issues are the authoritative work queue.

Use the implementation form for planned changes and the bug form for incorrect existing behavior.

Every Issue must include:

- goal or expected outcome;
- context;
- included scope;
- explicit non-goals;
- acceptance criteria;
- dependencies;
- relevant project documents;
- readiness confirmation.

### 9.1 Issue states

1. **Draft** — required information, decisions, dependencies, or readiness checks are incomplete.
2. **Ready** — the contract is complete, dependencies are satisfied or explicitly handled, and the work fits one reviewable slice.
3. **Active** — the Issue is referenced by the one human-approved current slice.
4. **Complete** — implementation is validated, reviewed, human-approved, and the Issue is closed.

An Issue remains `Ready` while its candidate slice is `Draft`. It becomes `Active` only when the slice becomes `Approved`.

Labels may classify work but are not authoritative workflow state.

### 9.2 Readiness requirements

An Issue may be promoted only when:

- the outcome is singular and bounded;
- scope and non-goals are explicit;
- acceptance criteria are evaluable;
- dependencies are satisfied or explicitly handled by the slice;
- relevant documents are linked;
- no unresolved product or architecture decision blocks execution;
- the work fits one independently reviewable slice;
- every readiness check is complete.

### 9.3 Promotion and outcome changes

Promotion:

- preserves the Issue's context, goal, scope, non-goals, and acceptance criteria;
- adds file-level steps, expected files, validation commands, failure conditions, and review checks;
- creates a `Draft` slice;
- requires human approval before `Approved`;
- leaves every other Issue unpromoted.

A material change to the outcome, scope, non-goals, or acceptance criteria requires:

1. updating the Issue;
2. revising the slice;
3. returning the slice to `Draft`;
4. obtaining human approval again.

Execution-only refinements may be recorded in the slice without changing the Issue.

Close the Issue only through `finalize-work-item` after explicit human approval.

## 10. Current slice contract

`docs/current-slice.md` is the single bounded execution package for the active Issue.

It must be independently reviewable and small enough to complete without broad reinterpretation.

It may specify how to implement the Issue. It may not change what outcome was approved.

### 10.1 Required sections

Every non-empty slice must include:

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

Evidence may be marked pending before its lifecycle stage. Required sections may not be omitted.

### 10.2 Optional sections

Include only when useful:

- dependencies and assumptions;
- relevant project documents;
- linked designs;
- implementation constraints;
- implementation adjustments;
- blockers and known limitations;
- rollback or migration notes.

Do not duplicate substantial upstream documentation.

### 10.3 Slice states

1. **Draft** — candidate execution package; implementation is not authorized.
2. **Approved** — human-approved package and single active work item; new implementation may begin when explicitly authorized.
3. **In progress** — implementation or correction has begun within approved boundaries.
4. **Blocked** — work cannot continue without a stated dependency, conflict, or decision.
5. **Ready for review** — implementation and formal validation are complete; evidence is recorded; review and human approval remain.
6. **Complete** — explicit human approval has been received and the source Issue is closed.

Do not use contradictory states such as `Complete - awaiting human approval`.

An approved slice may not contain unresolved scaffold placeholders.

### 10.4 Permitted transitions

```text
Draft
→ human approval
Approved
→ explicit implementation authorization
In progress
→ formal validation passes
Ready for review
→ review + explicit human approval + Issue closure
Complete
```

Additional transitions:

- `In progress` → `Blocked` when work cannot continue;
- `Blocked` → `In progress` after the blocker is resolved, the outcome is unchanged, and resumption is authorized;
- `Ready for review` → `In progress` for explicitly authorized corrective implementation;
- any material outcome change → `Draft` and reapproval.

### 10.5 Completion evidence

Before `Ready for review`, completion evidence must report:

- acceptance-criteria status;
- files changed;
- validation commands and results;
- manual checks;
- implementation adjustments or deviations;
- blockers, known limitations, or follow-up Issue references or candidates;
- concise implementation summary.

Completion evidence is mandatory. The Issue remains open until final human approval.

## 11. Implementation, validation, review, and finalization

### 11.1 Implementation

New implementation requires an `Approved` slice and explicit authorization.

Resumed or corrective implementation requires an eligible `Blocked` or `Ready for review` slice, explicit authorization, and confirmation that the approved outcome remains unchanged.

Implementation must:

- follow the slice unless evidence requires a reported execution-only refinement;
- remain in scope;
- preserve architecture, decisions, and approved design;
- prefer small local changes;
- avoid unrelated cleanup and renaming;
- update dependencies only when required;
- add meaningful tests where required;
- record meaningful adjustments;
- stop on material contradiction or out-of-scope work.

Implementation may run focused development checks.

It leaves the slice `In progress`. Formal validation owns the transition to `Ready for review`.

### 11.2 Validation

Validation asks whether declared commands and manual checks pass and whether every acceptance criterion has evidence.

Run the most specific declared checks first. Project-wide standards supplement rather than replace slice-specific checks.

Validation must report command exit codes, manual-check results, acceptance status, limitations, and reviewable evidence.

Do not weaken tests, rewrite acceptance criteria, hide failures, approve the result, or repair implementation without a separate handoff.

Successful formal validation completes the evidence and moves `In progress` to `Ready for review`.

### 11.3 Review

Review asks whether the result:

- satisfies the Issue and slice;
- remains in scope;
- respects architecture, decisions, and approved design;
- uses meaningful tests;
- avoids unsupported shortcuts;
- is maintainable for current project maturity.

Report findings first, ordered by severity, then acceptance status, assumptions, validation gaps, and a concise summary.

Review does not implement fixes, close the Issue, change the slice to `Complete`, or authorize follow-up work.

### 11.4 Finalization

Finalization requires:

- a `Ready for review` slice;
- completed validation and review;
- no unresolved blocking finding;
- explicit human approval.

Finalization closes the source Issue and changes the slice to `Complete`.

Do not claim completion unless both states are consistent. Report and reconcile any partial transition.

After completion, stop. Do not reset the slice, select another Issue, or begin new work automatically.

## 12. Scope and architecture philosophy

Aggressively distinguish:

- current phase;
- future phase;
- useful deferred idea;
- unnecessary complexity.

Move valid deferred ideas to the roadmap or a separate explicitly authorized Issue rather than expanding active work.

Prefer:

- simple systems;
- explicit behavior;
- boring technology;
- small abstractions;
- vertical slices;
- project-local solutions;
- inspectability;
- fast feedback.

Avoid:

- premature frameworks;
- generic adapters before multiple real implementations exist;
- central orchestration before project-local workflows prove insufficient;
- multi-agent systems without demonstrated role boundaries;
- hypothetical scaling infrastructure;
- abstractions created only to appear reusable.

Keep the harness opinionated for proven workflows. Generalize only after repeated real use reveals a stable pattern.
