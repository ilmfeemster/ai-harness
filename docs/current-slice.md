# Current Slice

## Harness Phase 0.1 — Establish the Harness Repository

**Status:** In progress

## Source

Initial repository bootstrap. This slice predates the Phase 0 GitHub Issue workflow that will be introduced in a later slice.

## Context

The harness repository is empty. The existing `live-draft-tool-v2` repository already demonstrates a useful document-driven workflow, but the reusable template needs its own project-neutral constitution and core documents.

The harness is a template for starting self-contained projects. It is not a central controller for other repositories.

## Goal

Create the minimum durable documentation foundation required to develop Phase 0 through the same bounded workflow the harness is intended to provide.

## Scope

- Add a repository README.
- Add the root `AGENTS.md`.
- Add `docs/project.md`.
- Add `docs/roadmap.md`.
- Add `docs/architecture.md`.
- Add `docs/decisions.md`.
- Add `docs/testing.md`.
- Add this `docs/current-slice.md`.
- Establish the template-first architecture and Phase 0 boundaries.
- Record the remaining Phase 0 slices.

## Non-goals

- Do not add application code.
- Do not add a CLI.
- Do not add GitHub Issue templates yet.
- Do not add automated model invocation.
- Do not add implementation, evaluation, or repair loops.
- Do not create a central project registry.
- Do not migrate `live-draft-tool-v2` yet.
- Do not design generic abstractions beyond current needs.

## Implementation steps

1. Create the root README with the project purpose and Phase 0 workflow.
2. Create `AGENTS.md` with instruction hierarchy, selective loading, work modes, implementation rules, and approval boundaries.
3. Define current scope and success criteria in `docs/project.md`.
4. Define the maturity phases and Phase 0 slice order in `docs/roadmap.md`.
5. Define the template-first architecture in `docs/architecture.md`.
6. Record the initial durable decisions in `docs/decisions.md`.
7. Define Phase 0 testing, validation, and review expectations in `docs/testing.md`.
8. Review the documents together for contradictions and unnecessary duplication.

## Expected files

- `README.md`
- `AGENTS.md`
- `docs/project.md`
- `docs/roadmap.md`
- `docs/architecture.md`
- `docs/decisions.md`
- `docs/testing.md`
- `docs/current-slice.md`

## Validation commands

Phase 0.1 has no code-level test suite yet.

Perform:

```bash
git diff --check
```

And manually verify:

- every expected file exists;
- the harness is consistently described as a project template;
- Harness Phase 0 is distinct from an integrated project's product phase;
- GitHub Issues are identified as the future work queue;
- `current-slice.md` remains the execution package;
- no document claims that automation already exists;
- the roadmap and project scope agree.

## Acceptance criteria

- The repository has a clear purpose and operating model.
- `AGENTS.md` can govern future harness development.
- Phase 0 is defined as a usable manual workflow.
- The template-first architecture is explicit.
- The roadmap contains incremental Phase 0 slices and later maturity phases.
- Validation and review are clearly distinguished.
- The documents do not introduce a central cross-repository controller.
- The next slice can be planned without reconstructing project context.

## Failure conditions

Stop and revise if:

- project-specific fantasy-football logic is copied into the template;
- the documents imply Phase 0 is autonomous;
- responsibilities between Issues and `current-slice.md` are unclear;
- the roadmap requires unproven abstractions;
- the harness and target-project phase systems are conflated.

## Review checklist

- Is the template immediately understandable to a new project owner?
- Is the workflow at least directionally equivalent to the proven current workflow?
- Are later automation phases built on Phase 0 rather than replacements for it?
- Are human approval boundaries explicit?
- Is the next slice, Phase 0.2, clearly motivated?

## Completion notes

Pending repository application and review.
