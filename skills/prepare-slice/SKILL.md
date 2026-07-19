# Prepare Slice

## Purpose

Translate one Ready GitHub Issue into one complete, bounded, reviewable `docs/current-slice.md` execution package.

Promotion adds implementation specificity. It does not change the approved outcome.

## When to use

Use this skill when asked to:

- promote a Ready Issue;
- prepare the next current slice;
- translate an Issue into file-level implementation steps;
- draft `docs/current-slice.md` for human approval.

## Do not use when

Do not use this skill when:

- the source Issue is not Ready;
- another unresolved slice already occupies `docs/current-slice.md`;
- the work requires changing the Issue outcome before it can be executed;
- implementation has already been authorized and the request is to edit code;
- the request merely asks to create an Issue.

## Authority and boundaries

Read and obey `AGENTS.md` before using this skill.

The source Issue governs the required outcome. The slice may specify how to produce that outcome but may not silently change:

- goal;
- scope;
- non-goals;
- acceptance criteria;
- project scope;
- architecture;
- durable decisions;
- approved design;
- project-wide testing standards.

Promotion creates a `Draft` slice. Only explicit human approval may change it to `Approved`.

Do not:

- modify implementation code;
- modify unrelated project documents;
- create a second slice;
- begin implementation;
- close the Issue;
- mark the Issue Active before the slice is approved.

## Required inputs

- one Ready GitHub Issue;
- its number, title, and URL;
- its approved goal, scope, non-goals, and acceptance criteria.

## Required context

Load:

1. the source Issue;
2. its linked approved design, when one exists;
3. `docs/project.md`;
4. relevant portions of `docs/architecture.md`;
5. relevant entries in `docs/decisions.md`;
6. relevant rules from `docs/testing.md`.

Inspect nearby code, tests, and configuration only when needed to make the implementation plan executable and accurate.

Inspect the existing `docs/current-slice.md` before replacing or repurposing it.

## Procedure

1. Verify the Issue satisfies every readiness requirement.
2. Inspect the existing current slice.
3. Stop when it contains another unresolved work item in any of these states:
   - `Draft`;
   - `Approved`;
   - `In progress`;
   - `Blocked`;
   - `Ready for review`.
4. Confirm that the Issue fits one independently reviewable slice.
5. Copy the source traceability:
   - Issue number;
   - Issue title;
   - Issue URL.
6. Preserve the Issue's:
   - context;
   - goal;
   - scope;
   - non-goals;
   - acceptance criteria.
7. Add only the execution detail needed to make the work bounded:
   - ordered implementation steps;
   - expected files;
   - relevant constraints;
   - validation commands;
   - manual checks;
   - failure conditions;
   - review checks.
8. Include all required slice sections, even when later-stage evidence is marked pending.
9. Include optional sections only when they add operational value.
10. Check that expected files and steps do not include unrelated cleanup.
11. Check that the validation plan is sufficient to evaluate the acceptance criteria.
12. Set status to `Draft`.
13. Present or write the complete slice when authorized.
14. Stop for human approval.

## Required slice sections

The prepared slice must contain:

- work-item title;
- status;
- source Issue number, title, and URL;
- context;
- goal;
- scope;
- non-goals;
- acceptance criteria;
- implementation plan;
- expected files;
- validation plan;
- failure conditions;
- review checklist;
- completion evidence.

Before implementation, completion evidence may state that evidence is pending.

## Optional sections

Add only when useful:

- dependencies and assumptions;
- relevant project documents;
- linked design documents;
- implementation constraints;
- implementation adjustments;
- blockers and known limitations;
- rollback or migration notes.

Do not duplicate large portions of upstream documents.

## Validation

Before presenting the slice, verify that:

- the Issue remains unchanged in meaning;
- every acceptance criterion is represented;
- every implementation step belongs to the Issue scope;
- expected files are plausible and bounded;
- validation commands are concrete;
- failure conditions explain when work must stop;
- review checks include scope, architecture, testing, and unsupported shortcuts;
- no unresolved scaffold placeholder remains except explicitly pending lifecycle evidence;
- status is `Draft`.

## Required outputs

Provide:

- complete `docs/current-slice.md`;
- source Issue traceability;
- readiness verification result;
- any assumptions used to add execution detail;
- an explicit statement that implementation is not yet authorized.

## Failure and escalation behavior

Stop when:

- the Issue is not Ready;
- the Issue outcome is not singular;
- an unresolved dependency or authority conflict exists;
- the work cannot fit one slice;
- another current slice is unresolved;
- the slice would have to change the Issue instead of refining execution;
- validation cannot be specified meaningfully.

When the Issue requires a material correction, return to `create-work-item` or the relevant planning operation. Do not repair the Issue silently inside the slice.

## Completion conditions

This skill is complete when:

- one complete slice exists with status `Draft`;
- it is traceable to one Ready Issue;
- it is executable without broad reinterpretation;
- it awaits explicit human approval;
- no implementation has begun.
