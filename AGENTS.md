# Repository AI Development Instructions

## 1. Purpose

This repository uses an opinionated, document-driven workflow for AI-assisted software development.

This file is the reusable workflow constitution. It defines how agents should locate context, plan work, prepare slices, implement changes, validate results, and stop for human approval.

Keep product vision, roadmap, architecture, design, active work, and implementation history in their project-owned sources rather than embedding them here.

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
- future GitHub Issue templates;
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

### Bootstrap-only artifacts

If `docs/bootstrap-tasks.md` exists, it is a temporary queue used only while the repository's GitHub Issue workflow is not yet available. It is not part of the reusable project template and should be deleted after its contents are transferred into Issues.

## 4. Document responsibilities and authority

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
| GitHub Issues | Project work queue and required outcome of bounded work items | Reuse Issue templates; create project-specific Issues | Full file-level execution package |
| `docs/current-slice.md` | One approved, bounded execution package for the active work item | Reuse schema; reset active content | Backlog, multi-item plan, or authority to alter upstream constraints silently |
| `docs/testing.md` | Project-wide testing philosophy, validation standards, and confidence requirements | Reuse scaffold; specialize content | Slice-specific command results or substitute for acceptance criteria |
| Code and tests | Actual implemented behavior and executable evidence | Entirely project-specific | Product planning or undocumented policy |

A more detailed source may add specificity within its concern only when it remains compatible with the sources that govern other concerns.

`docs/current-slice.md` is the execution package during implementation. It does not silently override:

- its source work item;
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

## 5. Normal information flow

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

During repository bootstrap, `docs/bootstrap-tasks.md` may temporarily replace GitHub Issues.

## 6. Startup procedure

At the beginning of repository work:

1. Read this file.
2. Identify the requested work mode.
3. Load only the authoritative project sources required for that mode.
4. Reuse already loaded context.
5. Do not read every document by default.
6. Expand context only when a missing dependency or contradiction requires it.

## 7. Work modes and document loading

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

Update `docs/project.md` when current goals or scope change. Update `docs/roadmap.md` when future phase direction changes.

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

A GitHub Issue should define a meaningful, reviewable outcome. Do not duplicate the complete file-level execution plan that belongs in `docs/current-slice.md`.

If the Issue workflow is not yet available and `docs/bootstrap-tasks.md` exists, use its relevant entry as the temporary source work item.

### Slice preparation

Read:

- the source GitHub Issue, or approved temporary bootstrap task;
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

- the source work item;
- `docs/current-slice.md`;
- changed files and diff;
- validation results;
- relevant architecture, decisions, designs, and testing rules.

Review whether the result is correct, in scope, structurally compatible, meaningfully tested, and maintainable for the current project maturity.

## 8. Planning rules

For new features or major changes:

1. Clarify the goal and constraints.
2. Recommend the simplest viable approach.
3. Define non-goals.
4. Establish acceptance criteria.
5. Update project scope, architecture, or decisions only when their concerns change.
6. Create or update a design document when detailed design adds value.
7. Break approved work into small GitHub Issues, or temporary bootstrap tasks before Issues exist.
8. Promote only one ready work item into `docs/current-slice.md`.

Do not start implementation during planning unless explicitly requested.

Not every work item requires a new design document or decision record.

## 9. Work-item rules

GitHub Issues are the authoritative project work queue once the Issue workflow is established.

A ready implementation work item should define:

- goal;
- context;
- scope;
- non-goals;
- acceptance criteria;
- dependencies;
- relevant design documents.

Work items describe the required outcome. Detailed file-level execution instructions belong in `docs/current-slice.md`.

Do not use `docs/roadmap.md`, `docs/project.md`, or a design document as the active task queue.

## 10. Current slice rules

`docs/current-slice.md` is the single bounded execution package currently approved for implementation.

A slice should include:

- source work item;
- status;
- context;
- goal;
- scope;
- non-goals;
- implementation steps;
- expected files;
- validation commands;
- acceptance criteria;
- failure conditions;
- review checklist;
- completion notes.

A slice must be independently reviewable and small enough to complete without broad reinterpretation.

The slice may specify how to implement the source outcome. It may not quietly change what outcome was approved.

## 11. Implementation rules

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

## 12. Validation and review

Validation asks whether declared mechanical checks pass.

Review asks whether the implementation:

- satisfies the source work item and slice;
- preserves scope;
- respects architecture, decisions, and approved design;
- uses meaningful tests;
- avoids unsupported shortcuts;
- is maintainable enough for the current project maturity.

Passing tests alone does not prove the work is acceptable.

## 13. Completion behavior

After implementation:

1. report acceptance-criteria status;
2. list files changed;
3. report validation results;
4. identify blockers or known limitations;
5. record completion notes in the slice when requested;
6. stop for human approval.

Do not automatically select or begin another issue.

## 14. Scope management

Aggressively distinguish:

- current phase;
- future phase;
- useful idea;
- unnecessary complexity.

Move valid deferred ideas to the roadmap or an appropriate future location rather than expanding the active slice.

## 15. Architecture philosophy

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
