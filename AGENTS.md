# Repository AI Development Instructions

## 1. Purpose

This repository uses an opinionated, document-driven workflow for AI-assisted software development.

`AGENTS.md` is the reusable workflow constitution. It defines authority, invariants, lifecycle, approval boundaries, document-currency requirements, and required skill use. Repeatable procedures live in `skills/*/SKILL.md`. Product state and project intelligence live in project-owned documents.

The harness objective is to convert expensive reasoning into durable, inspectable artifacts. Each stage should resolve only the decisions it owns and produce an output that makes the next stage more deterministic.

The goal is reliable, high-quality leverage, not autonomy for its own sake.

## 2. Core principles

Prefer:

- durable documents over repeated prompts;
- bounded work items and small vertical slices;
- explicit scope and non-goals;
- upstream reasoning preserved for downstream execution;
- deterministic validation;
- independent review;
- explicit human approval;
- project-local solutions;
- abstraction only after proven repetition.

Do not claim or depend on automation that does not exist.

## 3. Reuse and ownership

### Reusable workflow assets

- `AGENTS.md`;
- `skills/`;
- `.github/ISSUE_TEMPLATE/`;
- neutral files under `templates/`;
- workflow scripts and structural validators.

### Project-owned artifacts

- `README.md`;
- `docs/project.md`;
- `docs/roadmap.md`;
- `docs/architecture.md`;
- `docs/decisions.md`;
- `docs/testing.md`;
- `docs/design/*.md`;
- `docs/issues/<phase>/`;
- `docs/context-manifests/`;
- `docs/current-slice.md`;
- GitHub Issues;
- code and tests.

Do not copy another project's substantive context or active state merely because the paths are reusable.

## 4. Authority by concern

| Source | Governing concern |
| --- | --- |
| User request | Immediate intent, authorization, scope changes, and human approval |
| `README.md` | Human entry point, setup, current maturity, and navigation |
| `AGENTS.md` | Workflow authority, invariants, lifecycle, boundaries, and skill invocation |
| `skills/*/SKILL.md` | Procedure for one authorized operation |
| `docs/project.md` | Current product state, active phase, goals, scope, non-goals, and exit criteria |
| `docs/roadmap.md` | Future phases, outcomes, capabilities, and sequencing |
| `docs/architecture.md` | Current structure, boundaries, dependency direction, and constraints |
| `docs/decisions.md` | Durable decisions, rationale, and tradeoffs |
| `docs/design/*.md` | Approved detailed design for a coherent capability |
| `docs/issues/<phase>/README.md` | Local phase breakdown, ordering, coverage, approval, and publication |
| `docs/issues/<phase>/*.md` | Local Issue drafts and retained publication traceability |
| GitHub Issues | Authoritative work queue and required outcomes |
| `docs/context-manifests/*.md` | Project-local context-preparation traceability |
| `docs/current-slice.md` | One bounded execution package for the active Issue |
| `docs/testing.md` | Project-wide confidence standards |
| Code and tests | Implemented behavior and executable evidence |

A skill is subordinate to this constitution. A downstream artifact may not silently override an upstream concern.

## 5. Universal invariants

### 5.1 One active work item

Maintain at most one current slice, one active Issue, and one implementation effort. Future Ready Issues do not authorize additional active work. Do not begin the next Issue automatically.

### 5.2 Distinct operations

These are separate operations:

- project initialization;
- repository orientation;
- phase activation;
- project, architecture, or design planning;
- phase work breakdown;
- Issue publication;
- one work-item creation or refinement;
- slice preparation;
- slice approval recording;
- implementation;
- validation;
- review;
- finalization.

Completion of one operation does not authorize the next.

### 5.3 Approval boundaries

Explicit human approval or authorization is required:

- before a Draft design governs;
- before local Issue drafts are published;
- before `Draft` becomes `Approved`;
- before implementation begins from `Approved`;
- before a material approved outcome changes;
- before `Ready for review` becomes `Complete`;
- before the Issue is closed.

Planning approval is not slice approval. Slice approval is not implementation authorization. Validation and review are not human approval.

### 5.4 Scope preservation

Do not silently change project scope, Issue outcome, architecture, durable decisions, approved design, or testing standards. Execution may refine implementation detail only when the approved outcome remains unchanged.

### 5.5 Conflict handling and rule provenance

Every material deterministic rule added to a slice must identify its governing source or be labeled as an implementation refinement. A refinement may not narrow, broaden, or replace authoritative behavior.

When authorities conflict:

1. stop affected work;
2. identify the conflict and each source's concern;
3. correct the proper source when authorized, or request a decision;
4. do not resolve it through assumption.

### 5.6 Documentation currency

Because project intelligence lives in documents, implemented behavior and governing documents must not knowingly diverge.

Every slice must assess impact on:

- current product or phase state;
- architecture or dependency direction;
- durable decisions;
- approved design;
- project-wide testing standards;
- operator guidance.

Required updates belong in the same bounded slice when the Issue permits them. Otherwise revise the work item. Validation and review check documentation impact. Finalization must refuse knowingly stale authority.

### 5.7 Side effects

An informational request does not authorize file changes, GitHub writes, dependency changes, or lifecycle transitions. Stop when a required source, decision, approval, or authorization is missing.

## 6. Context loading

At repository-work start:

1. read this file;
2. identify the requested operation;
3. read the complete required skill;
4. load its required authorities;
5. reuse already loaded context;
6. stop before unauthorized work.

Expand context only when needed for linked authority, existing behavior, validation, conflict resolution, documentation impact, or a real dependency.

## 7. Required workflow and skills

