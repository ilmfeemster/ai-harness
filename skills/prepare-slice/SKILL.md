# Prepare Slice

## Purpose

Translate one Ready GitHub Issue into one complete, bounded, reviewable, implementation-ready `docs/current-slice.md`.

Promotion adds implementation specificity. It does not change the approved outcome.

## When to use

Use to promote one Ready Issue, prepare the next slice, translate it into file-level steps, or draft the current slice for approval.

## Do not use when

Do not use when the Issue is not Ready, another unresolved slice exists, the outcome must change, implementation is already requested, or the request is only to create an Issue.

## Authority and boundaries

Read and obey `AGENTS.md`.

The Issue governs outcome. The slice may not silently change goal, scope, non-goals, acceptance criteria, project scope, architecture, decisions, approved design, or testing standards.

Preparation creates `Draft`. Only `approve-slice` may record approval.

Do not edit implementation, create a second slice, begin implementation, close the Issue, mark it Active before approval, or delegate unresolved product, architecture, design, lifecycle, or policy interpretation downstream.

## Required inputs

One Ready Issue with number, title, URL, goal, scope, non-goals, and acceptance criteria.

## Required context

Load the Issue, every selected approved design, `docs/project.md`, relevant architecture and decisions, and testing rules.

When existing behavior changes, inspect relevant code, tests, fixtures, and configuration. Identify the existing entry point, responsibilities, interfaces, outputs, test conventions, and implementation constraints.

Inspect the current slice before replacing it. Expand context only for plan accuracy, conflicts, documentation impact, or real dependencies.

## Governing-rule reconciliation

For every material deterministic rule:

1. identify governing source and concern;
2. state the slice interpretation;
3. identify any difference;
4. verify the interpretation does not narrow, broaden, or replace authority.

Use:

| Rule | Governing source | Slice interpretation | Difference |
| --- | --- | --- | --- |

Allowed differences are `None`, `Implementation refinement within authority`, or an unresolved conflict that blocks preparation.



## Automated-classification boundary

Preparation may introduce implementation policy needed to execute the approved outcome, but it must distinguish between:

- **implementation policy** (interfaces, ordering, parsing, data flow, error handling, deterministic behavior), which this skill should resolve; and
- **product or semantic policy** (what is relevant, applicable, equivalent, or authoritative), which must come from approved sources or remain explicit assumptions.

When introducing a material automated classification (for example applicability, relevance, compatibility, authority selection, or dependency satisfaction):

- identify the evidence used to make the classification;
- prefer explicit repository metadata or approved contracts when available;
- if evidence is insufficient, either record an explicit assumption, warning, or blocker rather than silently inventing a durable semantic rule.

This does **not** prohibit creating implementation policy. It only requires that new semantic policy be explicit and reviewable rather than hidden inside implementation details.

## Deterministic interface requirement

When work changes a parser, command, generated document, manifest, schema, persisted record, or serialized output, specify internal inputs, external invocation, accepted syntax, normalization, validation, ordering, duplicate handling, output schema, empty-state rendering, overwrite/idempotency, side effects, and sanitized failures.

Prefer the smallest stable external interface.

Do not introduce operator-facing parameters, configuration, extension points, or abstractions solely to support tests or hypothetical reuse. Keep fixed repository conventions fixed unless the Issue or governing design requires configurability.

When tests need isolation or substitution, prefer internal function parameters, dependency injection, fixtures, or temporary paths over expanding the public command interface.

## Documentation-impact assessment

For README, project, architecture, decisions, design, testing, and operator guidance, record `None`, `Update required in this slice`, or `Requires upstream Issue revision`.

## Procedure

1. Verify readiness.
2. Inspect the current slice and stop on any unresolved state.
3. Confirm one independently reviewable outcome.
4. Preserve source traceability and Issue sections.
5. Load and reconcile governing rules.
6. Identify the existing implementation seam.
7. Produce a decision-complete implementation plan.
8. Include applicable integration points, file changes, responsibilities, interfaces, decision and failure rules, side effects, fixtures, tests, acceptance mapping, assumptions, and blockers.
9. Define deterministic interfaces when applicable.
10. Assess documentation impact.
11. Do not restate design as broad steps; translate it into executable repository changes.
12. Block instead of inventing a material decision.
13. Include all required sections.
14. Check for unrelated cleanup and incomplete validation.
15. Set `Draft`, write or present the complete slice when authorized, and stop for approval.

## Implementation-plan requirements

For each material step state where it belongs, what existing behavior it extends, responsibility, inputs, outputs, side effects, branches, failures, tests, and required document updates.

Do not require implementation to rediscover design algorithms, warning/blocker classifications, lifecycle, repository boundaries, rule provenance, acceptance coverage, interface contracts, fixture scenarios, or documentation impact.

## Required slice sections

- title;
- status;
- source Issue;
- context;
- goal;
- scope;
- non-goals;
- acceptance criteria;
- governing-rule reconciliation;
- implementation plan;
- expected files;
- documentation impact;
- validation plan;
- failure conditions;
- review checklist;
- approval evidence;
- completion evidence.

## Optional sections

Dependencies, relevant documents, constraints, existing seam, component map, decision table, interface contracts, file plan, acceptance mapping, adjustments, blockers, rollback, or migration notes.

## Validation

Verify Issue meaning is preserved, acceptance is covered, rules are reconciled, steps are in scope, expected files are bounded, interfaces are specified, documentation impact is explicit, commands are concrete, failure and review checks are meaningful, placeholders are resolved except pending lifecycle evidence, and status is `Draft`.

### Executability gate

The implementation agent must be able to identify the integration point, file responsibilities, governing branches, inputs/outputs/order/side effects/failures, tests, documentation updates, acceptance coverage, and completion condition.

Fail when broad discovery, material design interpretation, undocumented policy invention, architecture choice, interface guessing, test-matrix invention, or semantic gap filling remains.

Material implementation policy may be created during preparation when required to execute the approved outcome, but new semantic or product policy should be made explicit as an assumption, warning, blocker, or proposed refinement rather than remaining implicit.

Fail when the slice introduces unnecessary public configurability or exposes a test-only seam through the operator interface without governing justification.

## Required outputs

Provide the complete Draft slice, traceability, readiness result, inspected seam, rule reconciliation, interface contracts when applicable, documentation impact, assumptions, blockers, and explicit notice that approval and implementation are not authorized.

## Failure and escalation behavior

Stop when readiness, boundedness, authority, dependencies, validation, implementation inspection, interfaces, documentation authorization, or executability are inadequate. Return to the relevant upstream operation rather than repairing the Issue silently.

## Completion conditions

Complete when one traceable, decision-complete `Draft` exists with explicit rule provenance, interfaces when applicable, documentation impact, bounded tests and validation, and no implementation begun.

