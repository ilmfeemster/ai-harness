# Testing and Validation

> **Project-context document:** This file defines confidence standards for the AI Development Harness project. A future project may reuse its structure and general concepts, but must specialize the actual commands, test levels, and acceptance standards for that project.

## Goal

Define the confidence required before harness work is considered complete.

This document separates:

- structural validation;
- behavioral testing;
- workflow validation;
- human review;
- future automated evaluation.

Slice-specific commands and results belong in `docs/current-slice.md`. This document owns project-wide standards.

## Testing philosophy

Prioritize confidence and correctness over test count.

Prefer checks that detect meaningful workflow failure rather than proving that files merely exist.

Testing depth should increase with harness maturity.

## Phase 0 validation priorities

Phase 0 should prove that:

- reusable workflow assets are distinguishable from project-context documents;
- a new project can be initialized without inheriting harness-specific context;
- neutral document scaffolds remain free of source-project state;
- a fresh initialized project starts with an empty active slice;
- required project documents exist;
- reusable Issue forms exist and require the readiness contract;
- submitted Issues remain project-specific work state;
- one ready Issue can be promoted into a bounded slice;
- Issue outcome and slice execution detail remain aligned;
- the slice contains all required sections;
- declared validation commands are usable;
- implementation completion is reviewable;
- the workflow can be exercised on a real project.

## Validation versus review

### Validation

Mechanical evidence such as:

- required files and sections;
- valid Issue-form YAML structure;
- no unresolved placeholders;
- parseable configuration;
- command exit codes;
- automated test results;
- formatting checks.

### Review

Judgment about whether:

- the source Issue is actually satisfied;
- the Issue was ready before promotion;
- the slice preserves the Issue outcome;
- scope remained bounded;
- architecture and decisions were preserved;
- tests are meaningful;
- the implementation used unsupported shortcuts;
- the result is maintainable for the current maturity.

Passing validation does not automatically imply approval.

### Local structural validation

The Phase 0 structural validator is a local, deterministic check. Run it from the repository root:

```powershell
powershell -NoProfile -File scripts/validate.ps1
```

It checks required repository paths, active-slice sections and traceability when the active slice is non-empty, Issue-template fields, neutral scaffold headings, unresolved scaffold placeholders, practical local references, declared validation commands, and obvious harness-specific state in reusable assets. For a newly initialized project, run it with `-InitializedProject -CleanInitialization` to check project-owned document leakage and the empty active slice. Failures must identify the failed check and its actionable cause.

The validator does not assess semantic implementation quality, invoke models, perform repair, or replace human review. Its deterministic behavior is tested separately:

```powershell
powershell -NoProfile -File tests/validate-structure.ps1
```

Both commands are local and replaceable. A passing command provides mechanical evidence only; the active slice still requires validation evidence, independent review where appropriate, and explicit human approval.

## Project-wide standards versus slice checks

`docs/testing.md` defines the level and type of evidence the project generally requires.

`docs/current-slice.md` identifies the exact commands, manual checks, and acceptance criteria required for one work item.

A slice may add stricter checks. It may not weaken project-wide standards merely to pass.

## Phase 0 test levels

### Structural tests

Validate the harness and generated project structure:

- required files exist;
- required headings exist;
- referenced paths are valid where practical;
- reusable assets do not contain harness-only project state;
- project-context scaffolds can be initialized without carrying source-project content;
- clean initialized project documents do not contain source-project names, URLs, phases, or active state;
- both reusable Issue forms exist;
- blank Issues are disabled so work uses the defined contract;
- Issue forms contain outcome, scope, non-goal, acceptance, dependency, document, and readiness fields;
- readiness boxes can remain unchecked for draft backlog Issues;
- a non-empty `current-slice.md` includes a source Issue and validation commands;
- a fresh initialized `current-slice.md` is empty until Issue promotion;
- approved slices contain no unresolved template markers;
- active slices use only valid status values: `Draft`, `Approved`, `In progress`, `Blocked`, `Ready for review`, or `Complete`;
- promoted active slices include the source Issue number, title, and URL;
- reusable slice scaffolds contain every required active-slice heading;
- reusable slice scaffolds contain no source-project active state such as project phase, Issue URL, validation result, or completion claim.

Slice structural checks should confirm these required headings in the reusable scaffold and in active slices:

- work-item title;
- `## Status`;
- `## Source Issue`;
- `## Context`;
- `## Goal`;
- `## Scope`;
- `## Non-goals`;
- `## Acceptance criteria`;
- `## Implementation plan`;
- `## Expected files`;
- `## Validation plan`;
- `## Failure conditions`;
- `## Review checklist`;
- `## Completion evidence`.

### Unit tests

When local scripts are added, test deterministic parsing and validation behavior.

### Integration tests

Exercise complete local commands against fixture repositories or temporary directories.

### Workflow tests

Run a real work item through:

```text
GitHub Issue
→ readiness review
→ current-slice.md
→ implementation
→ validation
→ review
→ approval
→ Issue closure
```

The fantasy-football repository is the first testbed.

### Manual QA

Confirm that:

- document loading is understandable;
- reusable workflow rules and project context are not mixed;
- a new project can be initialized from neutral scaffolds without copying source context;
- the initial active slice is empty and safe until a Ready Issue is promoted;
- Issue forms are useful without excessive ceremony;
- labels are not required to infer readiness;
- the slice is appropriately bounded;
- implementation can proceed without repeated clarification;
- completion output is easy to review;
- the workflow does not create unnecessary overhead.

## Acceptance standard

A harness slice is not complete until:

- its acceptance criteria are met;
- relevant automated checks pass;
- manual workflow validation is completed when appropriate;
- no test was weakened merely to pass;
- completion notes accurately describe the result;
- human review approves the outcome.

The source Issue is closed only after this standard is met.

## Future evaluation

Independent automated evaluation is planned for Phase 3.

It should compare:

- source Issue;
- approved slice;
- relevant project documents;
- implementation diff;
- changed tests;
- validation results;
- implementation report.

Phase 0 should not pretend that mechanical tests already provide this evaluation layer.
