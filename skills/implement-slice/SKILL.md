# Implement Slice

## Purpose

Implement exactly one human-approved `docs/current-slice.md` within approved boundaries.

This skill owns entry into `In progress` for new, resumed, or corrective implementation. It produces work ready for formal validation. It does not approve, close the Issue, or begin another work item.

## When to use

Use only for an explicitly authorized transition:

- `Approved` → `In progress`;
- `Blocked` → `In progress` after resolution;
- `Ready for review` → `In progress` for authorized correction.

## Do not use when

Do not use when the slice is `Draft` or `Complete`, approval evidence or implementation authorization is ambiguous, a blocker remains, correction changes the outcome, scope is exceeded, upstream context is missing, the request is only validation/review, or the slice requires broad reinterpretation.

## Authority and boundaries

Read and obey `AGENTS.md`.

The approved slice remains subordinate by concern to the Issue, project scope, architecture, decisions, approved design, and testing standards.

Do not expand scope, change outcome, weaken criteria or tests, hardcode results, add unrelated cleanup, rename unrelated APIs, change dependencies without need, create another Issue, close the Issue, advance to `Ready for review` or `Complete`, or invent omitted product, architecture, design, lifecycle, interface, warning, blocker, or policy rules.

## Lifecycle ownership

This skill may perform only the three eligible transitions above. Material outcome changes return the slice to `Draft` and require approval again.

Successful implementation leaves status `In progress`. Validation owns `Ready for review`.

## Required inputs

- current slice;
- explicit implementation or correction authorization;
- blocker-resolution evidence for resumed work;
- validation failure or review finding for correction.

## Required context

Load the current slice, source Issue for traceability, referenced documents, named or clearly required code/tests/fixtures/configuration/documents, and the relevant blocker or finding.

Expand context only for a real dependency, existing behavior, changed file, documentation impact, or contradiction.

## Preflight

1. Classify new, resumed, or corrective implementation.
2. Verify eligible status.
3. Verify separate explicit implementation authorization.
4. Verify slice-approval evidence.
5. Verify blocker resolution or correction scope.
6. Verify Issue traceability.
7. Verify expected files and plan remain plausible.
8. Verify governing sources remain present and consistent.
9. Verify governing-rule reconciliation has no unresolved difference.
10. Verify approved boundaries.
11. Verify implementation readiness.
12. Change status to `In progress` only when editing begins.

If any check fails, do not edit implementation.

## Implementation-readiness gate

The slice must identify:

- existing seam or integration point;
- file/component responsibilities;
- governing branches and sources;
- inputs, outputs, ordering, side effects, and failures;
- fixtures and tests;
- acceptance coverage;
- documentation impact.

Return the slice for refinement when implementation requires broad discovery, material design interpretation, policy or interface invention, architecture choice, intended-file guessing, deterministic-output guessing, test-matrix invention, or deciding whether authority documents must change.

## Procedure

1. Follow the plan sequentially.
2. Limit corrective work to supported findings.
3. Inspect existing behavior before modification.
4. Prefer the smallest local change satisfying the outcome.
5. Preserve boundaries and dependency direction.
6. Implement declared interfaces, rules, and failures.
7. Add or update meaningful tests.
8. Perform every documentation update marked `Update required in this slice`.
9. Run focused development checks.
10. Record meaningful execution-only refinements.
11. Continue without reapproval only when outcome, scope, architecture, decisions, rules, interfaces, validation, and documentation impact remain unchanged.
12. Record out-of-scope discoveries as follow-up candidates.
13. Review the diff, list files, summarize adjustments and documentation updates, leave status `In progress`, and hand off to validation.

Development checks do not replace formal validation.

## Failure and escalation behavior

Stop when authority conflicts, approved outcome must change, work exceeds scope, dependencies or decisions are missing, unrelated failures prevent trust, the plan becomes nonviable, a material rule/interface/test/document update is absent, or policy invention is required.

Use `Blocked` only after legitimate implementation begins and a newly discovered blocker prevents continuation. Record blocker, evidence, affected step, and required resolution.

## Required outputs

Provide bounded implementation, required tests and documentation updates, files changed, focused check results, adjustments, blockers or limitations, implementation summary, and readiness for formal validation.

## Completion conditions

Complete when authorized in-scope work is done, the diff is bounded, required tests and documents are updated, declared behavior is implemented, status remains `In progress`, validation is next, and no Issue was closed or selected.
