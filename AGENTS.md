# Repository AI Development Instructions

## 1. Purpose

This repository uses an opinionated, document-driven workflow for AI-assisted software development.

`AGENTS.md` is the reusable workflow constitution. It defines authority, invariants, lifecycle, approval boundaries, and required skill use.

Repeatable procedures live in `skills/*/SKILL.md`. Product state and project intelligence live in project-owned documents.

The goal is reliable, high-quality leverage, not autonomy for its own sake.

## 2. Core principles

Prefer:

- durable documents over repeated prompts;
- bounded work items and small vertical slices;
- explicit scope and non-goals;
- deterministic validation;
- independent review;
- human approval at meaningful boundaries;
- simple, project-local solutions;
- abstraction only after repeated patterns are proven.

Do not claim or depend on automation that does not exist.

## 3. Reuse and ownership

### Reusable workflow assets

- `AGENTS.md`;
- `skills/`;
- `.github/ISSUE_TEMPLATE/`;
- neutral files under `templates/docs/`;
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
- `docs/current-slice.md`;
- GitHub Issues;
- code and tests.

Do not copy another project's substantive context, roadmap, designs, phase plans, Issue drafts, active slice, backlog, or implementation history merely because the paths are reusable.

## 4. Authority by concern

| Source | Governing concern |
| --- | --- |
| User request | Immediate intent, authorization, scope changes, and human approval |
| `README.md` | Human entry point, setup, and navigation |
| `AGENTS.md` | Workflow authority, invariants, lifecycle, boundaries, and skill invocation |
| `skills/*/SKILL.md` | Procedure for an authorized operation |
| `docs/project.md` | Current product state, active phase, goals, scope, non-goals, phase-preparation state, and exit criteria |
| `docs/roadmap.md` | Future phases, outcomes, capabilities, and sequencing |
| `docs/architecture.md` | Current structure, boundaries, dependency direction, and constraints |
| `docs/decisions.md` | Durable decisions, rationale, and tradeoffs |
| `docs/design/*.md` | Approved detailed design for a coherent capability |
| `docs/issues/<phase>/README.md` | Local phase work breakdown, dependency order, coverage, approval, and publication record |
| `docs/issues/<phase>/*.md` | Local Issue drafts before publication and retained traceability afterward |
| GitHub Issues | Authoritative work queue and required outcomes |
| `docs/current-slice.md` | One bounded execution package for the active Issue |
| `docs/testing.md` | Project-wide validation and confidence standards |
| Code and tests | Implemented behavior and executable evidence |

A skill is subordinate to this constitution.

Before publication, a local Issue draft is proposed work. After publication, the GitHub Issue is authoritative. Retained local drafts must record the Issue number and URL and must not silently diverge.

## 5. Universal invariants

### 5.1 One active work item

Maintain at most:

- one current slice;
- one active GitHub Issue;
- one implementation effort governed by that slice.

A phase may have several future Issue drafts or Ready GitHub Issues. That does not authorize multiple active slices or implementation efforts.

Do not begin the next Issue automatically after completion.

### 5.2 Distinct operations

These are separate operations:

- project initialization;
- repository orientation;
- roadmap phase activation;
- project, architecture, and design planning;
- phase work breakdown;
- Issue publication;
- individual work-item creation or refinement;
- slice preparation;
- implementation;
- validation;
- review;
- finalization.

Completion of one operation does not authorize the next.

One request may authorize several sequential operations, but agents must stop at every approval boundary and before any unauthorized external side effect.

### 5.3 Approval and authorization boundaries

Explicit human approval or authorization is required:

- before a Draft design is treated as approved input;
- before local Issue drafts are published to GitHub;
- before a `Draft` slice becomes `Approved`;
- before a material change to an approved outcome proceeds;
- before a `Ready for review` slice becomes `Complete`;
- before the source Issue is closed.

A request to activate a named roadmap phase authorizes its `docs/project.md` update and design assessment. It does not authorize design creation, Issue drafting, publication, slice preparation, or implementation unless those operations are also explicit.

Planning approval is not implementation authorization. Validation or review is not human approval.

### 5.4 Scope preservation

Do not silently change:

- project or phase scope;
- Issue goal, scope, non-goals, or acceptance criteria;
- architecture or durable decisions;
- approved design;
- testing standards.

Execution may refine implementation detail only when the approved outcome remains unchanged.

New out-of-scope work belongs in a separate explicitly authorized Issue.

### 5.5 Conflict handling

No downstream artifact may silently override the concern governed by an upstream authority.

