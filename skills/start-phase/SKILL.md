# Start Phase

## Purpose

Activate one roadmap phase by translating its future-state definition into current project state in `docs/project.md` and recording whether a detailed design is required before phase work can be divided into Issues.

This operation is the bridge:

```text
docs/roadmap.md
→ docs/project.md
```

It does not create a design, draft Issues, publish GitHub Issues, prepare a current slice, or implement code.

## When to use

Use this skill when asked to:

- start, activate, promote, or move into a roadmap phase;
- begin the next roadmap phase;
- update the project file for a selected phase;
- determine whether the selected phase requires a design before Issue planning.

## Do not use when

Do not use this skill to:

- rewrite the roadmap merely to match current implementation;
- create the phase design;
- break the phase into Issue drafts;
- publish GitHub Issues;
- promote an Issue into `docs/current-slice.md`;
- implement the phase;
- declare the previous phase complete without evidence or human direction.

Use `skills/plan-change/SKILL.md` for a required design, `skills/plan-phase-work/SKILL.md` for the Issue breakdown, and `skills/publish-issues/SKILL.md` for publication.

## Authority and boundaries

Read and obey `AGENTS.md` before using this skill.

`docs/roadmap.md` governs the selected future phase outcome, capabilities, sequencing, and stated non-goals.

`docs/project.md` governs current project state. This skill may update it only because the user has explicitly asked to activate a phase.

Do not silently change:

- the roadmap phase outcome;
- current architecture;
- durable decisions;
- existing product principles;
- testing standards;
- already completed phase history.

Do not begin another lifecycle operation merely because phase activation succeeds.

## Required inputs

Require:

- a selected roadmap phase, or an explicit request to activate the next phase;
- authorization to update `docs/project.md`;
- evidence or human confirmation that the previous phase is complete, unless overlapping phase planning is explicitly authorized;
- enough current repository context to distinguish existing capability from planned capability.

## Required context

Load in this order:

1. `AGENTS.md`;
2. this skill;
3. `docs/roadmap.md`;
4. `docs/project.md`;
5. `docs/architecture.md`;
6. relevant entries in `docs/decisions.md`;
7. `docs/testing.md`;
8. relevant completed designs;
9. the current `docs/current-slice.md` only to determine whether unresolved execution state affects phase activation.

Inspect code or tests only when needed to determine whether a claimed current capability or phase-completion condition is real.

## Preconditions

Before modifying `docs/project.md`, verify:

- the selected phase exists in the roadmap;
- the selected phase is the intended next phase, or the user explicitly authorizes different sequencing;
- the previous phase is complete or overlap is explicitly authorized;
- there is no authoritative conflict that makes the selected phase impossible to state accurately;
- phase activation will not falsely claim that planned capabilities already exist.

An unresolved current slice does not always prevent planning the next phase, but the agent must not imply that phase activation authorizes a second active implementation effort.

## Design-requirement assessment

Record one of:

- `Required`;
- `Not required`;
- `Blocked`.

A design is normally `Required` when the phase introduces one or more of:

- new architecture or dependency direction;
- new workflow states or lifecycle transitions;
- important interfaces, schemas, protocols, or data contracts;
- shared behavior that several Issues must implement consistently;
- security, migration, persistence, recovery, or failure-handling decisions;
- meaningful alternatives or tradeoffs that must be decided once;
- acceptance behavior that cannot be made precise from the roadmap and current project documents alone.

A design may be `Not required` when:

- the phase outcome and behavior are already sufficiently decided;
- architecture and durable decisions remain unchanged;
- each Issue can be made singular and evaluable without inventing a shared contract;
- the work is straightforward for the project's current maturity.

Use `Blocked` when the assessment itself depends on an unresolved product, architecture, or sequencing decision.

When design is required, identify a project-specific expected path such as:

```text
docs/design/<phase-slug>.md
```

Do not create that design during this operation unless the user separately authorizes the `plan-change` operation.

## Procedure

1. Identify the selected roadmap phase.
2. Verify its sequence and the previous phase's status.
3. Extract the phase's:
   - name;
   - outcome;
   - capabilities;
   - explicit non-goals;
   - dependencies;
   - sequencing implications.
4. Compare that future definition with current project state, architecture, decisions, testing standards, and completed work.
5. Separate:
   - capability already present;
   - capability the new phase must add;
   - future capability that remains deferred.
6. Determine the design requirement using the criteria above.
7. Update `docs/project.md` so it accurately records:
   - current phase;
   - current phase goal;
   - current capabilities or included scope;
   - explicit non-goals;
   - preserved constraints and existing behavior;
   - dependencies and unresolved questions;
   - observable exit criteria;
   - design requirement;
   - design-assessment reason;
   - expected design path when required;
   - Issue-planning status: `Not started`;
   - GitHub-publication status: `Not started`.
8. Preserve the product vision, target user, principles, and other durable current-project information unless the selected phase genuinely changes them.
9. Do not copy the roadmap section verbatim when project-specific clarification is needed.
10. Check that `docs/project.md` describes current intended work rather than claiming planned capabilities are implemented.
11. Report the design decision and the next authorized handoff.
12. Stop.

## Recommended `docs/project.md` phase sections

Use the project's existing structure where possible. Ensure the equivalent of these sections is present:

```markdown
## Current phase

## Current phase goal

## Current capabilities and scope

## Current phase non-goals

## Constraints and preserved behavior

## Dependencies and open questions

## Current phase exit criteria

## Phase preparation

- **Design requirement:** Required | Not required | Blocked
- **Design basis:** ...
- **Expected design:** `docs/design/...` | None
- **Issue planning:** Not started
- **GitHub publication:** Not started
```

Do not force duplicate headings when the same concern is already represented clearly.

## Validation

Before completing, verify:

- the selected phase exists in the roadmap;
- `docs/project.md` names the selected phase accurately;
- the goal and scope are compatible with the roadmap;
- existing capabilities are not presented as new work;
- planned capabilities are not presented as implemented behavior;
- non-goals prevent obvious phase expansion;
- exit criteria are observable enough to support later Issue coverage;
- the design assessment has a stated basis;
- required design work has an expected path;
- Issue planning and publication remain `Not started`;
- no design, Issue draft, GitHub Issue, slice, or implementation was created.

## Required outputs

Provide:

- the updated `docs/project.md`;
- the selected roadmap phase;
- the previous-phase completion or overlap basis;
- the design requirement and reasoning;
- the expected design path when required;
- unresolved blockers or questions;
- the next authorized operation:
  - `plan-change` for required design;
  - `plan-phase-work` when no design is required or an approved design already exists.

## Failure and escalation behavior

Stop without activating the phase when:

- the requested phase does not exist;
- sequence is ambiguous and the user did not select a phase;
- the previous phase is not complete and overlap is not authorized;
- the roadmap and current project state materially conflict;
- the phase outcome cannot be translated without inventing product requirements;
- a required current document is missing;
- the design assessment is blocked by an unresolved decision.

Return a phase-readiness report instead of guessing.

## Completion conditions

This skill is complete when:

- one roadmap phase is accurately represented as the current phase in `docs/project.md`;
- the phase's goal, scope, non-goals, constraints, dependencies, and exit criteria are current;
- the design requirement is explicit and justified;
- downstream planning statuses are initialized accurately;
- no design, Issue draft, GitHub Issue, current slice, or implementation was created.
