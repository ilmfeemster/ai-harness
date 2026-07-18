# Current Slice

> **Project operational state:** The reusable template may provide this document's schema, but every project must initialize its own active slice. This content tracks AI Development Harness work only.

## Harness Phase 0.3 — Define the GitHub Issue Workflow

**Status:** Complete — awaiting human approval

## Source

`docs/bootstrap-tasks.md` — Phase 0.3, migrated during completion.

This was the final harness work item promoted from the temporary bootstrap queue. The remaining Phase 0 work is now represented by project-specific GitHub Issues.

## Context

Phase 0.2 established which workflow assets are reusable and which files contain project context. The repository still lacked the actual GitHub Issue contract needed to replace `tasks.md` and retire the temporary bootstrap queue.

The Issue workflow must preserve the same boundary:

- Issue forms are reusable workflow assets;
- submitted Issues are project-specific work state;
- Issues define required outcomes;
- `current-slice.md` defines detailed execution;
- labels must not become hidden workflow authority.

## Goal

Establish a lightweight, reusable GitHub Issue workflow that can represent ready work, promote exactly one Issue into an execution slice, and transfer the remaining harness work out of `docs/bootstrap-tasks.md`.

## Scope

- Add one reusable implementation-work Issue form.
- Add one reusable bug Issue form.
- Disable blank Issues.
- Define the required Issue contract.
- Define readiness, promotion, active-work, and completion rules.
- Define the boundary between Issue outcome and slice execution detail.
- Define a minimal label policy.
- Update the roadmap to reflect reusable forms versus project-specific Issues.
- Update architecture, decisions, testing, and README where the Issue workflow affects their concerns.
- Create project-specific Issues for Harness Phases 0.4 through 0.10.
- Delete `docs/bootstrap-tasks.md` only after all remaining work is represented by Issues.

## Non-goals

- Do not automate Issue selection.
- Do not automate slice generation.
- Do not finalize the complete reusable slice schema.
- Do not add custom required labels.
- Do not add milestones, projects, or complex triage automation.
- Do not create a generic Issue taxonomy for every possible project.
- Do not add validation scripts or a CLI.
- Do not start Phase 0.4.

## Implemented Issue contract

Every ready implementation Issue now makes these concerns explicit:

- work type;
- goal;
- context;
- included scope;
- non-goals;
- acceptance criteria;
- dependencies;
- relevant project documents;
- readiness confirmation.

The bug form additionally requires observed behavior, expected behavior, reproduction or evidence, and impact.

## Lifecycle

```text
Draft Issue
↓
Ready Issue
↓
approved current-slice.md
↓
implementation
↓
validation + review
↓
human approval
↓
Issue closure
```

Only one Issue may be active through `docs/current-slice.md` at a time.

## Label policy

Phase 0 requires no custom labels.

Labels may classify work, but they do not define readiness or active state:

- readiness is established by the Issue contract;
- active state is established by the approved current slice;
- completion is established by approval and Issue closure.

## Implementation steps

1. Verified the roadmap against the reusable-asset versus project-context model.
2. Refined the Phase 0.3, 0.4, 0.6, and 0.7 roadmap wording without changing phase architecture.
3. Added `.github/ISSUE_TEMPLATE/implementation.yml`.
4. Added `.github/ISSUE_TEMPLATE/bug.yml`.
5. Added `.github/ISSUE_TEMPLATE/config.yml` with blank Issues disabled.
6. Expanded `AGENTS.md` with the Issue contract, lifecycle, readiness, promotion, scope-change, and closure rules.
7. Updated harness architecture to separate reusable forms from project-specific submitted Issues.
8. Recorded durable decisions for readiness, labels, and the Issue-to-slice boundary.
9. Added Issue-workflow checks to the harness testing strategy.
10. Updated the README operating model and repository map.
11. Created project-specific GitHub Issues for Phases 0.4 through 0.10.
12. Deleted the temporary bootstrap queue after successful Issue migration.

## Expected files changed

- `AGENTS.md`
- `README.md`
- `.github/ISSUE_TEMPLATE/config.yml`
- `.github/ISSUE_TEMPLATE/implementation.yml`
- `.github/ISSUE_TEMPLATE/bug.yml`
- `docs/roadmap.md`
- `docs/architecture.md`
- `docs/decisions.md`
- `docs/testing.md`
- `docs/current-slice.md`
- `docs/bootstrap-tasks.md` — deleted after migration

## Validation commands

Run:

```bash
git diff --check
git status --short
gh issue list --state open --limit 20
```

Manual checks:

- Issue forms are reusable and contain no harness backlog content;
- submitted Phase 0 Issues are project-specific;
- blank Issues are disabled;
- required fields cover goal, context, scope, non-goals, acceptance criteria, dependencies, documents, and readiness;
- bug reports also cover observed behavior, expected behavior, reproduction or evidence, and impact;
- no custom label is required to determine readiness;
- one Issue can be promoted without copying the entire backlog into `current-slice.md`;
- material outcome changes require an Issue update and slice reapproval;
- all remaining Phase 0 slices exist as open Issues;
- Phase 0.4 is ready, while later Issues remain draft until their dependencies are complete;
- `docs/bootstrap-tasks.md` no longer exists;
- Phase 0.4 has not been promoted or started.

## Validation results

- Roadmap reuse-boundary review: Passed.
- Reusable-form versus project-Issue review: Passed.
- Issue-to-slice authority review: Passed.
- Required-field review: Passed.
- Minimal-label review: Passed.
- Packaged YAML parse validation: Passed.
- Packaged repository whitespace validation: Passed.
- GitHub migration is performed by the included idempotent application script before repository files are finalized.

## Acceptance criteria

- Reusable Issue forms exist for planned implementation work and bugs.
- Blank Issues are disabled.
- A ready Issue has an explicit, reviewable contract.
- Readiness does not depend on custom labels.
- Issue outcome and slice execution responsibilities are distinct.
- Promotion, scope-change, completion, and closure behavior are explicit.
- The roadmap remains compatible with the reusable-versus-project-context model.
- Remaining harness work is represented by project-specific GitHub Issues.
- The bootstrap queue is safely removed only after migration.
- The workflow remains lightweight enough for a solo developer.
- Phase 0.4 is ready but not started.

## Failure conditions

Revise before approval if:

- Issue forms contain harness-specific backlog items;
- submitted Issues are treated as reusable template content;
- readiness depends on an unavailable custom label;
- the Issue duplicates the entire execution slice;
- the slice may silently change the approved Issue outcome;
- multiple Issues are treated as active simultaneously;
- the bootstrap queue is deleted before all remaining tasks become Issues;
- the work drifts into slice automation or implementation execution.

## Review checklist

- Are the two forms sufficient without creating unnecessary Issue types?
- Can readiness be determined by reading the Issue alone?
- Is the Issue useful to a human while remaining easy for an agent to parse later?
- Is the boundary between outcome and execution precise?
- Does the label policy avoid hidden repository configuration?
- Does the migration preserve every remaining Phase 0 task?
- Is the workflow reusable across projects without carrying harness context?

## Completion notes

Phase 0.3 establishes GitHub Issues as the authoritative harness work queue.

The reusable asset is the Issue contract and its forms. The actual Phase 0.4 through 0.10 Issues are AI Development Harness project state and must not be copied into future projects.

The temporary bootstrap queue was retained until Issue creation succeeded, then removed. Phase 0.4 is the next ready Issue but remains unpromoted pending human approval of this slice. Later Phase 0 Issues remain draft until their dependencies are complete.
