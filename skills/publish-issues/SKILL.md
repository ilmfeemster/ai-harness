# Publish Issues

## Purpose

Publish an explicitly approved set of local Issue drafts from one phase directory as GitHub Issues and record traceability in the local documents.

This operation is the bridge:

```text
docs/issues/<phase-slug>/*.md
→ GitHub Issues
```

It does not create the phase plan, materially redesign Issue content, promote an Issue into `docs/current-slice.md`, or implement work.

## When to use

Use this skill when asked to:

- publish approved phase Issue drafts;
- turn local Issue documents into GitHub Issues;
- run the Issue-publication script for a phase;
- create GitHub Issues from `docs/issues/<phase-slug>/`.

## Do not use when

Do not use this skill when:

- the phase plan is not approved;
- publication has not been explicitly authorized;
- any selected draft is not Ready;
- required Issue content is missing;
- the target GitHub repository is unknown;
- the request is only to draft or revise Issues;
- the request is to promote an Issue or implement work.

## Authority and boundaries

Read and obey:

- `AGENTS.md`;
- this skill;
- `skills/create-work-item/SKILL.md`.

Publishing GitHub Issues is an external side effect and requires explicit authorization.

The local drafts govern the content proposed for publication. After successful creation, each GitHub Issue becomes the authoritative work item.

Do not:

- publish Draft work items;
- silently fix material scope or acceptance problems during publication;
- create duplicate Issues;
- publish files outside the approved phase plan;
- mark any Issue Active;
- create or modify `docs/current-slice.md`;
- begin implementation;
- automatically publish follow-up work discovered during validation.

## Required inputs

Require:

- target repository in `owner/name` form;
- one phase Issue directory;
- an approved `docs/issues/<phase-slug>/README.md`;
- explicit human authorization to publish;
- `gh` installed and authenticated when using the provided script, or another explicitly authorized GitHub Issue creation mechanism;
- permission to update local Issue metadata and the phase publication record.

## Required context

Load:

1. `AGENTS.md`;
2. this skill;
3. `skills/create-work-item/SKILL.md`;
4. `docs/project.md`;
5. `docs/issues/<phase-slug>/README.md`;
6. every selected local Issue draft;
7. the repository implementation Issue form;
8. existing GitHub Issues needed for duplicate detection.

Load the design or other project documents only when a local draft's readiness or traceability is unclear.

## Preconditions

Before publication, verify:

- the active project phase matches the phase directory;
- publication is explicitly authorized in the current request;
- the phase plan is already `Approved`, or the current request explicitly approves it and authorizes recording that approval before publication;
- every selected file has `readiness: Ready`;
- every readiness checkbox is checked;
- every required Issue-contract section is present;
- the GitHub Issue number and URL fields are empty;
- the repository is correct;
- no existing GitHub Issue has the same outcome or exact title;
- dependencies reference existing Issues or explain how publication order will resolve them.

If Issue dependencies rely on numbers that do not exist yet, publish in sequence and update later Issue bodies or local references only when that behavior is explicitly planned and safe. Prefer dependency wording that can remain valid without unknown numbers, such as a named prerequisite outcome.

## Supported publication paths

### Preferred reusable script

Run:

```powershell
powershell -NoProfile -File skills/publish-issues/publish-issue-drafts.ps1 `
  -Repo "owner/repository" `
  -IssueDirectory "docs/issues/<phase-slug>"
```

Use `-WhatIf` first when the user asks for a dry run or when publication scope needs confirmation.

### Direct agent publication

An agent may create the Issues through an available GitHub tool instead of the script only when:

- the user explicitly authorizes publication;
- the same preflight checks are performed;
- Issues are created in numeric file order;
- local metadata is updated after each successful creation;
- duplicate and partial-failure handling remains equivalent.

Do not claim the script ran when a connector or other mechanism was used.

## Procedure

1. Confirm explicit publication authorization.
2. Read the phase plan.
3. When the current request explicitly approves a Draft plan:
   - record the plan as `Approved`;
   - update its approval section with the human approval basis;
   - update `docs/project.md` Issue-planning status to `Approved`.
4. Verify the approved phase plan.
5. Enumerate numbered Issue draft files in ascending order. Exclude `README.md`.
6. Validate each file's:
   - front matter;
   - work type;
   - readiness state;
   - required sections;
   - readiness checklist;
   - empty GitHub reference fields.
7. Query existing GitHub Issues for duplicates by exact title and materially equivalent outcome.
8. Stop before creation if any preflight failure could cause partial publication.
9. Publish in sequence using the authorized mechanism.
10. After each successful creation:
   - capture the Issue number and URL;
   - write them to the local draft front matter;
   - preserve the rest of the draft;
   - report the created Issue.
11. If creation fails after some Issues were published:
   - stop immediately;
   - do not retry blindly;
   - report every created Issue and every uncreated file;
   - mark the phase plan publication state `Partial`;
   - preserve local traceability for successful creations.
12. After all selected Issues are created:
    - set the phase plan status to `Published`;
    - record Issue numbers and URLs in its publication summary;
    - update `docs/project.md` phase preparation:
      - `Issue planning: Published`;
      - `GitHub publication: Complete`.
13. Verify the published Issue bodies match the approved local drafts in meaning.
14. Stop before Issue selection or slice preparation.

## Validation

A successful publication must establish:

- every selected Ready draft has exactly one GitHub Issue;
- no Draft file was published;
- local Issue number and URL fields are populated accurately;
- created Issues use the required contract;
- publication order matches the approved plan;
- duplicate Issues were not created;
- the phase plan accurately reports `Published`;
- `docs/project.md` accurately reports publication completion;
- no Issue is marked Active;
- `docs/current-slice.md` is unchanged;
- implementation has not begun.

## Required outputs

Provide:

- publication mechanism used;
- repository;
- phase directory;
- created Issue numbers, titles, and URLs;
- skipped files and reasons;
- duplicate-check result;
- local files updated;
- phase-plan and project-state updates;
- partial-failure status when applicable;
- confirmation that no slice or implementation was started;
- the next available operation: select one Ready Issue and invoke `prepare-slice`.

## Failure and escalation behavior

Stop before publishing when:

- authorization is missing;
- the phase plan is not approved;
- any selected draft is not Ready;
- required content or readiness confirmation is incomplete;
- repository identity or authentication is missing;
- a duplicate or materially overlapping Issue exists;
- dependencies cannot be represented safely;
- local files cannot be updated with publication traceability.

When partial publication occurs, do not delete created Issues automatically. Report the exact state and request a reconciliation decision.

## Completion conditions

This skill is complete when:

- all approved selected drafts are published exactly once, or a partial state is fully reported;
- local Issue metadata reflects every successful creation;
- the phase plan and project publication state are accurate;
- GitHub Issues are now the authoritative work queue;
- no current slice or implementation was created.
