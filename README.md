# AI Development Harness

An opinionated, document-driven template for AI-assisted software development.

The harness is intended to be used as the starting structure for a project repository. Each project owns its workflow documents, design knowledge, work items, implementation slices, code, and validation history.

## Core principle

Project intelligence lives primarily in documents, not repeated prompts.

```text
project.md
→ design documents
→ GitHub Issues
→ current-slice.md
→ implementation
→ validation
→ review
→ approval
```

## Current maturity

**Harness Phase 0 — Usable document-driven workflow template**

Phase 0 is intentionally human-orchestrated. It should provide a workflow at least as useful as the proven workflow in `live-draft-tool-v2`, while replacing `tasks.md` with GitHub Issues for the work queue.

## Repository map

- `AGENTS.md` — workflow constitution.
- `docs/project.md` — current product scope and active phase.
- `docs/roadmap.md` — harness maturity roadmap.
- `docs/architecture.md` — boundaries and design principles.
- `docs/decisions.md` — durable decisions.
- `docs/testing.md` — validation and testing strategy.
- `docs/current-slice.md` — the single bounded execution package approved for implementation.
- `docs/design/` — detailed designs.
- `.github/ISSUE_TEMPLATE/` — work-item contracts, added later in Phase 0.

## Phase 0 operating model

1. Define or update the project in `docs/project.md`.
2. Write a design document when the change needs design work.
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

The first testbed is `live-draft-tool-v2`.
