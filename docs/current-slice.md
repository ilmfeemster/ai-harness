# Current Slice

> **Project operational state:** This file is the active execution package for the AI Development Harness project. Reusable slice structure belongs in a separate scaffold; this file must always contain only the currently promoted harness work item.

## Harness Phase 0.4 — Define the Slice Standard

**Status:** Draft — Approved

## Source Issue

- **Issue:** #1 — Phase 0.4 - Define the slice standard
- **URL:** https://github.com/ilmfeemster/ai-harness/issues/1

## Context

Phase 0.2 separated reusable workflow assets from project-owned context. Phase 0.3 established GitHub Issues as the authoritative project work queue and defined promotion as the deliberate translation of one ready Issue into one bounded execution package.

The remaining ambiguity is the slice contract itself. `AGENTS.md` lists the current expected contents, but the repository does not yet define:

- a final required-versus-optional section model;
- unambiguous status values and approval transitions;
- a clean reusable scaffold separate from the harness's active work state;
- the evidence required when implementation is ready for review;
- how execution refinements are recorded without changing the Issue outcome.

This slice must finalize that contract without automating promotion or implementation.

## Goal

Finalize the reusable `docs/current-slice.md` schema while ensuring every active slice remains project-specific operational state.

## Dependencies and readiness

- Phase 0.3 GitHub Issue workflow is complete.
- Issue #1 has all readiness items checked.
- No unresolved product or architecture decision blocks this work.
- The work is bounded to one documentation-focused implementation slice.

## Relevant project documents

Read and preserve:

- `AGENTS.md`
- `README.md`
- `docs/project.md`
- `docs/roadmap.md`
- `docs/architecture.md`
- `docs/decisions.md`
- `docs/testing.md`
- GitHub Issue #1

`docs/project.md` and `docs/roadmap.md` should not require substantive changes because this slice does not change current project scope or future phase sequencing.

## Scope

- Define the final required sections for every active slice.
- Define optional sections that may be included when relevant.
- Define source-Issue linkage and traceability requirements.
- Define allowed slice status values and the transitions controlled by human approval.
- Define the boundary between Issue outcome and slice execution detail.
- Define how execution-only refinements and material outcome changes are handled.
- Define the validation and completion evidence required before review.
- Add a clean reusable slice scaffold that contains no harness-specific active state.
- Update repository documentation where the finalized slice contract changes an existing responsibility, architecture statement, durable decision, repository map, or testing rule.

## Non-goals

- Do not automate Issue selection or slice generation.
- Do not implement validation scripts.
- Do not invoke an implementation agent automatically.
- Do not define repair or independent evaluation loops.
- Do not define the complete Phase 0.7 project-initialization procedure.
- Do not redesign the GitHub Issue forms or lifecycle.
- Do not add required labels, milestones, projects, or external workflow state.
- Do not begin Phase 0.5.
- Do not generalize the schema beyond demonstrated software-development workflow needs.

## Target slice contract

Implement the following contract unless repository evidence reveals a direct contradiction that must be reported before proceeding.

### Required active-slice contents

Every active `docs/current-slice.md` must contain:

1. Work-item title.
2. Status.
3. Source Issue number, title, and URL.
4. Context.
5. Goal.
6. Scope.
7. Non-goals.
8. Acceptance criteria.
9. Implementation plan.
10. Expected files.
11. Validation plan.
12. Failure conditions.
13. Review checklist.
14. Completion evidence.

A required section may state that evidence is pending while the slice is not yet at that lifecycle stage. Required sections must not be silently omitted.

### Optional active-slice contents

Include these only when they add useful execution context:

- dependencies and assumptions;
- relevant project documents;
- linked design documents;
- implementation constraints;
- implementation adjustments;
- blockers and known limitations;
- rollback or migration notes.

Optional sections must not duplicate large amounts of upstream documentation.

### Allowed status values

Use only these conceptual states:

1. **Draft** — the Issue has been translated into a candidate slice, but implementation is not authorized.
2. **Approved** — a human has approved the slice; the source Issue is now the single active work item and implementation may begin.
3. **In progress** — implementation has begun within the approved boundaries.
4. **Blocked** — implementation cannot continue without resolving a stated dependency, conflict, or decision.
5. **Ready for review** — implementation and declared validation are complete, completion evidence is recorded, and human review is required.
6. **Complete** — the result has received human approval and the source Issue has been closed.

Do not use a contradictory state such as `Complete — awaiting human approval`. Work awaiting approval is `Ready for review`.