When authoritative sources materially conflict:

1. stop affected work;
2. identify the conflict and each source's concern;
3. correct the appropriate source when authorized, or request a decision;
4. do not resolve the conflict through assumption.

If a skill conflicts with this file, this file governs.

### 5.6 Side effects

Stop before changing repository or external state when a required source, decision, approval, or authorization is missing.

An informational request does not imply permission to:

- modify files;
- publish GitHub Issues;
- change dependencies;
- advance lifecycle state.

Drafting local Issue documents is not publication. Creating GitHub Issues is an external side effect.

## 6. Context loading

At the beginning of repository work:

1. read this file;
2. identify the requested operation;
3. read the complete required skill;
4. load that skill's required authoritative sources;
5. reuse already loaded context;
6. stop before unauthorized work.

Expand context only when required to understand linked authority, determine existing behavior, validate work, resolve a conflict, or assess a real dependency.

Context expansion does not authorize another operation.

If work is interrupted, record repository state, progress, decisions, remaining work, blockers, and the next authorized operation. A handoff does not imply approval.

## 7. Required workflow and skills

A roadmap phase becomes executable through:

```text
docs/roadmap.md
→ start-phase
→ docs/project.md
→ plan-change when design is required
→ approved design or recorded no-design rationale
→ plan-phase-work
→ docs/issues/<phase>/
→ human review and publication authorization
→ publish-issues
→ GitHub Issues
→ prepare-slice for exactly one Ready Issue
→ docs/current-slice.md
→ human approval
→ implementation
→ validation
→ review
→ human approval
→ finalization
```

A small, already-decided change within the active phase may begin at one directly created Issue. Starting a new roadmap phase may not skip phase activation.

| Operation | Required skill | Primary output |
| --- | --- | --- |
| Project initialization | `skills/start-project/SKILL.md` | Clean, self-contained project |
| Repository orientation | `skills/orient-repository/SKILL.md` | Grounded repository map |
| Roadmap phase activation | `skills/start-phase/SKILL.md` | Updated `docs/project.md` and design assessment |
| Project, architecture, or design planning | `skills/plan-change/SKILL.md` | Authorized planning artifact |
| Phase work breakdown | `skills/plan-phase-work/SKILL.md` | Local phase plan and Issue drafts |
| Issue publication | `skills/publish-issues/SKILL.md` | GitHub Issues and local traceability |
| One work-item creation or refinement | `skills/create-work-item/SKILL.md` | One Draft or Ready Issue contract |
| Slice preparation | `skills/prepare-slice/SKILL.md` | One complete `Draft` slice |
| Implementation or correction | `skills/implement-slice/SKILL.md` | Bounded implementation |
| Formal validation | `skills/validate-slice/SKILL.md` | Evidence and possible `Ready for review` transition |
| Independent review | `skills/review-slice/SKILL.md` | Findings and approval-readiness assessment |
| Finalization | `skills/finalize-work-item/SKILL.md` | Closed Issue and `Complete` slice |

Do not substitute a similarly named skill or improvise a lifecycle operation.

A coordinating skill may require another skill, but neither may authorize the next operation implicitly.

## 8. Phase lifecycle contract

A phase may be activated only when:

- it exists in `docs/roadmap.md`;
- the user selects it or explicitly requests the next phase;
- the previous phase is complete, or overlapping planning is explicitly authorized;
- current state can be represented without claiming planned capability already exists.

Phase activation updates `docs/project.md` with:

- active phase;
- phase goal;
- current scope and explicit non-goals;
- preserved constraints and dependencies;
- observable exit criteria;
- design requirement and basis;
- expected design path when required;
- Issue-planning status;
- GitHub-publication status.

`docs/roadmap.md` remains future direction. `docs/project.md` becomes the current-phase authority.

When a design is required, phase Issue planning must stop until the design exists, blocking questions are resolved, and the design has explicit human approval.

## 9. Phase plan and local Issue drafts

Phase work planning uses:

```text
docs/issues/<phase-slug>/
├── README.md
├── 01-<bounded-outcome>.md
├── 02-<bounded-outcome>.md
└── ...
```

Use:

- `templates/docs/phase-issue-plan.md`;
- `templates/docs/issue-draft.md`.

The phase plan must record:

- roadmap and project traceability;
- approved design or no-design rationale;
- phase outcome and exit criteria;
- ordered Issues and dependencies;
- coverage of phase capabilities and exit criteria;
- deferred work;
- approval and publication state.

