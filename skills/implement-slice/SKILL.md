# Implement Slice

## Purpose

Implement exactly one human-approved `docs/current-slice.md` within its approved boundaries.

This skill owns entry into `In progress` for new, resumed, or corrective implementation. It produces implementation ready for formal validation. It does not perform final approval, close the Issue, or begin another work item.

## When to use

Use this skill only for one of these explicitly authorized transitions:

- new implementation from an `Approved` slice;
- resumed implementation from a `Blocked` slice after its blocker is resolved;
- corrective implementation from a `Ready for review` slice after review or validation identifies required changes.

The request must explicitly authorize implementation or corrective implementation.

## Do not use when

Do not use this skill when:

- the slice is `Draft` or `Complete`;
- approval or implementation authorization is ambiguous;
- a `Blocked` slice's blocker is unresolved;
- corrective work would materially change the approved outcome;
- the requested work exceeds the approved scope;
- the source Issue or required upstream context is unavailable;
- the request is only to validate or review existing work;
- the slice omits material execution detail and implementation would require broad reinterpretation.

## Authority and boundaries

Read and obey `AGENTS.md` before using this skill.

The approved slice is the bounded execution package. It remains subordinate, by concern, to:

- its source Issue;
- current project scope;
- architecture;
- durable decisions;
- approved design;
- testing standards.

Do not:

- expand scope;
- alter the source Issue outcome;
- weaken acceptance criteria;
- bypass or weaken tests;
- hardcode results merely to satisfy a check;
- add placeholder behavior unless explicitly required;
- clean up unrelated code;
- rename unrelated files, components, types, or APIs;
- update dependencies unless required;
- create or begin another Issue;
- close the source Issue;
- set the slice to `Ready for review` or `Complete`;
- silently supply product, architecture, design, lifecycle, warning, blocker, or policy rules omitted from the slice.

## Lifecycle ownership

This skill may perform only these status transitions:

- `Approved` → `In progress` when new implementation begins;
- `Blocked` → `In progress` when the stated blocker is resolved without changing the approved outcome;
- `Ready for review` → `In progress` when explicitly authorized corrective implementation begins.

If the outcome, scope, non-goals, or acceptance criteria must change, the slice must return to `Draft` and receive human approval again.

This skill leaves successfully implemented work `In progress`. Formal validation owns the transition to `Ready for review`.

## Required inputs

For all implementation:

- `docs/current-slice.md`;
- explicit human authorization to implement or correct the active work.

For resumed work:

- the stated blocker and evidence that it is resolved.

For corrective work:

- the validation failure or review finding being corrected.

## Required context

Load:

1. `docs/current-slice.md`;
2. the source Issue sufficiently to verify traceability;
3. documents explicitly referenced by the slice;
4. code, tests, fixtures, and configuration named by or clearly required by the slice;
5. the relevant blocker, validation result, or review finding for resumed or corrective work.

Expand context only when:

- a referenced dependency must be understood;
- existing behavior must be inspected;
- a changed file requires related context;
- a material contradiction appears.

Do not read unrelated project documents for completeness.

## Preflight

Before editing:

1. Determine whether the operation is new, resumed, or corrective implementation.
2. Verify the current status is eligible:
   - `Approved` for new implementation;
   - `Blocked` for resumed implementation;
   - `Ready for review` for corrective implementation.
3. Verify implementation authorization is explicit.
4. For resumed work, verify the stated blocker is resolved.
5. For corrective work, verify the requested correction remains within the approved outcome.
6. Verify the source Issue matches the slice.
7. Verify the expected files and implementation plan remain plausible.
8. Verify required upstream sources are present.
9. Verify no material conflict exists.
10. Verify the work still fits the approved boundaries.
11. Verify the slice passes the implementation-readiness gate below.
12. Change the slice status to `In progress` when implementation begins.

If any check fails, do not edit implementation files.

## Implementation-readiness gate

Before editing, confirm the slice provides enough detail to identify:

