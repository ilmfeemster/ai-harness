# Testing and Validation

## Goal

Define the confidence required before harness work is considered complete.

This document separates:

- structural validation;
- behavioral testing;
- workflow validation;
- human review;
- future automated evaluation.

## Testing philosophy

Prioritize confidence and correctness over test count.

Prefer checks that detect meaningful workflow failure rather than proving that files merely exist.

Testing depth should increase with harness maturity.

## Phase 0 validation priorities

Phase 0 should prove that:

- required project documents exist;
- document responsibilities are clear;
- a GitHub Issue can represent a ready work item;
- one issue can be promoted into a bounded slice;
- the slice contains all required sections;
- declared validation commands are usable;
- implementation completion is reviewable;
- the workflow can be exercised on a real project.

## Validation versus review

### Validation

Mechanical evidence such as:

- required files and sections;
- no unresolved placeholders;
- parseable configuration;
- command exit codes;
- automated test results;
- formatting checks.

### Review

Judgment about whether:

- the issue is actually satisfied;
- scope remained bounded;
- architecture and decisions were preserved;
- tests are meaningful;
- the implementation used unsupported shortcuts;
- the result is maintainable for the current maturity.

Passing validation does not automatically imply approval.

## Phase 0 test levels

### Structural tests

Validate the template itself:

- required files exist;
- required headings exist;
- referenced paths are valid where practical;
- `current-slice.md` includes a source issue and validation commands;
- approved slices contain no unresolved template markers.

### Unit tests

When local scripts are added, test deterministic parsing and validation behavior.

### Integration tests

Exercise complete local commands against fixture repositories or temporary directories.

### Workflow tests

Run a real work item through:

```text
GitHub Issue
→ current-slice.md
→ implementation
→ validation
→ review
```

The fantasy-football repository is the first testbed.

### Manual QA

Confirm that:

- document loading is understandable;
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

## Future evaluation

Independent automated evaluation is planned for Phase 3.

It should compare:

- source issue;
- approved slice;
- relevant project documents;
- implementation diff;
- changed tests;
- validation results;
- implementation report.

Phase 0 should not pretend that mechanical tests already provide this evaluation layer.
