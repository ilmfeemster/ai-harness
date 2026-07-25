# Validate Slice

## Purpose

Execute the slice's formal validation plan, evaluate acceptance criteria, verify documentation impact, assemble completion evidence, and determine readiness for review.

Validation establishes mechanical and observable evidence. It is not approval.

## When to use

Use when implementation is complete enough, status is `In progress`, formal validation is requested, and declared commands and manual checks are ready. It may rerun after authorized correction.

## Do not use when

Do not implement or repair, weaken tests, rewrite criteria, approve, close the Issue, or validate a Draft/unapproved slice as completed work.

## Authority and boundaries

Read and obey `AGENTS.md`.

The slice owns exact checks; `docs/testing.md` supplies project-wide standards.

Do not hide failures, omit exit codes, downgrade failures without authority, edit implementation, treat passage as approval, or set `Complete`.

## Required inputs

- implemented current slice;
- source acceptance criteria;
- declared validation plan;
- changed-file list or diff;
- declared documentation impact.

## Required context

Load validation commands and criteria, testing standards, relevant test configuration, changed code/tests/documents, and governing sources named in documentation impact or rule reconciliation.

## Preflight

1. Verify status `In progress`.
2. Verify slice approval evidence.
3. Verify implementation is ready for formal validation.
4. Verify each criterion has an evidence method.
5. Verify commands are concrete and safe.
6. Identify manual and project-wide checks.
7. Identify required document updates and evidence.
8. Stop if validation or documentation-impact plans are incomplete.

## Procedure

1. Run specific declared commands first.
2. Record exact command, exit code, concise result, and relevant failure output.
3. Run broader required checks.
4. Perform and record manual checks.
5. Evaluate every acceptance criterion as `passed`, `failed`, or `not evaluated`.
6. Compare changed files and behavior with scope.
7. Verify each required document update exists and accurately describes current behavior.
8. Confirm items marked `None` did not become stale due to the actual diff.
9. Identify limitations, deviations, unrelated failures, evidence gaps, and documentation gaps.
10. Update completion evidence.
11. When commands, manual checks, criteria, scope, and documentation impact all pass, set `Ready for review` and stop.
12. On failure, leave `In progress` unless a genuine blocker applies, report it, and do not repair.

## Validation result rules

A pass requires all required commands and manual checks, sufficient evidence for every criterion, resolved documentation impact, no knowingly stale governing source, no unexplained deviation, no hidden failure, and complete evidence.

Passing a subset is not a pass. Mechanical passage does not prove review acceptability.

## Required outputs

Provide commands, exit codes, results, manual checks, acceptance status, documentation-impact status, gaps, limitations, completed evidence, and resulting status.

## Failure and escalation behavior

Stop and report command failures, missing evidence, slice mismatch, unevaluable criteria, stale required documentation, authority conflicts, or an insufficient validation plan. Corrective code requires a separate implementation handoff.

## Completion conditions

Success requires passing validation, resolved documentation impact, complete evidence, supported criteria, status `Ready for review`, and no approval or closure claim. Failure completion requires accurate evidence and an explicit next action.