### Promotion and approval boundaries

Promotion must:

- begin from one ready Issue;
- preserve the Issue's goal, scope, non-goals, and acceptance criteria;
- add implementation detail, expected files, commands, failure conditions, and review checks;
- create a `Draft` slice;
- require explicit human approval before changing the status to `Approved`;
- leave every other Issue unpromoted.

The active slice may refine execution details without changing the approved outcome. Record meaningful execution-only changes under implementation adjustments.

A material change to the required outcome, scope, non-goals, or acceptance criteria requires:

1. updating the source Issue;
2. revising the slice;
3. returning the slice to `Draft`;
4. obtaining human approval again.

Newly discovered out-of-scope work must become a separate Issue.

### Completion evidence

Before a slice becomes `Ready for review`, its completion evidence must report:

- acceptance-criteria status;
- files changed;
- validation commands executed and their results;
- manual checks performed;
- implementation adjustments or deviations;
- blockers, known limitations, or follow-up Issues;
- a concise implementation summary.

The Issue must remain open until the result receives human approval.

## Implementation plan

1. **Finalize the reusable rules in `AGENTS.md`.**
   - Expand the current-slice rules into an explicit required-versus-optional schema.
   - Define the six allowed status values and their approval boundaries.
   - Clarify promotion, implementation adjustment, reapproval, review, completion, and replacement behavior.
   - State that an active approved slice may not contain unresolved scaffold placeholders.
   - Preserve the existing Issue-outcome versus slice-execution authority boundary.

2. **Add a project-neutral reusable scaffold at `templates/docs/current-slice.md`.**
   - Include every required section.
   - Include clearly marked optional sections or guidance without making all optional sections mandatory.
   - Use neutral placeholders rather than AI Development Harness backlog content.
   - Include no Issue number, phase number, completion claim, validation result, or project-specific architecture assumption.
   - Make clear that a generated project receives a fresh project-owned `docs/current-slice.md` initialized from this scaffold.
   - Do not implement the broader project-bootstrap process assigned to Phase 0.7.

3. **Update `docs/architecture.md`.**
   - Identify the reusable scaffold as a workflow/template asset.
   - Preserve `docs/current-slice.md` as project-owned operational state.
   - Clarify that the scaffold and active slice must never be treated as the same substantive content.

4. **Record durable decisions in `docs/decisions.md`.**
   - Record the separation between the reusable slice scaffold and active slice state.
   - Record the status and approval model if it is expected to constrain future workflow tooling.
   - Avoid logging temporary implementation notes as durable decisions.

5. **Update `docs/testing.md`.**
   - Define structural checks for required scaffold sections.
   - Require valid active-slice status values.
   - Require Issue number and URL in promoted slices.
   - Require approved active slices to contain no unresolved scaffold placeholders.
   - Require the reusable scaffold to contain no harness-specific active state.
   - Preserve the distinction between mechanical validation and human review.

6. **Update `README.md`.**
   - Add the reusable scaffold to the repository map and template reuse explanation.
   - Keep the active `docs/current-slice.md` described as project-specific operational state.

7. **Update this active slice during implementation.**
   - Record any execution-only adjustments.
   - Record actual changed files and validation results.
   - Change status to `Ready for review` only after implementation and validation are complete.
   - Do not mark the slice `Complete` or close Issue #1 before human approval.

## Expected files

Expected changes are limited to:

- `AGENTS.md`
- `README.md`
- `templates/docs/current-slice.md` — new reusable scaffold
- `docs/architecture.md`
- `docs/decisions.md`
- `docs/testing.md`
- `docs/current-slice.md` — status, adjustments, validation results, and completion evidence

Do not modify `docs/project.md` or `docs/roadmap.md` unless a genuine contradiction is discovered and reported.

## Validation plan

Run from the repository root:

```powershell
git diff --check
git status --short
```

Confirm the reusable scaffold contains the required headings:

```powershell
$requiredHeadings = @(
    "## Status",
    "## Source Issue",
    "## Context",
    "## Goal",
    "## Scope",
    "## Non-goals",
    "## Acceptance criteria",
    "## Implementation plan",
    "## Expected files",
    "## Validation plan",
    "## Failure conditions",
    "## Review checklist",
    "## Completion evidence"
)

foreach ($heading in $requiredHeadings) {
    if (-not (Select-String -Path "templates/docs/current-slice.md" -SimpleMatch $heading -Quiet)) {
        throw "Missing required scaffold heading: $heading"
    }
}
```

Confirm the reusable scaffold contains no harness-specific active state:

