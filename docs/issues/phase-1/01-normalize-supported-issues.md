---
title: "Phase 1: Normalize supported GitHub Issue forms"
work_type: "Feature"
readiness: "Ready"
phase: "phase-1"
sequence: "01"
depends_on: ""
github_issue_number: "8"
github_issue_url: "https://github.com/ilmfeemster/ai-harness/issues/8"
---

# Phase 1: Normalize supported GitHub Issue forms

## Work type

Feature

## Goal

Provide a read-only local path that converts a human-selected supported GitHub Issue into a traceable normalized work-item contract.

## Context

Phase 1 preparation requires reliable Issue inputs before document discovery or slice drafting can occur. The approved design limits support to the repository's implementation and bug forms, preserves the authoritative source Issue, and requires clear failure when Issue data or expected fields cannot be read.

## Scope

- Read an explicitly supplied Issue through a read-only local GitHub CLI path.
- Parse the rendered bodies of the bundled implementation and bug forms.
- Normalize supported form fields into one contract while retaining Issue number, title, URL, state, and unparsed body traceability.
- Provide fixtures and deterministic tests for valid supported forms and actionable failures for unsupported or incomplete forms.

## Non-goals

- Do not select an Issue, change GitHub state, or publish an Issue.
- Do not support arbitrary third-party forms or label-based readiness.
- Do not discover local documents, write manifests, generate slices, or start implementation.
- Do not store credentials or issue content in a central service or database.

## Acceptance criteria

- [ ] An explicitly supplied open implementation-form Issue is normalized with its required form fields, source number, title, URL, state, and unparsed-body traceability.
- [ ] An explicitly supplied open bug-form Issue is normalized into the same contract without losing its observed, expected, evidence, or impact context.
- [ ] Missing required fields, unsupported headings, unreadable Issue data, and closed Issues produce actionable failures without changing GitHub or local active-slice state.
- [ ] Readiness confirmations are represented accurately for later preparation guards; labels do not establish readiness.
- [ ] Fixtures and deterministic tests cover supported forms and the defined failure cases.

## Dependencies

- **Phase-local prerequisites (`depends_on`):** None.
- **Promotion blockers:** The approved Phase 1 design must remain available, and the published source Issue must satisfy the readiness contract before this Issue can be promoted.

## Relevant project documents

- `docs/project.md`
- `docs/architecture.md`
- `docs/decisions.md`
- `docs/testing.md`
- `docs/design/phase-1-context-and-slice-assistance.md`
- `.github/ISSUE_TEMPLATE/implementation.yml`
- `.github/ISSUE_TEMPLATE/bug.yml`

## Readiness

- [x] The goal is singular and bounded.
- [x] Scope and non-goals are explicit.
- [x] Acceptance criteria are observable and reviewable.
- [x] Dependencies and their completion conditions are explicitly documented.
- [x] Relevant project documents are identified.
- [x] No unresolved product or architecture decision blocks execution.
- [x] The work is small enough for one implementation slice.
