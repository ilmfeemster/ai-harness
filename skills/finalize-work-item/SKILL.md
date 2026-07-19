# Finalize Work Item

## Purpose

Perform the final human-authorized lifecycle transition for one reviewed work item.

Finalization closes the source Issue and changes the active slice from `Ready for review` to `Complete`.

It does not select, promote, or begin another Issue.

## When to use

Use this skill only when:

- a human explicitly approves the completed result;
- the approval clearly applies to the active Issue and slice;
- the slice is `Ready for review`;
- formal validation is complete;
- review is complete;
- no unresolved blocking finding remains.

## Do not use when

Do not use this skill when:

- approval is implied rather than explicit;
- the user has approved only the plan, slice, or implementation start;
- the slice is not `Ready for review`;
- required validation failed;
- blocking review findings remain unresolved;
- the source Issue is already inconsistent with the slice;
- the request is to start the next work item.

## Authority and boundaries

Read and obey `AGENTS.md` before using this skill.

Only explicit human approval authorizes finalization.

This skill may:

- close the source Issue;
- set the slice status to `Complete`;
- record final approval evidence when the slice schema provides a place for it.

This skill must not:

- modify implementation;
- waive validation failures;
- dismiss unresolved findings without authority;
- alter the completed outcome;
- reset the current slice automatically;
- choose or begin another Issue.

## Required inputs

- explicit human approval;
- `docs/current-slice.md` with status `Ready for review`;
- source Issue;
- validation evidence;
- review result.

## Required context

Load:

1. current slice;
2. source Issue;
3. final validation status;
4. review findings or approval-readiness statement.

Additional project documents are unnecessary unless a conflict appears.

## Preflight

Before changing state:

1. Confirm approval is explicit.
2. Confirm the approval applies to the current result.
3. Confirm the source Issue matches the slice.
4. Confirm the slice status is `Ready for review`.
5. Confirm completion evidence is complete.
6. Confirm required validation passed.
7. Confirm no unresolved blocking review finding remains.
8. Confirm the Issue is still open or determine its actual state.

If any check fails, do not finalize.

## Procedure

1. Record the human approval when the slice's completion-evidence format supports it.
2. Close the source Issue.
3. Verify the Issue is closed.
4. Set the slice status to `Complete`.
5. Verify the slice records the completed state accurately.
6. Report:
   - Issue closure;
   - slice status;
   - approval basis;
   - any final known limitation.
7. Stop.

Do not clear `docs/current-slice.md`, promote another Issue, or begin new work.

## Consistency and partial failure

Completion should be reported only when:

- the source Issue is closed;
- the slice is `Complete`;
- both refer to the same work item.

If Issue closure succeeds but the slice update fails:

- report the partial transition;
- do not claim the workflow is complete;
- restore the slice state as soon as authorized and possible.

If the slice update succeeds but Issue closure fails:

- report the inconsistency;
- do not claim completion;
- return the slice to `Ready for review` when possible until closure succeeds.

Never hide partial lifecycle state.

## Required outputs

Provide:

- source Issue number and closure status;
- final slice status;
- confirmation of explicit human approval;
- any partial-failure or consistency warning;
- confirmation that no next Issue was selected or started.

## Failure and escalation behavior

Stop without changing state when:

- approval is missing or ambiguous;
- required evidence is incomplete;
- validation failed;
- blocking findings remain;
- Issue and slice traceability conflict;
- lifecycle state is not eligible for completion.

Report exactly what prevents finalization.

## Completion conditions

This skill is complete when:

- explicit human approval has been verified;
- the source Issue is closed;
- the slice status is `Complete`;
- lifecycle state is consistent;
- no new work item has been selected or started.
