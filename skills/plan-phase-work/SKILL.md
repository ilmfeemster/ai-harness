# Plan Phase Work

## Purpose

Convert one active, sufficiently decided project phase into an ordered, reviewable set of local Issue drafts.

This operation is the bridge:

```text
docs/project.md + approved design when required
→ docs/issues/<phase-slug>/
```

It creates local planning artifacts only. It does not publish GitHub Issues, prepare `docs/current-slice.md`, or implement code.

## When to use

Use this skill when asked to:

- break the active phase into Issues;
- build or draft the phase work queue;
- create Issue documents for the current phase;
- prepare a phase's GitHub Issues for review before publication.

## Do not use when

Do not use this skill when:

- the phase has not been activated in `docs/project.md`;
- a required design is missing, unapproved, or blocked;
- the phase outcome is still materially undecided;
- the request is only to create one unrelated work item;
- the request is to publish existing Issue drafts;
- the request is to prepare or implement a current slice.

Use `skills/create-work-item/SKILL.md` for one standalone Issue contract and `skills/publish-issues/SKILL.md` for publication.

## Authority and boundaries

Read and obey:

- `AGENTS.md`;
- this skill;
- `skills/create-work-item/SKILL.md`.

This skill coordinates several proposed work items, but every individual draft must satisfy the one-work-item contract in `create-work-item`.

`docs/project.md` governs the active phase.

An approved design governs shared detailed behavior when one is required.

The phase plan may order work and show coverage. It may not silently change phase scope, architecture, decisions, design, or testing standards.

Do not add full file-level implementation plans. Those belong in `docs/current-slice.md` after one GitHub Issue is promoted.

## Required inputs

Require:

- an active phase in `docs/project.md`;
- the corresponding roadmap phase;
- a design assessment recorded in `docs/project.md`;
- an approved design when the assessment is `Required`;
- a recorded rationale when the assessment is `Not required`;
- authorization to create or replace the local phase plan and Issue-draft files;
- a clear phase slug or permission to derive one from the phase name.

## Required context

Load:

1. `AGENTS.md`;
2. this skill;
3. `skills/create-work-item/SKILL.md`;
4. `docs/project.md`;
5. the corresponding section of `docs/roadmap.md`;
6. the approved design when required;
7. relevant portions of `docs/architecture.md`;
8. relevant entries in `docs/decisions.md`;
9. `docs/testing.md`;
10. existing `docs/issues/<phase-slug>/` content when present.

Inspect code or tests only when needed to:

- confirm current behavior;
- avoid drafting already completed work;
- identify real dependencies;
- make acceptance criteria evaluable.

## Preconditions

Before drafting Issues, verify:

- the roadmap and project files identify the same active phase;
- the phase goal and exit criteria are sufficiently clear;
- the design requirement is not `Blocked`;
- a required design exists and has explicit human approval;
- no open question prevents a bounded work breakdown;
- existing Issue drafts or published Issues will not be overwritten or duplicated silently.

If the directory already contains work, classify it as:

- safe to refine before publication;
- published traceability that must be preserved;
- conflicting or stale work that requires a decision.

## Phase work breakdown rules

The Issue set must be:

- collectively sufficient to achieve the phase exit criteria;
- ordered by real dependencies;
- divided into singular, bounded, independently reviewable outcomes;
- small enough that each Ready Issue can become one current slice;
- free of duplicated outcomes;
- explicit about deferred work;
- compatible with the current project maturity.

Split an outcome when its parts are independently valuable, independently reviewable, or have different dependencies.

Combine work only when separation would create artificial coordination or prevent a meaningful vertical result.

Do not create generic framework work merely because it may be useful in a later phase.

## Procedure

1. Confirm the active phase and derive a stable phase slug, such as `phase-1`.
2. Load or create:

   ```text
   docs/issues/<phase-slug>/
   ```

3. Use `templates/phase-issue-plan.md` to create or update `README.md`.
4. Record in the phase plan:
   - roadmap and project traceability;
   - approved design path or no-design rationale;
   - phase outcome;
   - phase exit criteria;
   - proposed Issue order;
   - dependency graph or dependency notes;
   - capability and exit-criteria coverage;
   - deferred work and non-goals;
   - plan status `Draft`;
   - publication status `Not published`.
