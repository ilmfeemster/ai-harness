# Phase 0.7 - Add project-start instructions

> **Project operational state:** This file is the active execution package for the AI Development Harness project. Reusable slice structure belongs in `templates/docs/current-slice.md`; this file contains only the current harness work item.

## Status

Ready

Implementation is not authorized. Human approval is required before changing this slice to `Approved`.

## Source Issue

- **Issue:** #4 - Phase 0.7 - Add project-start instructions
- **URL:** https://github.com/ilmfeemster/ai-harness/issues/4

## Context

The harness source repository contains both reusable workflow assets and the real project context used to develop the harness. New projects must not be created by copying this repository byte for byte, because that would carry over harness-specific scope, roadmap, architecture, decisions, Issues, and active implementation state.

The updated workflow constitution makes repeatable procedures subordinate to `AGENTS.md` and places them in dedicated `skills/*/SKILL.md` files. Project initialization therefore needs a reusable human-operated skill, clean project-document scaffolds, and deterministic checks that make source-context leakage visible without becoming a hosted generator.

## Goal

Define a reliable process for starting a new project with reusable workflow assets and clean project-document scaffolds without inheriting AI Development Harness context.

## Scope

- Define which assets are copied nearly verbatim.
- Define which document paths are initialized from clean scaffolds.
- Define which source-repository artifacts are excluded.
- Define the minimum project information needed during initialization.
- Define how Issue forms are installed.
- Define how project documents are checked for source-context leakage.
- Provide straightforward human-readable startup instructions.

## Non-goals

- Do not support every project type.
- Do not build a hosted project generator.
- Do not introduce a central project registry.
- Do not automatically synchronize existing projects.

## Acceptance criteria

- A new repository can be initialized without copying harness-specific scope, roadmap, architecture, decisions, Issues, or active slice content.
- Reusable workflow assets are preserved.
- Clean scaffolds exist for project-owned documents.
- The startup process is testable and understandable.
- The initialized project remains self-contained.

## Implementation plan

1. Define the initialization boundary from `AGENTS.md`, `README.md`, `docs/architecture.md`, and the existing reusable assets. Separate assets copied nearly verbatim from project-owned paths that must be initialized with new content.
2. Add the reusable `skills/start-project/SKILL.md` procedure. It must define required and optional project inputs, target-repository preconditions, copied assets, initialized paths, excluded source artifacts, Issue-form installation, leakage checks, expected outputs, prohibited side effects, stop conditions, and handoffs to validation and review skills.
3. Add neutral scaffolds for `README.md`, `docs/project.md`, `docs/roadmap.md`, `docs/architecture.md`, `docs/decisions.md`, `docs/testing.md`, and a reusable design document. Keep all scaffolds free of harness-specific scope, phase, Issue, decision, architecture, and completion state.
4. Define clean initialization of `docs/current-slice.md`: do not copy the harness active slice or unresolved template placeholders into a new project; create an empty project-owned active-slice file until a Ready Issue is promoted.
5. Register the project-start operation in `AGENTS.md` and keep detailed startup mechanics in `skills/start-project/SKILL.md` rather than duplicating the procedure in the constitution.
6. Update `README.md` with a human-readable entry point to the startup skill and the expanded reusable-asset/scaffold map. Update `docs/architecture.md` and `docs/testing.md` only where the project-start boundary and its deterministic checks change their current responsibilities.
7. Extend `scripts/validate.ps1` and `tests/validate-structure.ps1` as needed to validate clean scaffolds, obvious source-context leakage, and an intentionally empty `docs/current-slice.md` during initialization. Keep checks local, mechanical, deterministic, and replaceable.
8. Use `skills/implement-slice/SKILL.md` for authorized implementation, `skills/validate-slice/SKILL.md` for formal validation, and `skills/review-slice/SKILL.md` for independent review. Leave this slice `Draft` until human approval.

## Expected files

- `skills/start-project/SKILL.md` - reusable human-operated project-initialization procedure.
- `AGENTS.md` - register the project-initialization skill without duplicating its detailed procedure.
- `README.md` - human-readable startup entry point and repository reuse map.
- `templates/README.md` - neutral project README scaffold.
- `templates/docs/project.md` - neutral current-project scope scaffold.
- `templates/docs/roadmap.md` - neutral future-direction scaffold.
- `templates/docs/architecture.md` - neutral architecture scaffold.
- `templates/docs/decisions.md` - neutral durable-decision scaffold.
- `templates/docs/testing.md` - neutral testing and validation scaffold.
- `templates/docs/design.md` - neutral detailed-design scaffold for project capabilities.
- `scripts/validate.ps1` - checks for clean scaffolds, source-context leakage, and an empty initialization slice where applicable.
- `tests/validate-structure.ps1` - deterministic initialization and leakage test cases.
- `docs/architecture.md` - current project-start and reusable-asset boundary.
- `docs/testing.md` - initialization validation standards and evidence expectations.
- `docs/current-slice.md` - this project-owned execution package and later completion evidence.

Do not add a hosted generator, central registry, synchronization service, automatic Git operations, model invocation, or unrelated project tooling. Do not copy current harness project documents into the new scaffolds.

## Validation plan

Run from the repository root after implementation:

