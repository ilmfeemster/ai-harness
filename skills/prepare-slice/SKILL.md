# Prepare Slice

## Purpose

Translate one Ready GitHub Issue into one complete, bounded, reviewable, implementation-ready `docs/current-slice.md` execution package.

Promotion adds implementation specificity. It does not change the approved outcome.

The prepared slice must absorb the material planning and repository-interpretation work needed so that implementation can proceed without broad reinterpretation.

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
- mark the Issue Active before the slice is approved;
- delegate unresolved product, architecture, design, lifecycle, or policy interpretation to the implementation agent.

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

When the Issue modifies existing behavior, inspecting the relevant implementation, tests, fixtures, and configuration is mandatory. Do not prepare an implementation plan solely from the Issue and design when an existing implementation seam is available.

Inspect enough existing code to identify:

- the current entry point or integration seam;
- the files and responsibilities already present;
- existing data structures, command interfaces, and output behavior;
- the nearest tests and fixture conventions;
- constraints that affect how the change must be implemented.

Inspect the existing `docs/current-slice.md` before replacing or repurposing it.

Expand beyond this bounded context only when required to make the plan accurate, resolve a material contradiction, or understand a real dependency.

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
7. Identify the existing implementation seam by inspecting the relevant code, tests, fixtures, and configuration.
8. Translate the approved outcome into a decision-complete implementation plan. Resolve every material execution choice supported by the governing documents and existing repository structure.
9. Include, when applicable:
   - the existing integration point;
   - ordered file-level changes;
   - proposed component, function, script, or module responsibilities;
   - relevant input and output contracts;
   - deterministic decision rules;
   - warning, blocker, and error-handling behavior;
   - persistence, overwrite, idempotency, or side-effect rules;
   - fixtures and assertions for every material behavior branch;
   - acceptance-criterion-to-validation mapping;
   - explicitly marked assumptions;
   - unresolved questions that require human judgment.
10. Do not merely restate the Issue or approved design as implementation steps. Convert governing requirements into executable repository changes.
11. When a material implementation decision cannot be resolved from authority and existing behavior:
    - do not invent it;
    - record the decision as a blocker;
    - return to the relevant planning or work-item operation when needed.
12. Include all required slice sections, even when later-stage evidence is marked pending.
13. Include optional sections when they add operational value, especially an existing implementation seam, decision table, file-by-file plan, or acceptance mapping.
14. Check that expected files and steps do not include unrelated cleanup.
15. Check that the validation plan is sufficient to evaluate every acceptance criterion and material decision branch.
16. Set status to `Draft`.
17. Present or write the complete slice when authorized.
18. Stop for human approval.

## Implementation-plan requirements

The implementation plan must be specific enough that an implementation agent can work primarily by following the slice and inspecting only the files named or clearly required by it.

For each material step, specify as applicable:

- where the change belongs;
- what existing behavior or structure it extends;
- what responsibility is added or changed;
- what inputs it consumes;
- what outputs or side effects it produces;
- what decision branches it must implement;
- how failures are surfaced;
- which tests demonstrate the step is correct.

Use function or component names when they are already established or when naming a proposed responsibility materially reduces ambiguity. Proposed names are instructions, not new architecture, unless the governing design requires them.

Do not require the implementation agent to rediscover:

- the governing design algorithm;
- warning-versus-blocker classification;
- lifecycle ownership;
- repository boundaries;
- acceptance coverage;
- the intended integration seam;
- fixture scenarios already knowable during preparation.

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

Add when useful:

- dependencies and assumptions;
- relevant project documents;
- linked design documents;
- implementation constraints;
- existing implementation seam;
- component or responsibility map;
- deterministic decision table;
- file-by-file change plan;
- acceptance-criterion mapping;
- implementation adjustments;
- blockers and known limitations;
- rollback or migration notes.

Do not duplicate large portions of upstream documents. Summarize or translate the governing rule and cite its source path.

## Validation

Before presenting the slice, verify that:

- the Issue remains unchanged in meaning;
- every acceptance criterion is represented;
- every implementation step belongs to the Issue scope;
- expected files are accurate, plausible, and bounded;
- validation commands are concrete;
- failure conditions explain when work must stop;
- review checks include scope, architecture, testing, and unsupported shortcuts;
- no unresolved scaffold placeholder remains except explicitly pending lifecycle evidence;
- status is `Draft`.

### Executability gate

The slice is incomplete unless an implementation agent can:

- identify the existing integration point;
- identify where each material step belongs;
- implement each decision branch without inventing policy;
- determine expected inputs, outputs, side effects, and failure behavior;
- create the required tests without designing the test matrix from scratch;
- map the implementation and validation back to every acceptance criterion;
- determine when in-scope implementation is complete.

Fail this gate when implementation would still require:

- broad repository discovery;
- material design interpretation;
- invention of warning, blocker, lifecycle, or policy rules;
- choosing among materially different architectures;
- guessing which files or test scenarios are intended;
- filling a known semantic gap during implementation.

Minor local coding choices may remain open when they do not affect the approved outcome, architecture, decision rules, validation behavior, or reviewability.

## Required outputs

Provide:

- complete `docs/current-slice.md`;
- source Issue traceability;
- readiness verification result;
- the existing implementation seam inspected;
- any assumptions used to add execution detail;
- any unresolved decision classified as a blocker;
- an explicit statement that implementation is not yet authorized.

## Failure and escalation behavior

Stop when:

- the Issue is not Ready;
- the Issue outcome is not singular;
- an unresolved dependency or authority conflict exists;
- the work cannot fit one slice;
- another current slice is unresolved;
- the slice would have to change the Issue instead of refining execution;
- validation cannot be specified meaningfully;
- the existing implementation cannot be inspected sufficiently to produce an accurate plan;
- a material execution decision would have to be invented;
- the resulting plan would still require broad reinterpretation.

When the Issue requires a material correction, return to `create-work-item` or the relevant planning operation. Do not repair the Issue silently inside the slice.

## Completion conditions

This skill is complete when:

- one complete slice exists with status `Draft`;
- it is traceable to one Ready Issue;
- it identifies the existing implementation seam when modifying existing behavior;
- it is executable without broad reinterpretation;
- no material implementation choice is left unresolved merely because it could be discovered during implementation;
- its test and validation expectations cover the acceptance criteria and material behavior branches;
- it awaits explicit human approval;
- no implementation has begun.