Every local Issue draft must contain one bounded outcome and the repository Issue contract. It must not contain the full file-level implementation plan.

Track separately:

- readiness: `Draft` or `Ready`;
- publication: empty or populated GitHub Issue number and URL.

Do not publish unless:

- the phase plan is approved;
- publication is explicitly authorized;
- each selected draft is `Ready`;
- readiness confirmations are supported;
- duplicates have been checked.

After publication:

- populate local Issue references;
- record the phase publication result;
- treat GitHub Issues as authoritative;
- stop before slice preparation.

## 10. GitHub Issue contract

GitHub Issues are the authoritative work queue.

Use the implementation form for planned changes and the bug form for incorrect existing behavior.

Every Issue must include:

- goal or expected outcome;
- context;
- included scope;
- explicit non-goals;
- acceptance criteria;
- dependencies;
- relevant project documents;
- readiness confirmation.

### Issue states

1. **Draft** — information, decisions, dependencies, or readiness checks are incomplete.
2. **Ready** — the contract is complete and the work fits one reviewable slice.
3. **Active** — the Issue is referenced by the one human-approved current slice.
4. **Complete** — implementation is validated, reviewed, human-approved, and the Issue is closed.

An Issue remains `Ready` while its candidate slice is `Draft`. It becomes `Active` only when the slice becomes `Approved`.

Labels may classify work but do not establish workflow state.

An Issue may be promoted only when its outcome is singular, scope and non-goals are explicit, acceptance criteria are evaluable, dependencies are handled, governing documents are linked, no unresolved decision blocks execution, and every readiness check is complete.

Promotion preserves the Issue outcome and adds execution detail. A material outcome change requires updating the Issue, revising any slice, returning the slice to `Draft`, and obtaining approval again.

Close an Issue only through `finalize-work-item`.

## 11. Current slice contract

`docs/current-slice.md` is the single bounded execution package for the active Issue.

It may specify how to implement the Issue. It may not change the approved outcome.

Every non-empty slice must include:

- title and lifecycle status;
- source Issue number, title, and URL;
- context, goal, scope, and non-goals;
- acceptance criteria;
- implementation plan and expected files;
- validation plan and failure conditions;
- review checklist;
- completion evidence.

Optional sections may add dependencies, governing documents, constraints, adjustments, blockers, or migration notes when useful.

Do not duplicate substantial upstream documentation.

### Slice states

1. `Draft`
2. `Approved`
3. `In progress`
4. `Blocked`
5. `Ready for review`
6. `Complete`

Do not use contradictory states such as `Complete - awaiting human approval`.

```text
Draft
→ human approval
Approved
→ explicit implementation authorization
In progress
→ formal validation passes
Ready for review
→ review + explicit human approval + Issue closure
Complete
```

Additional transitions:

- `In progress` → `Blocked` when work cannot continue;
- `Blocked` → `In progress` after resolution and authorization;
- `Ready for review` → `In progress` for authorized correction;
- material outcome change → `Draft` and reapproval.

Before `Ready for review`, completion evidence must report acceptance status, files changed, validation results, manual checks, adjustments, limitations, and a concise implementation summary.

## 12. Lifecycle ownership

### Implementation

Requires an eligible slice and explicit authorization.

Implementation remains in scope, preserves governing documents, prefers small local changes, adds required tests, records meaningful adjustments, and stops on material contradiction.

Implementation leaves the slice `In progress`.

### Validation

Validation owns formal command and manual-check evidence and the transition from `In progress` to `Ready for review`.

Validation does not weaken tests, rewrite acceptance criteria, approve work, or repair implementation without a separate handoff.

### Review

Review evaluates the Issue, slice, scope, architecture, decisions, design, tests, shortcuts, and maintainability.

Review reports findings first. It does not implement fixes, close the Issue, or mark the slice `Complete`.

### Finalization

Finalization requires:

- `Ready for review`;
- completed validation and review;
- no unresolved blocking finding;
- explicit human approval.

Finalization closes the source Issue and changes the slice to `Complete`.

After completion, stop. Do not reset the slice, select another Issue, or begin new work automatically.

## 13. Scope and architecture philosophy

Distinguish:

- current phase;
- future phase;
- useful deferred idea;
- unnecessary complexity.

Prefer explicit, inspectable, project-local systems and fast feedback.

Avoid premature frameworks, hypothetical scaling infrastructure, central orchestration before proven need, and abstractions created only to appear reusable.

Keep the harness opinionated for proven workflows. Generalize only after repeated real use reveals a stable pattern.
