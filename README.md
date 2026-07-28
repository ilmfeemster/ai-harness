# AI Development Harness

An opinionated, document-driven starting point for high-quality AI-assisted software development.

This repository has two roles:

1. it is the project in which the harness is designed and tested; and
2. it is the source from which reusable workflow assets and clean project-document scaffolds will be packaged.

It is not a central controller for other repositories.

## Core objective

Project intelligence lives primarily in durable documents, not repeated prompts.

The harness progressively moves reasoning upstream, preserves it in inspectable artifacts, and makes downstream execution more deterministic without removing meaningful human control.

```text
project scope
↓
architecture, decisions, and design when needed
↓
GitHub Issue
↓
decision-complete current-slice.md
↓
implementation
↓
validation and independent review
↓
human approval
```

Not every change requires every layer.

## Template reuse model

### Copied as reusable workflow

- `AGENTS.md`;
- `skills/`;
- `.github/ISSUE_TEMPLATE/`;
- neutral scaffolds under `templates/`;
- reusable workflow scripts and validators.

### Created from scaffolds and filled with project context

- `README.md`;
- `docs/project.md`;
- `docs/roadmap.md`;
- `docs/architecture.md`;
- `docs/decisions.md`;
- `docs/testing.md`;
- `docs/design/`;
- `docs/context-manifests/`;
- `docs/current-slice.md`, which starts empty until a Ready Issue is promoted.

Current project contents must not be copied into unrelated projects.

## Current maturity

**Harness Phase 1 — Context and slice assistance, in progress**

The complete Phase 0 workflow remains usable and human-operated. Phase 1 is adding a local preparation path that can normalize one explicit Ready Issue, assemble bounded context, produce an inspectable manifest, and generate a guarded Draft slice. The integrated path is invoked manually for one explicit Issue from the repository root.

Implementation, validation, review, approval, and finalization remain separately invoked operations.

## Repository map

- `AGENTS.md` — reusable workflow constitution and authority model.
- `skills/` — one procedure per authorized workflow operation.
- `.github/ISSUE_TEMPLATE/` — reusable implementation and bug contracts.
- `templates/` — neutral project-document and slice scaffolds.
- `scripts/validate.ps1` — structural and lifecycle-consistency validation.
- `tests/validate-structure.ps1` — deterministic validator tests.
- `scripts/prepare-slice.ps1` — Phase 1 local preparation entry point and integrated workflow.
- `tests/prepare-slice.ps1` — deterministic preparation-tool tests.
- `docs/project.md` — current product and Phase 1 state.
- `docs/roadmap.md` — future maturity direction.
- `docs/architecture.md` — current architecture and preserved boundaries.
- `docs/decisions.md` — durable decisions.
- `docs/testing.md` — confidence standards.
- `docs/design/` — approved detailed designs.
- `docs/issues/` — phase plans and retained Issue-draft traceability.
- `docs/context-manifests/` — per-Issue preparation traceability when produced.
- `docs/current-slice.md` — the one active execution package.

## Phase 1 manual preparation

Run the integrated workflow from the repository root for one explicit Ready GitHub Issue:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/prepare-slice.ps1 -PrepareDraftSlice -IssueNumber 11
```

The GitHub CLI must be installed, authenticated, and able to read the selected Issue and its completed dependencies. The command does not select Issues, batch work, or change GitHub state. When all guards pass, it writes `docs/context-manifests/<issue-number>.md` and a status-`Draft` `docs/current-slice.md`. The JSON result identifies the stage, fixed artifact paths, and sanitized blockers. A blocked run preserves an unresolved active slice and updates only the matching manifest when its identity is safely known; source-read or parser failures write neither artifact.

Review the manifest and Draft manually. The Draft is not approval or implementation authorization: use the separate slice-approval operation, then separately authorize implementation according to `AGENTS.md`.

## Starting a new project

Use `skills/start-project/SKILL.md`. It separates reusable mechanics from project-owned context, initializes clean scaffolds, installs Issue forms, and creates an empty active slice.

```powershell
powershell -NoProfile -File scripts/validate.ps1 -InitializedProject -CleanInitialization
powershell -NoProfile -File tests/validate-structure.ps1
```

Initialization does not copy this repository's project context, promote work, or begin implementation.

## Current operating model

1. Maintain project state in `docs/project.md`.
2. Update architecture, decisions, or design only when required.
3. Create bounded work through GitHub Issues.
4. Prepare exactly one Ready Issue into a complete Draft slice.
5. Review and explicitly approve the slice.
6. Separately authorize implementation.
7. Run formal validation.
8. Review independently.
9. Explicitly approve the completed result.
10. Finalize and close the Issue.
11. Do not automatically begin the next Issue.

## Current non-goals

- Automatic Issue selection.
- Automatic implementation or repair.
- Multi-agent coordination.
- Cross-repository control.
- Hosted orchestration.
- Generic abstractions not proven through use.

The first external integration testbed is `live-draft-tool-v2`.
