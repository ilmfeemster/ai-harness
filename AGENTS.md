# AI Development Harness Instructions

## 1. Purpose

This repository develops an opinionated, document-driven template for AI-assisted software projects.

The repository is both:

1. the development project for the harness template; and
2. the source structure from which future projects may begin.

Do not treat this repository as a central controller for unrelated repositories.

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

## 3. Instruction hierarchy

When instructions conflict, use this priority:

1. The user's current request.
2. `docs/current-slice.md`.
3. This `AGENTS.md`.
4. The active design document.
5. `docs/project.md`.
6. `docs/architecture.md`, `docs/decisions.md`, and `docs/testing.md`.
7. `docs/roadmap.md`.

Report material contradictions instead of silently choosing an interpretation.

## 4. Startup procedure

At the beginning of repository work:

1. Read this file.
2. Identify the requested mode of work.
3. Load only the documents required for that mode.
4. Reuse already loaded context.
5. Do not read every document by default.

## 5. Work modes and document loading

### Project or phase planning

Read:

- `docs/project.md`
- `docs/roadmap.md`
- `docs/architecture.md`
- relevant decisions

### Design work

Read:

- `docs/project.md`
- `docs/architecture.md`
- `docs/decisions.md`
- relevant existing design documents
- `docs/testing.md` when validation implications matter

### GitHub Issue creation

Read:

- `docs/project.md`
- the approved design document
- relevant architecture and testing constraints

Issues should represent meaningful, reviewable implementation increments. Do not duplicate the complete execution plan that belongs in `current-slice.md`.

### Slice preparation

Read:

- the source GitHub Issue;
- its linked design document;
- `docs/project.md`;
- relevant architecture, decisions, and testing rules;
- nearby code only when needed to make the slice executable.

### Implementation

Read:

- `docs/current-slice.md`;
- only the documents and code it references or clearly requires.

Treat the approved slice as the execution source of truth.

### Review

Read:

- the source issue;
- `docs/current-slice.md`;
- changed files and diff;
- validation results;
- relevant architecture, decisions, and testing rules.

## 6. Planning rules

For new features or major changes:

1. Clarify the goal and constraints.
2. Recommend the simplest viable approach.
3. Define non-goals.
4. Establish acceptance criteria.
5. Create or update a design document when needed.
6. Break the design into small GitHub Issues.
7. Promote only one ready issue into `docs/current-slice.md`.

Do not start implementation during planning unless explicitly requested.

## 7. GitHub Issue rules

GitHub Issues are the project work queue.

A ready implementation issue should define:

- goal;
- context;
- scope;
- non-goals;
- acceptance criteria;
- dependencies;
- relevant design documents.

Issues should describe what outcome is required. Detailed file-level execution instructions belong in `current-slice.md`.

## 8. Current slice rules

`docs/current-slice.md` is the single bounded execution package currently approved for implementation.

A slice should include:

- source issue;
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

## 9. Implementation rules

When implementing a slice:

- follow the listed steps sequentially;
- remain inside the stated scope;
- prefer small local changes over new abstractions;
- do not clean up unrelated code;
- do not rename unrelated files, components, types, or APIs;
- do not update dependencies unless required;
- do not begin the next slice automatically;
- stop and report contradictions or unrelated validation failures.

Do not satisfy acceptance criteria through hardcoding, bypasses, weakened tests, or placeholder functionality unless explicitly required.

## 10. Validation and review

Validation asks whether declared mechanical checks pass.

Review asks whether the implementation:

- satisfies the issue and slice;
- preserves scope;
- respects architecture and decisions;
- uses meaningful tests;
- avoids unsupported shortcuts;
- is maintainable enough for the current project maturity.

Passing tests alone does not prove the work is acceptable.

## 11. Completion behavior

After implementation:

1. report acceptance-criteria status;
2. list files changed;
3. report validation results;
4. identify blockers or known limitations;
5. record completion notes in the slice when requested;
6. stop for human approval.

Do not automatically select or begin another issue.

## 12. Scope management

Aggressively distinguish:

- current phase;
- future phase;
- useful idea;
- unnecessary complexity.

Move valid deferred ideas to the roadmap or an appropriate future-ideas location rather than expanding the active slice.

## 13. Architecture philosophy

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
