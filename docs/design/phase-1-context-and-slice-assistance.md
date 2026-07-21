# Phase 1 Context and Slice Assistance Design

## Status

Draft — awaiting explicit human approval before it may govern Phase 1 Issue planning or implementation.

## Problem

The Phase 0 workflow has the required documents, Issue contract, slice schema, and approval boundaries, but preparing a slice still requires repeated manual discovery and transcription. An operator must locate the Ready Issue, read the relevant project documents and designs, determine whether information is missing, and translate the Issue into a complete `docs/current-slice.md` without changing its outcome.

Phase 1 should remove this repeatable orchestration work while keeping the process inspectable and human-controlled.

## Goals

- Manually invoke a project-local preparation command for one explicitly identified GitHub Issue.
- Read a GitHub Issue into a normalized work-item contract based on the repository's Issue-form fields.
- Discover and record the local documents considered for the work item, including selected designs and missing references.
- Write an inspectable context manifest for the requested Issue.
- Produce one complete `Draft` `docs/current-slice.md` that preserves the source Issue's required outcome.
- Detect missing required Issue information, unresolved readiness confirmations, absent local documents, and obvious slice-structure or traceability problems before the draft is presented for approval.
- Preserve the existing human approval, one-active-slice, validation, review, and finalization boundaries.

## Non-goals

- Selecting the next Issue or inferring work priority.
- Creating, editing, publishing, closing, or otherwise changing GitHub Issues.
- Automatically changing a Draft slice to `Approved` or starting implementation.
- Running implementation commands, validation, repair, commits, pull requests, or background jobs.
- Replacing review with automated semantic judgment.
- Introducing a hosted service, database, central registry, cross-repository controller, or provider-neutral agent framework.
- Supporting arbitrary Issue templates beyond the repository's implementation and bug forms in this phase.

## Design summary

Phase 1 adds one local, foreground slice-preparation tool and small, explicit data formats around it. The operator supplies one Issue number. The tool obtains an Issue snapshot through the configured GitHub command-line client, parses the submitted Issue-form body, assembles a bounded set of local project documents, writes a context manifest, and writes `docs/current-slice.md` with status `Draft` only when the Issue and current-slice guards pass.

The tool does not decide whether work should begin. A human reviews the manifest and Draft slice, then follows the existing lifecycle to approve the slice and separately authorize implementation.

```text
human selects one Ready Issue
        |
        v
local slice-preparation tool
        |
        +-- read Issue snapshot and parse form fields
        +-- inspect active slice and local documents
        +-- write context manifest and warnings
        +-- write Draft current slice when blockers are absent
        |
        v
human reviews and explicitly approves, revises, or rejects the draft
```

## Inputs and normalized work-item contract

### Source Issue

The GitHub Issue remains authoritative. The preparation command receives an explicit Issue number and obtains a read-only snapshot containing at least the Issue number, title, URL, state, and rendered body. The initial implementation may use `gh issue view` for this read. Authentication, repository selection, and command availability are environmental prerequisites, not state managed by the harness.

The parser recognizes the submitted headings emitted by the two bundled Issue forms. For an implementation Issue, it extracts:

- work type;
- goal;
- context;
- scope;
- non-goals;
- acceptance criteria;
- dependencies;
- relevant project documents; and
- readiness confirmations.

For a bug Issue, it maps the summary, observed and expected behavior, evidence, impact, fix scope, non-goals, acceptance criteria, dependencies, relevant documents, and readiness confirmations into the same normalized contract. The normalized goal records the corrected observable outcome; the original bug evidence remains source context.

The parser must retain the Issue number, title, URL, and unparsed body as traceability. It must not invent a required field from a title, label, or surrounding repository text.

### Local document inputs

Every preparation run considers the current authority sources needed to bound a slice:

- `AGENTS.md`;
- `docs/project.md`;
- `docs/architecture.md`;
- `docs/decisions.md`;
- `docs/testing.md`;
- the current `docs/current-slice.md`; and
- project documents explicitly listed by the Issue.

