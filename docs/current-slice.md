# Phase 0.6 - Add lightweight local validation

> **Project operational state:** This file is the active execution package for the AI Development Harness project. Reusable slice structure belongs in `templates/docs/current-slice.md`; this file contains only the current harness work item.

## Status

Draft

Implementation is not authorized. Human approval is required before changing this slice to `Approved`.

## Source Issue

- **Issue:** #3 - Phase 0.6 - Add lightweight local validation
- **URL:** https://github.com/ilmfeemster/ai-harness/issues/3

## Context

The document, Issue, and slice contracts were defined by Phases 0.2 through 0.5. They now need deterministic local checks for required files, headings, references, commands, placeholders, and reusable-asset versus project-context leakage.

The repository currently has no validator, test harness, or script directory. This slice should add one small, understandable, project-local validation path without introducing a hosted service, model evaluation, repair loop, or general plugin framework.

## Goal

Add understandable local checks that detect structural workflow failures without pretending to provide independent evaluation.

## Scope

- Validate required repository files and directories.
- Validate required current-slice sections.
- Validate Issue-template files and required fields.
- Detect unresolved template placeholders.
- Check referenced local paths where practical.
- Check that declared validation commands are present.
- Check reusable assets for obvious harness-specific active state.
- Add tests for deterministic validator behavior.

## Non-goals

- Do not evaluate implementation quality semantically.
- Do not invoke models.
- Do not run automatic repair.
- Do not create a general plugin framework.

## Acceptance criteria

- One documented local command runs the structural checks.
- Failures are specific and actionable.
- Validator behavior has deterministic tests.
- The checks distinguish mechanical validation from human review.
- The tooling remains small, local, and replaceable.

## Implementation plan

1. Inspect the current repository structure and existing documentation contracts, then establish a small local validator boundary with no new external dependency or framework.
2. Add `scripts/validate.ps1` with deterministic checks for required files and directories, required active-slice headings and traceability, Issue-template files and required fields, unresolved placeholders, practical local references, declared validation commands, and obvious harness-specific active state in reusable assets.
3. Make validator failures specific and actionable, return a non-zero exit code on failure, and provide a concise success result without treating mechanical success as review approval.
4. Add `tests/validate-structure.ps1` with deterministic passing and failing cases for the validator. Tests should exercise representative temporary or fixture repository states, including missing files, missing sections, unresolved placeholders, invalid references, and reusable-asset leakage.
5. Update `docs/testing.md` with the documented structural-validation command, test command, evidence expectations, and the boundary between mechanical validation and human review.
6. Update `docs/architecture.md` only as needed to identify the local validator and deterministic tests as understandable, replaceable workflow mechanics; do not introduce a runtime controller or central service.
7. Use the implementation skill for bounded changes, the validation skill for formal commands and evidence, and the review skill for independent assessment. Leave the slice `Draft` until a human approves it.

## Expected files

- `scripts/validate.ps1` - local structural validator and command entry point.
- `tests/validate-structure.ps1` - deterministic validator tests and representative pass/fail cases.
- `docs/testing.md` - project-wide command and confidence expectations for structural validation.
- `docs/architecture.md` - current local-tooling boundary, only if the validator changes the documented structural model.
- `docs/current-slice.md` - this project-owned execution package and its later completion evidence.

Do not add dependencies, a general plugin framework, a hosted service, model integrations, or automatic repair. Do not modify unrelated project documents.

## Validation plan

Run from the repository root after implementation:

```powershell
powershell -NoProfile -File scripts/validate.ps1
powershell -NoProfile -File tests/validate-structure.ps1
git diff --check
git status --short
```

Manual checks:

- The documented validator command runs locally without network access or model invocation.
- Each required structural check has a specific, actionable failure message.
- Deterministic tests cover both passing and failing repository states.
- The validator checks mechanical structure only and does not claim semantic implementation evaluation.
- Reusable assets are checked for obvious harness-specific active state without treating current project content as reusable template content.
- The expected files and diff remain limited to the Issue outcome.

Formal validation must follow `skills/validate-slice/SKILL.md`; successful validation owns the transition from `In progress` to `Ready for review`. Review must follow `skills/review-slice/SKILL.md` and must not be conflated with validation or human approval.

## Failure conditions

Stop and revise before implementation or approval if:

- the source Issue or its readiness state changes materially;
- the validator requires an external dependency, network access, model invocation, or hosted service to run;
- a structural failure is hidden, downgraded to a warning without justification, or reported without an actionable location or cause;
- the validator hardcodes the current harness state instead of checking reusable contracts and project structure;
- deterministic tests do not exercise representative pass and fail cases;
- the validator evaluates semantic implementation quality or attempts automatic repair;
- the work introduces a general plugin framework, central controller, or unrelated automation;
- changes modify unrelated project documents or exceed the expected file boundary;
- `docs/testing.md` or `docs/architecture.md` would need a material change outside this Issue's outcome;
- validation commands cannot be specified as safe, local, repeatable checks;
- a contradiction appears between the Issue, current project scope, architecture, decisions, testing standards, or this slice.

## Review checklist

- Does one documented local command run all required structural checks?
- Are validator failures specific enough for a contributor to correct the underlying problem?
- Do deterministic tests cover both valid and invalid repository states without relying on network or model behavior?
- Are required files, directories, slice sections, Issue-template fields, placeholders, local references, commands, and reusable-asset leakage covered within scope?
- Does the validator remain mechanical and distinct from semantic evaluation and human review?
- Is the implementation small, local, replaceable, and free of unnecessary dependencies or abstractions?
- Does the result preserve the project self-containment boundary and current architecture?
- Did the implementation and validation follow `skills/implement-slice/SKILL.md` and `skills/validate-slice/SKILL.md`?
- Are review findings handled through `skills/review-slice/SKILL.md` without silently changing lifecycle state?
- Does the result satisfy every Issue #3 acceptance criterion without adding repair, models, or plugin infrastructure?

## Completion evidence

**Implementation status:** Pending human approval and implementation.

**Acceptance-criteria status:** Pending implementation and formal validation.

**Files changed:** Pending.

**Validation results:** Not run. The commands above apply after the slice is approved and implemented.

**Manual checks:** Pending implementation and formal validation.

**Implementation adjustments or deviations:** None.

**Known limitations or follow-up Issues:** None identified at slice preparation. New out-of-scope work must be recorded as a separate Issue rather than added here.

**Implementation summary:** Prepared a bounded Draft execution package for Issue #3. No implementation has begun.

## Dependencies and assumptions

- Phase 0.4 slice standard is complete.
- Phase 0.5 planning modes are complete and documented in `AGENTS.md`.
- The validator can be implemented with the repository's existing local tooling conventions and without adding a dependency.
- No linked design document was identified for Issue #3.
- Human approval is required before implementation begins.

## Relevant project documents

- `AGENTS.md`
- `docs/project.md`
- `docs/architecture.md`
- `docs/decisions.md`
- `docs/testing.md`

## Implementation constraints

- Follow `skills/implement-slice/SKILL.md` for authorized implementation and leave the slice `In progress` afterward.
- Follow `skills/validate-slice/SKILL.md` for formal validation and completion evidence; do not set `Ready for review` during implementation.
- Follow `skills/review-slice/SKILL.md` for independent review; do not close the Issue or set the slice `Complete` during review.
- Keep the command understandable and replaceable for a local Phase 0 workflow.
