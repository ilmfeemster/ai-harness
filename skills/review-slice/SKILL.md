# Review Slice

## Purpose

Independently evaluate whether an implemented and validated slice is correct, in scope, compatible with authority, meaningfully tested, documented accurately, maintainable for current maturity, and supported by a sufficiently prepared slice.

Review is distinct from validation and final approval.

## When to use

Use when status is `Ready for review`, the Issue, diff, and validation evidence are available, and review is requested. Earlier advisory review must be labeled partial and cannot advance state.

## Do not use when

Do not implement fixes, silently rewrite artifacts, set `Complete`, close the Issue, or authorize another work item.

## Authority and boundaries

Read and obey `AGENTS.md`.

Review evaluates against the Issue, approved slice, project scope, architecture, decisions, approved design, testing standards, and implementation evidence.

Do not infer approval from passing tests.

## Required inputs

- source Issue;
- current slice;
- changed files and diff;
- formal validation results;
- completion evidence.

## Required context

Load the Issue, slice, diff, validation evidence, relevant architecture, decisions, design, testing standards, and documents named in documentation impact.

Expand only for changed dependencies, referenced behavior, contradictions, or documentation currency.

## Review procedure

1. Verify traceability and expected state.
2. Verify slice-approval evidence.
3. Read the diff before summaries.
4. Evaluate each acceptance criterion.
5. Reconcile implemented decision behavior with governing-rule provenance.
6. Check for out-of-scope changes, missing behavior, shortcuts, hardcoding, weakened tests, authority conflicts, rule narrowing/broadening, interface drift, unnecessary abstractions, unrelated cleanup, unnecessary dependencies, unhandled failures, stale documents, and misleading evidence.
7. Evaluate test quality and validation risk coverage.
8. Assess maintainability for current maturity.
9. Assess slice quality:
   - decisions implementation had to invent;
   - broad discovery beyond the slice;
   - inaccurate assumptions;
   - unnecessary instructions;
   - missing interface or test detail.
10. Record findings first by severity.
11. Report acceptance status, questions, assumptions, validation/documentation gaps, change summary, slice-quality assessment, and readiness for human approval.
12. Do not change state.

## Severity guidance

- **Critical** — unsafe or fundamentally invalid.
- **High** — incorrect required behavior, serious scope/authority conflict, or stale governing documentation that misdirects future work.
- **Medium** — meaningful defect, edge case, weak evidence, interface drift, or maintainability issue.
- **Low** — limited-risk improvement.
- **Observation** — non-blocking context.

Do not inflate style preferences.

## Slice-quality assessment

Use:

```markdown
## Slice-quality assessment

- **Missing execution decisions:** None | ...
- **Incorrect assumptions:** None | ...
- **Unnecessary instructions:** None | ...
- **Discovery required beyond the slice:** None | ...
- **Recommended preparation improvement:** None | ...
```

A process concern blocks approval only when it caused or conceals a material result problem.

## Validation of the review

Verify findings are evidence-based, criteria were checked individually, tests were assessed meaningfully, scope/authority/rule provenance/interfaces/document currency were reviewed, assumptions are explicit, no code or state changed, and no-findings is not represented as approval.

## Required outputs

1. findings by severity;
2. acceptance status;
3. questions and assumptions;
4. validation and documentation gaps;
5. concise change summary;
6. slice-quality assessment;
7. readiness for human approval.

## Failure and escalation behavior

Qualify or stop when the Issue, traceability, diff, validation, governing sources, or authority consistency is inadequate. Required changes use a separate implementation handoff.

## Completion conditions

Complete when implementation is independently evaluated, findings and acceptance are explicit, documentation currency and slice quality are assessed, approval readiness is stated, and no implementation, closure, or completion transition occurred.