```powershell
$forbidden = "AI Development Harness|Harness Phase 0|Phase 0\.[0-9]+|ilmfeemster/ai-harness/issues/[0-9]+"

if (Select-String -Path "templates/docs/current-slice.md" -Pattern $forbidden -Quiet) {
    throw "Reusable slice scaffold contains harness-specific active state."
}
```

Confirm the governing rules document the lifecycle and traceability contract:

```powershell
$requiredTerms = @(
    "Draft",
    "Approved",
    "In progress",
    "Blocked",
    "Ready for review",
    "Complete",
    "Source Issue",
    "Completion evidence"
)

foreach ($term in $requiredTerms) {
    if (-not (Select-String -Path "AGENTS.md" -SimpleMatch $term -Quiet)) {
        throw "AGENTS.md does not document required slice term: $term"
    }
}
```

Manual checks:

- `templates/docs/current-slice.md` is reusable and project-neutral.
- `docs/current-slice.md` remains harness-specific active state.
- Required and optional sections are clearly distinguishable.
- Promotion creates a Draft rather than implicitly authorizing implementation.
- Only explicit human approval authorizes implementation.
- `Ready for review` and `Complete` are not conflated.
- The source Issue's outcome cannot be silently changed by the slice.
- Execution-only refinements can be recorded without unnecessary Issue edits.
- Material outcome changes require Issue revision and slice reapproval.
- Completion evidence is distinct from planned acceptance criteria and validation commands.
- The contract remains lightweight enough to use manually.
- No Phase 0.5 work or project-bootstrap automation was introduced.

## Acceptance criteria

- The reusable slice schema is explicit and internally consistent.
- Required and optional slice sections are clearly identified.
- Source Issue number, title, and URL are required for traceability.
- Status values and human approval boundaries are unambiguous.
- Promotion, execution refinement, material scope change, review, and completion behavior are explicit.
- The source Issue, acceptance criteria, implementation plan, validation plan, review checks, and completion evidence remain distinguishable.
- A clean reusable scaffold exists without harness-specific active content.
- A project can initialize its own `docs/current-slice.md` from the scaffold without inheriting harness work state.
- `docs/current-slice.md` remains project-specific operational state.
- The slice contract remains compatible with the template-first, project-local architecture.
- The contract is lightweight enough for manual Phase 0 use.
- No automation, validation tooling, repair loop, or Phase 0.5 implementation is added.

## Failure conditions

Stop and revise before implementation or approval if:

- the reusable scaffold contains harness-specific phase, Issue, validation, or completion state;
- the active harness slice is treated as reusable template content;
- promotion itself authorizes implementation without human approval;
- status values allow work awaiting approval to be called complete;
- required sections are omitted or optional sections are made needlessly mandatory;
- the slice is allowed to materially change the source Issue without updating it;
- acceptance criteria, validation plans, review checks, and completion evidence are collapsed into one ambiguous section;
- the scaffold introduces unresolved decisions about the complete Phase 0.7 bootstrap mechanism;
- changes drift into Issue automation, implementation execution, repair, evaluation, or Phase 0.5;
- documentation sources contradict one another about the Issue-to-slice boundary;
- the workflow becomes too ceremonial for one small, reviewable work item.

## Review checklist

- Does the schema contain enough context for an implementation agent to work without repeated clarification?
- Is each required section necessary for bounded execution or review?
- Are optional sections truly optional and useful only when relevant?
- Can a reviewer identify the source Issue and verify that its outcome was preserved?
- Is the difference between `Draft`, `Approved`, `Ready for review`, and `Complete` unmistakable?
- Does only human approval authorize implementation and final completion?
- Can execution details be refined without creating Issue churn?
- Do material outcome changes force Issue revision and slice reapproval?
- Is completion evidence sufficient to evaluate the implementation?
- Is the reusable scaffold free of AI Development Harness project state?
- Does the active slice remain project-owned operational state?
- Does the change preserve project self-containment and avoid premature automation?
- Is the contract simple enough to use manually in the next Phase 0 slices?

## Implementation adjustments

None. Record execution-only refinements here without changing the approved Issue outcome.

## Completion evidence

**Implementation status:** Not started.

**Acceptance-criteria status:** Pending.

**Files changed:** Pending.

**Validation results:** Not run.

**Manual review results:** Pending.

**Known limitations or follow-up work:** None identified. Phase 0.6 remains responsible for automated structural validation, and Phase 0.7 remains responsible for the complete project-start procedure.

**Implementation summary:** Pending.
