# Approve Slice

## Purpose

Record explicit human approval of one complete `Draft` `docs/current-slice.md` and change its status to `Approved`.

This operation records a human decision. It does not infer approval, authorize implementation, edit code, or begin another operation.

## When to use

Use when the active slice is `Draft`, the human explicitly approves that exact version, and the request authorizes recording approval.

## Do not use when

Do not use when approval is implied, applies to another artifact or earlier version, the slice is incomplete, blockers or conflicts remain, implementation has begun, or status is not `Draft`.

## Authority and boundaries

Read and obey `AGENTS.md`.

Only the human can approve. This skill may verify and record approval and change `Draft` to `Approved`.

It must not modify implementation, change the Issue outcome, resolve blockers by assumption, change GitHub state, claim implementation authorization, begin implementation, approve the completed result, or select another Issue.

## Required inputs

- explicit human approval;
- current slice with status `Draft`;
- source Issue traceability;
- the approval basis.

## Required context

Load `AGENTS.md`, this skill, the current slice, the source Issue sufficiently for traceability, and additional governing sources only when a conflict must be checked.

## Preflight

Verify:

1. approval is explicit and applies to the current Draft;
2. Issue traceability matches;
3. all required sections exist;
4. no scaffold placeholder remains;
5. governing-rule reconciliation has no unresolved material difference;
6. no failure condition or blocker prevents approval;
7. the executability gate is satisfied;
8. documentation impact is declared;
9. approval evidence is pending;
10. no implementation began.

If any check fails, do not approve.

## Procedure

1. Preserve all approved content.
2. In `## Approval evidence`, set `Slice approval` to `Approved`.
3. Record approving human or `Repository owner`, approval basis, and date/time when available.
4. Change status from `Draft` to `Approved`.
5. Verify no other lifecycle or completion field changed.
6. Report that implementation still requires separate authorization.
7. Stop.

## Validation

Verify status is `Approved`, slice-approval evidence is complete, final approval remains pending, approved content is unchanged, no implementation file changed, and no GitHub state changed.

## Required outputs

Provide Issue identity, resulting status, approval basis, and confirmation that implementation has not begun or been authorized by this operation.

## Failure and escalation behavior

Stop without changes when approval is missing or ambiguous, the Draft changed after approval, the slice is incomplete, a blocker remains, implementation began, or status is ineligible.

## Completion conditions

Complete when explicit approval is verified and recorded, status is `Approved`, no implementation or external side effect occurred, and implementation remains a separate possible operation.