5. Identify the smallest coherent Issue sequence that covers the phase.
6. For each proposed Issue:
   - apply `skills/create-work-item/SKILL.md`;
   - use `templates/issue-draft.md`;
   - assign a stable numeric sequence;
   - use a descriptive file slug;
   - state one outcome;
   - include context, scope, non-goals, acceptance criteria, dependencies, and relevant documents;
   - include the approved design where applicable;
   - complete every readiness check with evidence;
   - set `readiness: Ready` only when all readiness conditions are met;
   - leave GitHub Issue number and URL empty.
7. Create filenames such as:

   ```text
   01-discover-local-context.md
   02-parse-ready-issue.md
   03-generate-context-manifest.md
   ```

8. Build a coverage matrix showing which Issue or Issues satisfy every phase capability and exit criterion.
9. Check that no Issue:
   - duplicates another;
   - contains several independently reviewable outcomes;
   - depends on an unresolved design decision;
   - includes later-phase capability;
   - contains the full slice-level file plan.
10. Update `docs/project.md` phase preparation:
    - `Issue planning: Drafted`;
    - leave `GitHub publication: Not started`.
11. Present the ordered breakdown, readiness states, dependencies, and gaps.
12. Stop before publication.

## Phase plan approval

The initial phase plan remains `Draft`.

Human review should evaluate:

- whether the sequence represents the intended phase;
- whether the Issues are sufficiently small and complete;
- whether dependencies are correct;
- whether phase exit criteria are fully covered;
- whether any work should be combined, split, deferred, or removed.

Only explicit human approval may change the phase plan to `Approved`.

Approval of the phase plan does not publish Issues unless publication is also explicitly authorized.

## Local Issue-draft requirements

Each planned-work Issue file must contain simple YAML front matter compatible with `skills/publish-issues/publish-issue-drafts.ps1`:

```yaml
---
title: "Bounded Issue title"
work_type: "Feature"
readiness: "Draft"
phase: "phase-1"
sequence: "01"
github_issue_number: ""
github_issue_url: ""
---
```

Allowed `work_type` values must match the repository's implementation Issue form. Handle observed bugs through the bug form and `create-work-item` unless equivalent local bug-draft support is added deliberately.

The Markdown body must use the repository's Issue contract headings.

Readiness metadata must match the readiness checklist:

- `Draft` when any readiness item remains unchecked or unsupported;
- `Ready` only when every readiness item is checked and supported.

## Validation

Before completing, verify:

- the active phase and roadmap phase match;
- a required design is approved;
- every phase exit criterion is covered;
- every Issue is singular and independently reviewable;
- dependencies are explicit and acyclic, or any intentional cycle is explained and resolved before publication;
- no Issue duplicates completed or already published work;
- all files use the local Issue template;
- metadata and filenames agree on order;
- Ready drafts have every readiness item checked;
- GitHub reference fields are empty for unpublished drafts;
- the phase plan remains `Draft` until human approval;
- `docs/project.md` records Issue planning as drafted;
- no GitHub Issue, current slice, or implementation was created.

## Required outputs

Provide:

- `docs/issues/<phase-slug>/README.md`;
- one numbered Markdown file per proposed Issue;
- the ordered Issue sequence;
- dependency and coverage summaries;
- each draft's readiness state;
- unresolved planning gaps;
- confirmation that nothing was published;
- the next handoff: human review, followed by `publish-issues` only after explicit authorization.

## Failure and escalation behavior

Stop and return a planning-gap report when:

- the phase has not been activated;
- the roadmap and project phase conflict;
- a required design is absent or unapproved;
- exit criteria cannot be made observable;
- the work cannot be divided without inventing requirements;
- dependencies are unresolved;
- existing local or GitHub Issues would be duplicated or overwritten;
- the proposed breakdown contains later-phase work that cannot be removed cleanly.

Do not compensate for missing design by hiding decisions inside Issue drafts.

## Completion conditions

This skill is complete when:

- one complete local phase plan exists with status `Draft`;
- the active phase is represented by an ordered set of bounded Issue drafts;
- every phase criterion has traceable coverage or an explicit gap;
- readiness states are accurate;
- `docs/project.md` records the Issue-planning state;
- no Issue was published;
- no current slice or implementation was created.
