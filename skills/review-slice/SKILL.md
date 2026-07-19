# Review Slice

## Purpose

Independently evaluate whether the implemented and validated slice is correct, in scope, structurally compatible, meaningfully tested, and maintainable for the project's current maturity.

Review is distinct from validation and final human approval.

## When to use

Use this skill when:

- the active slice is `Ready for review`;
- the source Issue, implementation diff, and validation evidence are available;
- a code or implementation review has been requested.

An explicitly requested partial or advisory review may occur earlier, but it must be labeled partial and may not advance lifecycle state.

## Do not use when

Do not use this skill to:

- implement fixes;
- rerun formal validation unless separately requested;
- rewrite the Issue or slice silently;
- set the slice to `Complete`;
- close the source Issue;
- authorize another work item.

## Authority and boundaries

Read and obey `AGENTS.md` before using this skill.

Review evaluates the result against:

- the source Issue;
- the approved slice;
- current project scope;
- architecture;
- durable decisions;
- approved design;
- testing standards;
- actual implementation evidence.

Do not infer approval from passing tests.

Do not omit findings merely because they require another implementation handoff.

## Required inputs

- source Issue;
- `docs/current-slice.md`;
- changed files and diff;
- formal validation results;
- completion evidence.

For lifecycle review, the slice must normally be `Ready for review`.

## Required context

Load:

1. source Issue;
2. current slice;
3. implementation diff and changed files;
4. formal validation evidence;
5. relevant architecture;
6. relevant durable decisions;
7. linked approved design;
8. relevant testing standards.

Expand context only when a changed dependency, referenced behavior, or apparent contradiction requires it.

## Review procedure

1. Verify source Issue and slice traceability.
2. Verify the slice is in the expected review state.
3. Read the diff before relying on the implementation summary.
4. Evaluate correctness against each acceptance criterion.
5. Check for:
   - out-of-scope changes;
   - missing required behavior;
   - unsupported shortcuts;
   - hardcoding or bypasses;
   - weakened tests;
   - architecture violations;
   - decision or design conflicts;
   - unnecessary abstractions;
   - unrelated cleanup;
   - dependency changes without need;
   - unhandled failure paths;
   - misleading completion evidence.
6. Evaluate test quality, not only test passage.
7. Confirm formal validation covers the meaningful risk.
8. Assess maintainability relative to current project maturity.
9. Record findings first, ordered by severity.
10. For each finding, include:
    - severity;
    - affected location;
    - problem;
    - consequence;
    - required or recommended correction.
11. Report acceptance-criteria status.
12. Report open questions, assumptions, and validation gaps.
13. Provide a concise change summary.
14. State whether the result appears ready for human approval.
15. Do not change completion state.

## Severity guidance

Use severity according to consequence:

- **Critical** — unsafe or fundamentally invalid result; approval must not proceed.
- **High** — incorrect required behavior, serious scope violation, or major architectural conflict.
- **Medium** — meaningful defect, missing edge case, weak evidence, or maintainability issue requiring correction.
- **Low** — limited risk or improvement that does not normally block acceptance.
- **Observation** — contextual note or non-blocking follow-up.

Do not inflate stylistic preferences into blocking findings.

## Validation of the review

Before completing, verify that:

- findings are supported by repository evidence;
- acceptance criteria were checked individually;
- tests were assessed for meaning, not only status;
- scope and authority were reviewed;
- assumptions are explicit;
- no code or lifecycle state was changed;
- absence of findings is not represented as human approval.

## Required outputs

Use this order:

1. findings ordered by severity;
2. acceptance-criteria status;
3. open questions and assumptions;
4. validation gaps;
5. concise change summary;
6. readiness for human approval.

When no findings exist, say so explicitly and still report acceptance and validation status.

## Failure and escalation behavior

Stop or qualify the review when:

- the source Issue is unavailable;
- the slice cannot be traced to the Issue;
- the diff is incomplete;
- validation evidence is missing or unreliable;
- a material authority conflict prevents evaluation.

When changes are required:

- identify them precisely;
- do not implement them;
- do not change the slice status automatically;
- require a separate `implement-slice` handoff.

If corrective work changes the approved outcome, the Issue and slice must return through revision and human reapproval.

## Completion conditions

This skill is complete when:

- the implementation has been evaluated independently;
- findings and acceptance status are explicit;
- human-approval readiness is stated;
- no implementation, Issue closure, or `Complete` transition has occurred.