```powershell
powershell -NoProfile -File scripts/validate.ps1
powershell -NoProfile -File tests/validate-structure.ps1
git diff --check
git status --short
```

Manual checks:

- Follow `skills/start-project/SKILL.md` against a temporary clean target repository and confirm the procedure is understandable without hidden context.
- Confirm reusable assets are preserved: `AGENTS.md`, `skills/`, `.github/ISSUE_TEMPLATE/`, local validation scripts/tests, and neutral templates.
- Confirm project-owned documents are initialized from neutral scaffolds rather than copied from the harness: README, project, roadmap, architecture, decisions, testing, design, and empty current slice.
- Confirm the initialized project contains no harness-specific scope, roadmap, architecture, decisions, Issue URLs, active slice state, or implementation history.
- Confirm Issue forms are installed in the target repository and remain project-owned work-item templates.
- Confirm the validator accepts an intentionally empty `docs/current-slice.md` before the first Issue is promoted, while still validating any non-empty active slice.
- Confirm the process does not overwrite an existing project or synchronize changes automatically.

Formal validation must follow `skills/validate-slice/SKILL.md`; it owns completion evidence and the transition to `Ready for review`. Independent review must follow `skills/review-slice/SKILL.md` and must not close Issue #4 or set this slice to `Complete`.

## Failure conditions

Stop and revise before implementation or approval if:

- the source Issue outcome, scope, non-goals, or acceptance criteria would need to change;
- the startup procedure remains embedded primarily in `AGENTS.md` instead of the dedicated project-start skill;
- reusable assets are omitted, copied with project state, or changed without a workflow reason;
- any neutral scaffold contains AI Development Harness scope, phase, roadmap, architecture, decisions, Issue URLs, active-slice state, or completion evidence;
- initialization copies the harness `docs/current-slice.md` content or leaves unresolved scaffold placeholders in the new active-slice path;
- the minimum project information is insufficient to populate project-owned documents without guessing;
- Issue forms are not installed or are coupled to the harness backlog;
- leakage checks are manual-only when a deterministic local check is practical;
- the validator cannot distinguish a clean empty current slice from a malformed non-empty slice;
- the process overwrites existing project content, synchronizes projects automatically, or introduces a hosted generator or central registry;
- changes add unrelated automation or conflict with the project scope, architecture, decisions, testing standards, or skill contracts.

## Review checklist

- Does the project-start skill define required and optional inputs, outputs, prohibited side effects, and stop conditions?
- Does it clearly separate copied reusable assets from initialized project-owned documents?
- Are all project-owned scaffolds neutral and free of harness-specific active state?
- Is the initial `docs/current-slice.md` state empty and safe until a Ready Issue is promoted?
- Are the minimum project information and target-repository preconditions explicit enough to avoid guessing?
- Are Issue forms installed without copying the harness backlog or Issue state?
- Can the startup process be followed and checked by a human without a generator or hidden service?
- Do deterministic checks cover scaffold leakage, initialized-document leakage, and the empty-versus-malformed current-slice distinction?
- Does `AGENTS.md` register the skill without duplicating its procedure or changing unrelated authority?
- Do README, architecture, and testing updates preserve self-containment and the distinction between mechanics and project intelligence?
- Did implementation, formal validation, and independent review use their dedicated skills without silently advancing lifecycle state?
- Does the result meet every Issue #4 acceptance criterion without synchronization, registry, or hosted-generator behavior?

## Completion evidence

**Implementation status:** Pending human approval and implementation.

**Acceptance-criteria status:** Pending implementation and formal validation.

**Files changed:** Pending.

**Validation results:** Not run. The commands above apply after this slice is approved and implemented.

**Manual checks:** Pending implementation, formal validation, and independent review.

**Implementation adjustments or deviations:** None.

**Known limitations or follow-up Issues:** None identified at slice preparation. New project types, synchronization, and automation beyond this bounded process remain out of scope.

**Implementation summary:** Prepared a bounded Draft execution package for Issue #4. No implementation has begun.

## Dependencies and assumptions

- Phase 0.6 local validation is complete and provides a local validator/test path to extend.
- The updated `AGENTS.md` is authoritative for skill invocation and lifecycle boundaries.
- The project-start procedure is a reusable human-operated skill, not an automatic generator.
- No linked design document was identified for Issue #4.
- A new project target is empty or explicitly designated for initialization; existing-project synchronization is not supported.
- Human approval is required before implementation begins.

## Relevant project documents

- `AGENTS.md`
- `README.md`
- `docs/project.md`
- `docs/architecture.md`
- `docs/decisions.md`
- `docs/testing.md`

## Implementation constraints

- Follow `skills/implement-slice/SKILL.md` for authorized implementation and leave this slice `In progress` afterward.
- Follow `skills/validate-slice/SKILL.md` for formal validation; do not set `Ready for review` during implementation.
- Follow `skills/review-slice/SKILL.md` for independent review; do not close Issue #4 or set this slice `Complete` during review.
- Keep detailed initialization mechanics in `skills/start-project/SKILL.md`; keep `AGENTS.md` limited to authority, invariants, and skill registration.
- Reuse the existing `templates/docs/current-slice.md` as a schema source, but initialize a new project's active slice as empty until promotion.
