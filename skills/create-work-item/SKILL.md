# Create Work Item

## Purpose

Convert one singular, bounded, sufficiently decided outcome into one reviewable GitHub Issue.

The Issue defines the required outcome. It does not contain the full file-level execution package.

## When to use

Use this skill when asked to:

- draft a feature Issue;
- draft a bug Issue;
- create an Issue for a refactor, documentation change, infrastructure change, or other planned work;
- convert approved planning or design into a bounded work item;
- assess whether a proposed Issue is Ready.

## Do not use when

Do not use this skill to:

- create several Issues without an explicit approved breakdown;
- promote an Issue into `docs/current-slice.md`;
- implement the Issue;
- use an Issue as a substitute for unresolved design;
- mark an Issue Ready by assumption.

## Authority and boundaries

Read and obey `AGENTS.md` before using this skill.

GitHub Issues are the authoritative work queue, but they may not silently override:

- current project scope;
- architecture;
- durable decisions;
- approved designs;
- testing standards.

This skill may draft Issue content without side effects.

Create or edit an actual GitHub Issue only when the user explicitly authorizes that repository change.

Do not create a current slice or begin implementation.

## Required inputs

Require:

- one expected outcome;
- context explaining why it matters;
- included scope;
- explicit non-goals;
- evaluable acceptance criteria;
- known dependencies;
- relevant project documents.

For bugs, also require enough information to distinguish expected behavior from observed incorrect behavior.

## Required context

Load:

- `docs/project.md`;
- the relevant approved design, when one exists;
- relevant portions of `docs/architecture.md`;
- relevant entries in `docs/decisions.md`;
- relevant constraints from `docs/testing.md`.

Inspect relevant code or tests only when needed to:

- confirm current behavior;
- bound the work;
- make acceptance criteria evaluable;
- identify a real dependency.

## Procedure

1. Identify whether the work is:
   - a bug;
   - a feature;
   - a refactor;
   - documentation;
   - infrastructure;
   - another bounded implementation outcome.
2. State the outcome in singular terms.
3. Split the proposal before creating the Issue when it contains independently valuable or independently reviewable outcomes.
4. Confirm compatibility with project scope, architecture, decisions, and approved design.
5. Complete the Issue contract:
   - goal or expected outcome;
   - context;
   - included scope;
   - explicit non-goals;
   - acceptance criteria;
   - dependencies;
   - relevant project documents;
   - readiness confirmation.
6. Make acceptance criteria observable and evaluable without prescribing unnecessary file-level implementation detail.
7. Identify dependencies as:
   - satisfied;
   - explicitly handled by the future slice;
   - unresolved.
8. Check each readiness requirement individually.
9. Mark readiness items complete only when supported by evidence.
10. If any readiness requirement is unresolved:
    - keep the Issue conceptually `Draft`;
    - identify what is missing;
    - do not promote it.
11. If all requirements are satisfied:
    - identify the Issue as `Ready`;
    - draft or create exactly one Issue.
12. Stop before slice preparation unless a separate explicit handoff invokes `prepare-slice`.

## Readiness validation

An Issue is Ready only when:

- the outcome is singular and bounded;
- scope and non-goals are explicit;
- acceptance criteria are evaluable;
- dependencies are satisfied or can be explicitly handled within the slice;
- relevant documents are linked;
- no unresolved product or architecture decision blocks execution;
- the work fits one independently reviewable slice;
- every readiness confirmation is checked.

Labels such as `bug`, `enhancement`, or `documentation` may classify the work but do not establish readiness.

## Required outputs

Provide:

- Issue type;
- title;
- complete Issue body using the repository form;
- explicit readiness state;
- unresolved dependencies or decisions;
- relevant document links;
- confirmation that no slice or implementation was started.

When an actual Issue is created, also provide its number and URL.

## Failure and escalation behavior

Do not create a Ready Issue when:

- the outcome combines multiple work items;
- acceptance cannot be evaluated;
- scope or non-goals are missing;
- dependencies are unknown or unsatisfied;
- required design or architecture decisions remain unresolved;
- relevant project documents are missing or cannot be linked;
- the work cannot fit one reviewable slice.

Return a Draft Issue or a readiness-gap report instead of filling gaps through assumption.

## Completion conditions

This skill is complete when:

- one complete Issue has been drafted or explicitly created;
- its readiness state is accurate;
- relevant authority and dependencies are traceable;
- no current slice or implementation was created.
