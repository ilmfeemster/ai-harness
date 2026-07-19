# AI Development Harness

An opinionated, document-driven starting point for AI-assisted software development.

This repository has two roles:

1. it is the project in which the harness is designed and tested; and
2. it is the source from which reusable workflow assets and clean project-document scaffolds will be packaged.

It is not a central controller for other repositories.

## Core principle

Project intelligence lives primarily in durable project documents, not repeated prompts.

```text
project scope
↓
architecture, decisions, and design when needed
↓
GitHub Issue
↓
current-slice.md
↓
implementation
↓
validation and review
↓
human approval
```

Not every change requires every layer.

## Template reuse model

The future project template is not a byte-for-byte copy of this repository's current context.

### Copied as reusable workflow

- `AGENTS.md`;
- `.github/ISSUE_TEMPLATE/`;
- `templates/docs/current-slice.md`;
- future workflow validators and scripts;
- reusable headings and schemas for project documents.

### Created from scaffolds, then filled with project context

- `README.md`;
- `docs/project.md`;
- `docs/roadmap.md`;
- `docs/architecture.md`;
- `docs/decisions.md`;
- `docs/testing.md`;
- `docs/design/`;
- `docs/current-slice.md`.

The current contents of those files describe the AI Development Harness project. Their structures may inform a new project, but their harness-specific content must not be carried over.

The authoritative document-responsibility and reuse matrix is in `AGENTS.md`.

## Current maturity

**Harness Phase 0 — Usable document-driven workflow template**

Phase 0 is intentionally human-orchestrated. GitHub Issues are the authoritative project work queue, while `docs/current-slice.md` remains the single approved execution package.

## Repository map

- `AGENTS.md` — reusable workflow constitution, Issue contract, and document-responsibility model.
- `.github/ISSUE_TEMPLATE/` — reusable Issue forms for implementation work and bugs.
- `templates/docs/current-slice.md` — reusable scaffold for initializing a project-specific active slice.
- `docs/project.md` — current AI Development Harness scope and active phase.
- `docs/roadmap.md` — future harness maturity direction.
- `docs/architecture.md` — current architecture of the harness product.
- `docs/decisions.md` — durable harness decisions and tradeoffs.
- `docs/testing.md` — harness-specific testing and confidence standards.
- `docs/current-slice.md` — the single bounded harness work package approved for implementation, created as project-owned state rather than copied as reusable content.
- `docs/design/` — detailed harness designs when needed.

## Phase 0 operating model

1. Define or update current project scope in `docs/project.md`.
2. Update architecture, decisions, or design only when the work requires them.
3. Create project-specific work through the reusable GitHub Issue forms.
4. Promote exactly one ready Issue into `docs/current-slice.md`.
5. Review and approve the slice.
6. Manually invoke an implementation agent.
7. Run the slice validation commands.
8. Review the result and decide whether to approve, repair, or revise.
9. Close the Issue only after approval.
10. Do not automatically begin the next Issue.

## Phase 0 non-goals

- Autonomous Issue selection.
- Automatic implementation.
- Automatic repair loops.
- Multi-agent coordination.
- A central controller for other repositories.
- Generic abstractions not proven through use.

The first integration testbed is `live-draft-tool-v2`.
