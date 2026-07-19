# Validate Slice

## Purpose

Execute the slice's formal validation plan, evaluate its acceptance criteria, assemble completion evidence, and determine whether the implementation is ready for review.

Validation establishes mechanical and observable evidence. It is not human approval.

## When to use

Use this skill when:

- implementation of the active slice is complete;
- the slice is `In progress`;
- formal validation has been requested;
- declared commands and manual checks are ready to run.

It may also be used to rerun validation after explicitly authorized corrective implementation.

## Do not use when

Do not use this skill to:

- implement missing functionality;
- repair failures automatically;
- weaken tests;
- rewrite acceptance criteria;
- approve the result;
- close the Issue;
- validate a `Draft` or unapproved slice as completed work.

## Authority and boundaries

Read and obey `AGENTS.md` before using this skill.

The validation plan in the slice is primary for slice-specific checks. `docs/testing.md` supplies project-wide standards and does not replace the declared checks.

Do not:

- hide failed commands;
- omit exit codes;
- convert failed checks into warnings without authority;
- edit implementation while acting in validation mode;
- treat test passage as review or approval;
- set the slice to `Complete`.

Corrective implementation requires a separate explicit handoff to `implement-slice`.

## Required inputs

- implemented `docs/current-slice.md`;
- source acceptance criteria;
- declared validation plan;
- implementation diff or changed-file list.

## Required context

Load:

1. validation commands and acceptance criteria from `docs/current-slice.md`;
2. `docs/testing.md`;
3. relevant test configuration;
4. changed code and tests needed to understand the results.

Load other sources only when a validation result reveals a material authority or scope conflict.

## Preflight

Before running commands:

1. Verify the slice status is `In progress`.
2. Verify implementation is declared complete enough for formal validation.
3. Verify every acceptance criterion has an associated evidence method.
4. Verify declared commands are concrete and safe to run.
5. Identify required manual checks.
6. Identify project-wide checks that supplement the slice plan.
7. Stop if the validation plan is materially incomplete.

## Procedure

1. Run the most specific declared validation commands first.
2. Record for every command:
   - exact command;
   - exit code;
   - concise result;
   - relevant failure output.
3. Run broader project checks required by the slice or `docs/testing.md`.
4. Perform declared manual checks.
5. Record the method and result of each manual check.
6. Evaluate every acceptance criterion individually as:
   - passed;
   - failed;
   - not evaluated.
7. Compare changed files and behavior with the approved scope.
8. Identify:
   - known limitations;
   - deviations;
   - unrelated failures;
   - evidence gaps.
9. Update completion evidence with:
   - acceptance-criteria status;
   - files changed;
   - commands and results;
   - manual checks;
   - implementation adjustments;
   - blockers or known limitations;
   - follow-up Issue references or candidates;
   - implementation summary.
10. When all declared validation passes and every acceptance criterion is supported:
    - set the slice status to `Ready for review`;
    - stop for review and human approval.
11. When any required validation fails:
    - leave the slice `In progress`, unless an external dependency or unresolved decision makes it `Blocked`;
    - report the failure;
    - do not repair it in validation mode.

## Validation result rules

A validation pass requires:

- all required commands to complete successfully;
- all required manual checks to pass;
- every acceptance criterion to have sufficient evidence;
- no unexplained scope deviation;
- no hidden or ignored failure;
- completion evidence to be complete.

Passing a subset of checks is not a declared validation pass.

Passing mechanical checks does not prove that the implementation is acceptable in review.

## Required outputs

Provide:

- exact validation commands;
- exit codes;
- result summaries;
- manual-check results;
- acceptance-criteria status;
- validation gaps;
- known limitations;
- completed completion evidence;
- resulting slice status.

## Failure and escalation behavior

Stop and report when:

- a declared command fails;
- required evidence cannot be collected;
- implementation does not match the slice;
- acceptance criteria cannot be evaluated;
- validation reveals a material scope or authority conflict;
- the validation plan itself is insufficient.

Do not silently add corrective code.

A failed result requiring code changes must return through an explicit `implement-slice` handoff.

## Completion conditions

This skill succeeds when:

- all formal validation passes;
- completion evidence is complete;
- every acceptance criterion is supported;
- the slice is `Ready for review`;
- no approval or Issue closure has been claimed.

This skill completes with failure when:

- failures are accurately recorded;
- the slice remains `In progress` or becomes appropriately `Blocked`;
- the next required decision or corrective action is explicit.