- the existing implementation seam or intended integration point;
- the material file or component responsibilities;
- the governing decision branches;
- expected inputs, outputs, side effects, and failure behavior where relevant;
- required fixtures and tests for material behavior;
- validation coverage for the acceptance criteria.

Stop and return the slice for refinement when implementation would require:

- broad repository discovery;
- material interpretation of the approved design;
- invention of warning-versus-blocker behavior;
- invention of lifecycle or policy rules;
- choosing among materially different architectures;
- guessing the intended integration point, expected files, or test matrix.

Minor local coding choices do not require slice refinement when they preserve the approved outcome, existing architecture, explicit decision rules, and validation expectations.

When the slice fails this gate:

1. do not change status to `In progress`;
2. do not edit implementation files;
3. identify the missing execution detail precisely;
4. return to `prepare-slice` for refinement and renewed human approval if the approved slice changes.

## Procedure

1. Follow the implementation plan sequentially.
2. For corrective implementation, limit changes to the supported validation failure or review finding.
3. Inspect existing behavior before modifying it.
4. Prefer the smallest local change that satisfies the approved outcome.
5. Preserve established boundaries and dependency direction.
6. Add or update meaningful tests required by the slice and testing standards.
7. Implement the slice's declared decision branches and failure behavior without silently replacing them with new policy.
8. Run focused development checks as needed while implementing.
9. Record meaningful execution-only refinements under implementation adjustments.
10. Continue without reapproval only when the refinement does not change:
    - required outcome;
    - scope;
    - non-goals;
    - acceptance criteria;
    - architecture or durable decisions;
    - governing decision rules;
    - validation expectations.
11. When newly discovered work is outside scope:
    - do not implement it;
    - record it as a follow-up candidate;
    - create a separate Issue only through an explicit `create-work-item` handoff.
12. When implementation is complete:
    - review the diff for unintended changes;
    - list files changed;
    - summarize implementation adjustments;
    - leave the slice `In progress`;
    - hand off to `validate-slice` for formal or repeated validation.

Formal validation, completion evidence, and the transition to `Ready for review` belong to `validate-slice`.

## Development checks

Development checks may be run to guide implementation, but they do not replace formal declared validation.

Do not claim:

- acceptance criteria have passed;
- formal validation is complete;
- the slice is ready for review;

until `validate-slice` has completed successfully.

## Failure and escalation behavior

Stop when:

- a material document conflict appears;
- the required outcome must change;
- scope, non-goals, or acceptance criteria must change;
- required work exceeds the slice;
- a required dependency or decision is missing;
- an unrelated validation failure prevents trustworthy implementation;
- the implementation plan is no longer viable without broad reinterpretation;
- a material decision rule, integration point, or test expectation is absent from the approved slice;
- implementation would require inventing product, architecture, design, lifecycle, warning, blocker, or policy behavior.

Set the slice to `Blocked` only when implementation has legitimately begun and cannot continue because of a newly discovered dependency, conflict, or decision.

Do not use `Blocked` to compensate for a slice that was never implementation-ready. Return an insufficient slice to `prepare-slice` before changing implementation state.

When blocking active implementation, record:

- the blocker;
- evidence;
- affected step;
- required resolution.

When a material outcome change is required:

1. stop implementation;
2. update the Issue only through an authorized work-item operation;
3. revise the slice;
4. return it to `Draft`;
5. obtain human approval again.

## Required outputs

Provide:

- implementation within expected files;
- meaningful tests or documentation checks where required;
- files changed;
- focused development-check results;
- implementation adjustments;
- blockers or known limitations;
- a concise implementation summary;
- readiness for formal validation.

## Completion conditions

This skill is complete when:

- all authorized in-scope implementation or corrective steps are complete;
- the diff remains bounded;
- required tests were added or updated;
- declared decision branches and failure behavior were implemented;
- meaningful adjustments are recorded;
- the slice remains `In progress`;
- formal validation is the next operation;
- no Issue was closed or automatically selected.