```text
docs/roadmap.md
→ start-phase
→ docs/project.md
→ plan-change when design is required
→ approved design or no-design rationale
→ plan-phase-work
→ local Issue drafts
→ human publication approval
→ publish-issues
→ GitHub Issues
→ prepare-slice
→ Draft current slice
→ approve-slice
→ Approved current slice
→ explicit implementation authorization
→ implement-slice
→ validate-slice
→ review-slice
→ explicit final approval
→ finalize-work-item
```

| Operation | Required skill | Primary output |
| --- | --- | --- |
| Project initialization | `skills/start-project/SKILL.md` | Clean, self-contained project |
| Repository orientation | `skills/orient-repository/SKILL.md` | Grounded repository map |
| Phase activation | `skills/start-phase/SKILL.md` | Updated `docs/project.md` and design assessment |
| Planning or design | `skills/plan-change/SKILL.md` | Authorized planning artifact |
| Phase work breakdown | `skills/plan-phase-work/SKILL.md` | Local phase plan and Issue drafts |
| Issue publication | `skills/publish-issues/SKILL.md` | GitHub Issues and local traceability |
| One work item | `skills/create-work-item/SKILL.md` | One Draft or Ready Issue |
| Slice preparation | `skills/prepare-slice/SKILL.md` | One complete `Draft` slice |
| Slice approval recording | `skills/approve-slice/SKILL.md` | One `Approved` slice |
| Implementation | `skills/implement-slice/SKILL.md` | Bounded implementation |
| Formal validation | `skills/validate-slice/SKILL.md` | Evidence and possible `Ready for review` transition |
| Independent review | `skills/review-slice/SKILL.md` | Findings and approval-readiness assessment |
| Finalization | `skills/finalize-work-item/SKILL.md` | Closed Issue and `Complete` slice |

Do not improvise a lifecycle operation.

## 8. Phase lifecycle

A phase may be activated only when it exists in the roadmap, the user selects it, sequencing is valid, and current state can be stated without claiming planned capability exists.

`docs/roadmap.md` remains future direction. `docs/project.md` becomes current-phase authority. When a design is required, Issue planning stops until that design is approved.

## 9. Phase plans and Issue drafts

Phase work planning uses `docs/issues/<phase-slug>/` with one README and ordered Issue drafts. The plan must cover phase exit criteria, dependencies, sequencing, deferred work, approval, and publication.

Every local Issue draft contains one bounded outcome and the Issue contract. It must not contain the full file-level implementation plan.

After publication, GitHub Issues are authoritative. Stop before slice preparation.

## 10. GitHub Issue contract

Every Issue includes goal or expected outcome, context, scope, non-goals, acceptance criteria, dependencies, relevant documents, and readiness confirmation.

### Issue states

1. **Draft** — incomplete contract.
2. **Ready** — complete, bounded, reviewable.
3. **Active** — referenced by the one `Approved` current slice.
4. **Complete** — validated, reviewed, human-approved, and closed.

Labels may classify work but do not establish workflow state. Close an Issue only through finalization.

## 11. Current slice contract

`docs/current-slice.md` is the single bounded execution package.

It must translate the Issue and governing documents into file-level, decision-complete detail without broad reinterpretation. It may refine implementation detail but may not change the outcome.

Resolve when applicable:

- existing seam and integration point;
- ordered file-level changes;
- component or function responsibilities;
- input and output contracts;
- ordering, normalization, duplicate, warning, blocker, and error rules;
- fixture and test branches;
- acceptance-to-validation coverage;
- governing-rule provenance;
- documentation impact;
- assumptions and unresolved decisions.

Every non-empty slice includes:

- title and status;
- source Issue traceability;
- context, goal, scope, non-goals, and acceptance criteria;
- governing-rule reconciliation;
- implementation plan and expected files;
- documentation impact;
- validation plan and failure conditions;
- review checklist;
- approval evidence;
- completion evidence.

### Deterministic interface requirement

When changing a parser, command, generated document, manifest, schema, persisted record, or serialized output, define accepted inputs, invocation surface, normalization, ordering, duplicate handling, output schema, overwrite/idempotency behavior, side effects, and sanitized failures.

### Slice states

1. `Draft`
2. `Approved`
3. `In progress`
4. `Blocked`
5. `Ready for review`
6. `Complete`

```text
Draft
→ explicit approval recorded by approve-slice
Approved
→ explicit implementation authorization
In progress
→ formal validation passes
Ready for review
→ review + explicit final approval + Issue closure
Complete
```

Additional transitions:

- `In progress` → `Blocked`;
- `Blocked` → `In progress` after resolution and authorization;
- `Ready for review` → `In progress` for authorized correction;
- material outcome change → `Draft` and reapproval.

## 12. Lifecycle ownership

### Preparation

Creates a complete `Draft` and stops.

### Approval recording

Verifies explicit human approval, records it, changes `Draft` to `Approved`, and stops. It does not implement.

### Implementation

Requires `Approved` plus separate authorization. It performs in-scope code, tests, and required document updates, then leaves the slice `In progress`.

### Validation

Owns formal evidence, documentation-impact verification, and `In progress` → `Ready for review`. It does not repair or approve.

### Review

Evaluates correctness, authority, rule provenance, scope, architecture, documentation currency, tests, maintainability, and slice quality. It reports findings without fixing or completing.

### Finalization

Requires `Ready for review`, complete validation and review, resolved documentation impact, no blocking finding, and explicit final approval. It records final approval, closes the Issue, changes the slice to `Complete`, and stops.

## 13. Architecture philosophy

Prefer explicit, inspectable, project-local systems and fast feedback. Avoid premature frameworks, central orchestration before proven need, and abstractions created only to appear reusable. Generalize only after repeated real use reveals a stable pattern.

