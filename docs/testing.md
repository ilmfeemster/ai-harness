# Testing and Validation

> **Project-context document:** This file defines confidence standards for the current project. Future projects may reuse its structure but must specialize commands and evidence requirements.

## Goal

Define the confidence required before harness work is complete.

This document separates structural validation, behavioral testing, workflow validation, documentation-currency checks, independent review, and future automated evaluation.

Slice-specific commands and results belong in `docs/current-slice.md`.

## Testing philosophy

Prioritize confidence and correctness over test count. Prefer checks that detect meaningful workflow failure. Mechanical validation must not claim semantic judgment.

## Current validation priorities

The retained Phase 0 workflow must prove:

- reusable assets remain separate from project context;
- clean initialization does not inherit source state;
- required project documents and workflow skills exist;
- Issue forms preserve readiness;
- one Ready Issue becomes one bounded slice;
- Issue outcome and execution remain aligned;
- validation and review remain separate.

Phase 1 must additionally prove:

- supported Issue forms normalize deterministically;
- incomplete or unknown forms fail clearly;
- bounded discovery excludes unrelated content;
- selected designs follow approved rules;
- Draft and ambiguous designs do not silently govern;
- context manifests are deterministic, safe, and isolated per Issue;
- generated Drafts preserve source Issue sections;
- material rules are traceable to authority;
- parser and generated-artifact interfaces are deterministic;
- unresolved active slices are never replaced;
- Draft approval is separate from implementation authorization;
- lifecycle status and evidence cannot contradict;
- documentation impact is resolved before review readiness and completion.

## Validation versus review

### Validation

Mechanical or observable evidence:

- required files, sections, and complete skill inventory;
- valid Issue-form YAML;
- no placeholders;
- parseable configuration;
- deterministic parser and manifest fixtures;
- command exit codes;
- automated tests;
- lifecycle/evidence consistency;
- required document changes present.

### Review

Judgment about Issue satisfaction, readiness, rule provenance, bounded scope, architecture, decisions, design, documentation currency, test meaning, unsupported shortcuts, maintainability, and whether the slice moved reasoning upstream.

Passing validation does not imply approval.

## Local structural validation

```powershell
powershell -NoProfile -File scripts/validate.ps1
```

It checks required paths and skills, active-slice headings and traceability, lifecycle states, approval evidence, status/evidence consistency, Issue-template fields, neutral scaffolds, placeholders, local references, reusable-asset leakage, and clean-initialization leakage.

For a clean initialized project:

```powershell
powershell -NoProfile -File scripts/validate.ps1 -InitializedProject -CleanInitialization
```

Validator behavior:

```powershell
powershell -NoProfile -File tests/validate-structure.ps1
```

These are mechanical checks only.

## Project-wide standards versus slice checks

This document owns general evidence standards. The active slice declares exact commands, manual checks, acceptance mapping, interface branches, and documentation impact for one work item.

A slice may add stricter checks but may not weaken project-wide standards.

## Test levels

### Structural tests

Required paths and skills, neutral assets, project isolation, slice schema, Issue traceability, lifecycle/evidence consistency, approval evidence, placeholders, and practical local references.

### Unit tests

Deterministic parsing, classification, rendering, normalization, ordering, validation, and failures.

### Integration tests

Complete local commands against fixtures or temporary repositories.

Phase 1 integration tests cover normalized Issue input to manifest, deterministic rendering and overwrite isolation, guarded Draft generation, no GitHub writes, and no active-slice replacement on blockers.

The integrated Phase 1 workflow must additionally be exercised through its one explicit-Issue foreground command contract using temporary repository roots and injected read-only fixtures. Focused evidence must cover a successful manifest-plus-Draft result, a source prerequisite or parser failure with no artifact writes, a bounded-context failure with a matching manifest blocker, and an unresolved active-slice or Draft guard with byte-preserved active state. Tests must assert the compact sanitized result, same-Issue output isolation, no GitHub mutation, and the unchanged Draft approval and implementation boundaries.

### Workflow tests

```text
GitHub Issue
→ readiness review
→ Draft slice
→ explicit slice approval
→ separate implementation authorization
→ implementation
→ validation
→ review
→ final approval
→ Issue closure
```

### Manual QA

Confirm understandable context loading, separated mechanics/context, explainable selection, sufficiently specific execution detail, clear approvals, current documentation, reviewable completion, and justified overhead.

## Acceptance standard

A slice is not complete until criteria are met, automated and manual checks pass, tests were not weakened, documentation impact is resolved, evidence is accurate, independent review has no blocker, a human explicitly approves the completed result, and finalization closes the Issue.

## Future evaluation

Later independent evaluation should compare Issue, approved slice, governing documents, implementation diff, changed tests and documents, validation results, and implementation report. Current mechanical tests must not pretend to provide semantic evaluation.
