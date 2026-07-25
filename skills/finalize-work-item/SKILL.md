# Finalize Work Item

## Purpose

Perform the final human-authorized transition for one reviewed work item.

Finalization records final approval, closes the source Issue, and changes `Ready for review` to `Complete`. It does not select or begin another Issue.

## When to use

Use only when a human explicitly approves the current completed result, status is `Ready for review`, validation and review are complete, documentation impact is resolved, and no blocking finding remains.

## Do not use when

Do not use when approval is implied or applies only to planning/start, status is ineligible, validation failed, documentation is stale, blocking findings remain, Issue and slice conflict, or the request is to start the next item.

## Authority and boundaries

Read and obey `AGENTS.md`.

Only explicit human approval authorizes finalization.

This skill may record final approval, close the Issue, set `Complete`, and record closure evidence.

It must not modify implementation, waive failures, dismiss findings without authority, alter outcome, leave required authority stale, reset the slice, or begin another Issue.

## Required inputs

- explicit final approval;
- current slice at `Ready for review`;
- source Issue;
- validation evidence;
- review result.

## Required context

Load the current slice, Issue, final validation, review result, and documentation-impact evidence. Load more only for a conflict.

## Preflight

1. Confirm approval is explicit and applies to the current result.
2. Confirm Issue traceability.
3. Confirm status `Ready for review`.
4. Confirm slice-approval and completion evidence.
5. Confirm validation passed.
6. Confirm documentation impact is resolved.
7. Confirm review is complete with no blocking finding.
8. Confirm actual Issue state.

If any check fails, do not finalize.

## Procedure

1. In approval evidence, set final approval to `Approved` and record approver, basis, and date/time.
2. Close the Issue.
3. Verify closure.
4. Record Issue closure in completion evidence.
5. Set status `Complete`.
6. Verify validation, review, documentation, approval, closure, and work-item identity are consistent.
7. Report final state and stop.

Do not clear the slice, promote another Issue, or begin new work.

## Consistency and partial failure

Report completion only when the Issue is closed and status is `Complete`.

If one transition succeeds and the other fails, report partial state, do not claim completion, and restore consistency when authorized. Never hide partial lifecycle state.

## Required outputs

Provide Issue closure, final status, explicit approval basis, documentation-currency confirmation, partial-failure warning if any, and confirmation no next work started.

## Failure and escalation behavior

Stop without changes when approval, evidence, validation, documentation, findings, traceability, or lifecycle eligibility is inadequate.

## Completion conditions

Complete when final approval is recorded, documentation impact is resolved, the Issue is closed, status is `Complete`, state is consistent, and no new work item started.