It also enumerates `docs/design/*.md`. A design is selected when the Issue explicitly references it, or when it is the approved design for the active phase and its stated capability matches the Issue. A Draft design may be listed as a candidate but must never be used as governing input. The manifest records both selected and considered-but-not-selected documents so the operator can inspect the choice.

`docs/roadmap.md` is optional context: it is included only when the Issue or active phase needs sequencing information. The tool must not load unrelated source files, sibling repositories, or all project files merely because they exist.

## Context manifest

Each successful preparation attempt writes `docs/context-manifests/<issue-number>.md`. This is project-owned traceability for the slice-preparation operation, not a replacement work queue or run database.

The manifest contains:

- preparation timestamp and tool version;
- source Issue number, title, URL, and snapshot identifier;
- normalized contract fields and the readiness result;
- selected governing documents, with their reason for selection;
- documents considered but not selected;
- absent paths, inaccessible Issue data, and other warnings;
- blocking conditions, if any; and
- the generated slice path and its status when a draft is written.

The manifest is overwritten only for a new preparation attempt of the same Issue. It must not contain secrets, authentication tokens, or full copied content from GitHub or local documents; it records references, summaries, and checksums or timestamps where useful.

## Preparation behavior and guards

The command uses this sequence:

1. Accept one explicit Issue number; do not discover or select a candidate Issue.
2. Fetch a read-only Issue snapshot and parse it into the normalized contract.
3. Verify the Issue is open, all required form fields are present, every readiness confirmation is checked, and no stated dependency remains unresolved.
4. Inspect `docs/current-slice.md`. Stop if it contains an unresolved `Draft`, `Approved`, `In progress`, `Blocked`, or `Ready for review` slice.
5. Discover the bounded document set and identify approved relevant designs.
6. Write the context manifest, including all warnings and blockers.
7. Stop without replacing `docs/current-slice.md` when a blocker exists.
8. Otherwise generate a complete slice from the reusable slice schema, preserve the normalized source contract verbatim in the corresponding sections, add only execution detail derived from selected documents, and set its status to `Draft`.
9. Run deterministic structural and traceability checks on the generated draft, then update the manifest with the results.
10. Present the manifest and draft to the human and stop.

The tool may replace a `Complete` slice or an empty active-slice file only after the source Issue passes the guards. It must never replace an unresolved slice. It does not set Issue state to Active; the existing approval transition remains responsible for that lifecycle change.

## Warnings and blockers

Blockers prevent a draft from being written:

- the Issue cannot be read or is closed;
- the Issue does not match a supported form or lacks a required field;
- a readiness confirmation is unchecked;
- a required dependency is unresolved;
- the referenced local governing document is missing;
- the active slice is unresolved; or
- no approved design is available when the Issue depends on a design-required phase capability.

Warnings do not prevent drafting but must be prominent in the manifest and draft review handoff:

- a listed local document is outside the usual project-authority paths;
- no design applies to an Issue that does not need one;
- a listed design is Draft and was excluded;
- a declared validation command cannot yet be verified without implementation context;
- the proposed expected-file list is incomplete or uncertain; or
- semantic scope alignment needs human judgment despite passing structural checks.

The tool must describe an unresolved semantic question as a warning or blocker rather than filling the gap with generated requirements.

## Draft-slice construction

The generated `docs/current-slice.md` uses the repository's neutral current-slice schema. It must contain all required sections and source-Issue traceability. The Issue's context, goal, scope, non-goals, and acceptance criteria are preserved without semantic expansion or omission.

The tool may add:

- ordered implementation steps constrained by selected architecture, decisions, and design documents;
- plausible expected files, marked as assumptions where they cannot be verified;
- validation commands and manual checks required by `docs/testing.md` and the selected design;
- failure conditions that preserve source-Issue and design boundaries;
- review checks for scope, architecture, tests, and unsupported shortcuts; and
- links to the context manifest and selected governing documents.

Completion evidence remains pending. The only initial status is `Draft`. A human may revise the draft before approval; material changes to the required outcome must return to the authoritative Issue.

## Structural and scope checks

Phase 1 checks are deliberately divided by what they can prove.

Deterministic checks verify:

