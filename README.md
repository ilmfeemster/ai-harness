# AI Development Harness

An opinionated, document-driven starting point for AI-assisted software development.

This repository has two roles:

1. it is the project in which the harness is being designed and tested; and
2. it is the source from which reusable workflow assets and project-document scaffolds will be packaged.

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
- future GitHub Issue templates;
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

### Excluded from the long-term template

- `docs/bootstrap-tasks.md`, which temporarily tracks harness development until GitHub Issues are established.

The authoritative document-responsibility and reuse matrix is in `AGENTS.md`.

## Current maturity

**Harness Phase 0 — Usable document-driven workflow template**

Phase 0 is intentionally human-orchestrated. It should provide a workflow at least as useful as the proven workflow in `live-draft-tool-v2`, while replacing `tasks.md` with GitHub Issues as the long-term work queue.

Until the GitHub Issue workflow is established in Phase 0.3, `docs/bootstrap-tasks.md` temporarily tracks harness work.

## Repository map

- `AGENTS.md` — reusable workflow constitution and document-responsibility model.
- `docs/project.md` — current AI Development Harness scope and active phase.
- `docs/roadmap.md` — future harness maturity direction.
- `docs/architecture.md` — current architecture of the harness product.
- `docs/decisions.md` — durable harness decisions and tradeoffs.
- `docs/testing.md` — harness-specific testing and confidence standards.
- `docs/current-slice.md` — the single bounded harness work package approved for implementation.
- `docs/design/` — detailed harness designs when needed.
- `docs/bootstrap-tasks.md` — temporary harness work queue until Phase 0.3.
- `.github/ISSUE_TEMPLATE/` — reusable work-item contracts, added in Phase 0.3.

## Phase 0 operating model

1. Define or update current project scope in `docs/project.md`.
2. Update architecture, decisions, or design only when the work requires them.
3. Create implementation work as GitHub Issues.
4. Promote exactly one ready issue into `docs/current-slice.md`.
5. Review and approve the slice.
6. Manually invoke an implementation agent.
7. Run the slice validation commands.
8. Review the result and decide whether to approve, repair, or revise.
9. Do not automatically begin the next issue.

## Phase 0 non-goals

- Autonomous issue selection.
- Automatic implementation.
- Automatic repair loops.
- Multi-agent coordination.
- A central controller for other repositories.
- Generic abstractions not proven through use.

The first integration testbed is `live-draft-tool-v2`.
