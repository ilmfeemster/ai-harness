# Current Slice

> **Project operational state:** The reusable template may provide this document's schema, but every project must initialize its own active slice. This content tracks AI Development Harness work only.

## Harness Phase 0.2 — Define Document Responsibilities and Reuse Boundaries

**Status:** Complete — awaiting human approval

## Source

`docs/bootstrap-tasks.md` — Phase 0.2

This temporary source exists only until GitHub Issues become the authoritative work queue in Phase 0.3.

## Context

Phase 0.1 established the harness constitution and core documents, but their responsibilities and reuse treatment were not precise enough.

The first Phase 0.2 draft placed the reusable document-responsibility matrix in `docs/architecture.md`. That mixed generic workflow governance with the architecture of the current project and made future template initialization ambiguous.

The corrected model must distinguish:

- workflow assets that can be reused nearly verbatim;
- project-document structures that can be reused only as scaffolds;
- substantive project context that must be replaced;
- temporary harness-development artifacts that must not enter the template.

## Goal

Create a durable document ownership model that can govern both this repository and future projects without mixing reusable workflow rules with AI Development Harness project context.

## Scope

- Review all existing core documents.
- Define the primary responsibility of each source.
- Define what each source must not contain or become.
- Classify each source by template reuse treatment.
- Put the reusable responsibility matrix in `AGENTS.md`.
- Make `AGENTS.md` project-neutral enough to reuse with minimal changes.
- Keep `docs/architecture.md` focused on the architecture of the harness product.
- Define how the harness repository's dual role affects future project initialization.
- Replace the universal document hierarchy with authority by concern.
- Define contradiction behavior.
- Define normal information flow and optional layers.
- Update context-loading rules in `AGENTS.md`.
- Add a temporary bootstrap work queue until GitHub Issues exist.
- Mark project-context documents clearly.
- Correct duplicated or ambiguous wording in existing documents.

## Non-goals

- Do not create GitHub Issue templates.
- Do not define labels.
- Do not finalize the complete Issue readiness contract.
- Do not finalize every field in the reusable slice standard.
- Do not add validation scripts.
- Do not add a CLI.
- Do not automate project initialization.
- Do not modify another repository.
- Do not add another permanent workflow-governance document.

## Implemented reuse model

### Reused nearly verbatim

- `AGENTS.md`;
- future Issue templates;
- future validators and workflow scripts.

### Reused as structure, populated with new project context

- `README.md`;
- `docs/project.md`;
- `docs/roadmap.md`;
- `docs/architecture.md`;
- `docs/decisions.md`;
- `docs/testing.md`;
- `docs/design/*.md`;
- `docs/current-slice.md`.

### Entirely project-specific state

- GitHub Issue contents;
- active slice contents;
- architecture and design details;
- decision entries;
- source code and tests;
- validation history.

### Excluded from the reusable template

- `docs/bootstrap-tasks.md`.

The authoritative responsibility and reuse matrix now lives in `AGENTS.md`.

## Information flow

A design-heavy change may use:

```text
roadmap
↓
current project scope
↓
architecture + decisions
↓
design
↓
GitHub Issue
↓
current slice
↓
implementation
↓
validation + review
↓
human approval
```

A small, well-understood change may begin at the GitHub Issue level.

During harness bootstrap, `docs/bootstrap-tasks.md` temporarily replaces GitHub Issues.

## Implementation steps

1. Rewrote `AGENTS.md` as the reusable workflow constitution.
2. Added the authoritative document responsibility and template-treatment matrix to `AGENTS.md`.
3. Replaced the universal hierarchy with authority by concern.
4. Defined stop behavior for material contradictions.
5. Defined reusable assets, project-document scaffolds, project context, and bootstrap-only artifacts.
6. Updated work modes and selective context loading.
7. Updated `README.md` to explain the repository's dual role and future template packaging.
8. Kept `docs/project.md` focused on current harness scope.
9. Kept `docs/roadmap.md` focused on future harness direction rather than active task tracking.
10. Reworked `docs/architecture.md` to describe harness architecture and template composition without owning generic workflow governance.
11. Added durable decisions for authority by concern and reuse separation.
12. Clarified project-wide versus slice-specific validation in `docs/testing.md`.
13. Added `docs/bootstrap-tasks.md` as a temporary, explicitly non-template work queue.
14. Reviewed all files for harness-context leakage into reusable workflow rules.

## Expected files changed

- `README.md`
- `AGENTS.md`
- `docs/project.md`
- `docs/roadmap.md`
- `docs/architecture.md`
- `docs/decisions.md`
- `docs/testing.md`
- `docs/bootstrap-tasks.md`
- `docs/current-slice.md`

## Validation commands

Run:

```bash
git diff --check
```

Then inspect:

```bash
git diff --stat
git diff -- README.md AGENTS.md docs/
```

Manual checks:

- the authoritative responsibility matrix exists in `AGENTS.md`, not `docs/architecture.md`;
- `AGENTS.md` does not contain harness product scope, roadmap, or active work details;
- `docs/architecture.md` describes the harness product's architecture and template composition;
- project-context documents are explicitly identified as project context;
- reusable assets are distinguished from scaffolds whose content must be replaced;
- `docs/bootstrap-tasks.md` is explicitly excluded from future projects;
- the current slice cannot silently override upstream constraints;
- roadmap, project scope, architecture, decisions, design, work items, and slices remain distinct;
- testing strategy remains separate from slice-specific commands;
- no Issue templates, automation, validators, or application code were added.

## Validation results

- `git diff --check`: Passed in the prepared Phase 0.2 worktree.
- Responsibility-matrix placement review: Passed.
- Reusable-versus-project-context review: Passed.
- Architecture-boundary review: Passed.
- Authority and conflict review: Passed.
- Scope review: Passed.

## Acceptance criteria

- A clear responsibility model exists for all core sources.
- Every core source has an explicit template reuse treatment.
- Generic workflow governance is reusable without carrying harness product context.
- `docs/architecture.md` contains project architecture rather than the reusable responsibility matrix.
- Project-context documents can be reset for a new project without losing workflow rules.
- Authority between overlapping sources is explicit.
- The intended information flow is documented.
- Work queue and current slice remain distinct.
- Testing strategy and slice-specific validation remain distinct.
- The result remains lightweight enough for a solo developer.
- Phase 0.3 can define GitHub Issues without reopening these boundaries.

## Failure conditions

Revise before approval if:

- a reusable workflow file still embeds harness-specific project state;
- a project-context document is expected to be copied verbatim into unrelated projects;
- `docs/architecture.md` again becomes the owner of generic document governance;
- the model requires several new permanent process documents;
- the work queue and current slice remain ambiguous;
- the changes drift into Issue-template or validation-tool implementation.

## Review checklist

- Can a developer identify what is copied, reset, or excluded when starting a project?
- Can an agent determine where new information belongs?
- Does `AGENTS.md` remain useful across different software projects?
- Does `docs/architecture.md` clearly describe this project's architecture?
- Are project-specific facts prevented from leaking into reusable workflow assets?
- Does the model support small bugs as well as design-heavy changes?
- Is Phase 0.3 now straightforward?

## Completion notes

Phase 0.2 now separates reusable workflow governance from project intelligence.

The central correction is that the document-responsibility matrix belongs in `AGENTS.md`. The harness architecture document may explain how the template is composed, but it does not govern the meaning of every project document.

The source repository can continue using real project-context documents to develop the harness. Future project initialization must copy reusable assets, initialize clean document scaffolds, and omit harness bootstrap state.

Phase 0.3 is ready in `docs/bootstrap-tasks.md`, but it has not been promoted or started.