- supported-form headings and all required fields;
- checked readiness items;
- valid source Issue number, title, and URL;
- valid Draft-slice headings and lifecycle status;
- exact presence of the source contract sections;
- local existence of selected document paths;
- no replacement of an unresolved active slice; and
- no unresolved scaffold markers in the generated draft.

Scope checks compare the parsed Issue fields with their corresponding generated slice sections. They detect missing or materially altered source text and unexpected generated sections, but they do not claim to prove semantic equivalence. Human review remains responsible for judging whether execution steps, expected files, and interpretation stay within the Issue and approved design.

## Boundaries and dependency direction

The initial implementation remains a project-local PowerShell tool alongside the existing structural validator. It may depend on the GitHub CLI only to read the explicitly supplied Issue. It reads project documents and writes only the context manifest and the active slice after guards succeed.

```text
GitHub Issue (authoritative outcome)
        |
        v
Issue reader and form parser
        |
        +----------------------------+
        |                            |
        v                            v
local authority discovery       current-slice guard
        |                            |
        +------------+---------------+
                     v
              context manifest
                     |
                     v
          Draft docs/current-slice.md
                     |
                     v
               explicit human approval
```

No component writes back to GitHub, changes project scope, creates a design, invokes an implementation agent, or communicates with another repository. The manifest and slice consume the Issue contract; they cannot override it. Architecture, decisions, approved designs, and testing standards constrain the generated execution detail.

## Alternatives and tradeoffs

### Single local PowerShell tool (chosen)

This matches the existing local validator, keeps setup small, and makes inputs and writes easy to inspect. It is sufficient for one explicit Issue at a time.

### Hosted or centralized orchestration service (rejected)

It would violate the project-local and self-contained architecture before the workflow is proven across projects.

### Fully automatic Issue discovery and promotion (rejected)

It would compress the human work-selection and approval boundaries that the current workflow deliberately preserves.

### Persisted database or general run-record system (rejected)

The per-Issue Markdown manifest provides the needed traceability without introducing a new state store. General run records remain a possible later-phase concern.

### Treating all designs as context (rejected)

This would create noise and allow irrelevant or Draft designs to influence execution. Selection must be explicit and explainable.

## Risks and open questions

- GitHub's rendered Issue-form body can change independently of the form YAML. Parser fixtures must use real submitted Issue examples and fail clearly on unknown headings.
- GitHub CLI availability and authentication are external prerequisites. The tool must report actionable failure without prompting for or recording credentials.
- Mapping an approved design to an Issue can require human judgment. The first implementation should favor explicit Issue references and surface ambiguity as a warning.
- Generated implementation steps can look more certain than their evidence. Assumptions must be marked and reviewed rather than silently adopted.
- The manifest directory adds project-owned traceability. Its retention and cleanup policy should remain simple until repeated use demonstrates a need for automation.

## Acceptance implications

Phase work derived from this design should make the following observable:

- Given a supported Ready Issue, the tool produces a normalized contract retaining its number, title, URL, and required Issue fields.
- Given relevant local authority documents and an approved design, the manifest lists selected inputs with reasons and identifies missing or excluded inputs.
- Given a passing contract and no unresolved slice, the generated active slice is complete, has status `Draft`, and preserves the Issue's outcome, scope, non-goals, and acceptance criteria.
- Given an unchecked readiness item, missing required field, closed Issue, missing required document, or unresolved active slice, no active slice is replaced and the manifest names the blocker.
- Generated output passes existing structural validation and dedicated parser, manifest, and scope-check fixtures.
- No preparation path changes GitHub state, approves a slice, starts implementation, or selects another Issue.

## Suggested implementation sequencing

This is a high-level design breakdown only; it is not an Issue plan.

1. Define normalized Issue-contract and parser fixtures for the supported Issue forms.
2. Implement bounded document discovery and manifest generation, including design-selection rules.
3. Implement Draft-slice construction, active-slice guards, and deterministic structural/scope checks.
4. Exercise the complete manual preparation workflow against a Ready Issue and stabilize its warnings and documentation.

Issue drafting, publication, slice preparation for implementation, and implementation authorization remain separate operations after this design receives explicit approval.
