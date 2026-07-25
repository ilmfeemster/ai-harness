# Phase 1: Assemble bounded context manifests

> **Project operational state:** This file is the active execution package for the AI Development Harness project. It is a Draft translation of GitHub Issue #9 and does not authorize implementation.

## Status

Draft

## Source Issue

- **Issue:** #9 - Phase 1: Assemble bounded context manifests
- **URL:** https://github.com/ilmfeemster/ai-harness/issues/9

## Context

An Issue parser alone cannot show which project documents constrain a future slice. The approved Phase 1 design requires a project-local manifest that records selected documents, design-selection reasoning, candidate exclusions, missing paths, warnings, and blockers without becoming a database or loading unrelated repository content.

## Goal

For a normalized Issue, discover its bounded local governing context and write an inspectable per-Issue context manifest.

## Scope

- Discover the mandatory Phase 1 authority documents and local documents explicitly referenced by a normalized Issue.
- Enumerate local design documents and apply the approved-design selection rules.
- Write one per-Issue Markdown manifest in the project-owned context-manifest directory, with source traceability, selection reasons, warnings, blockers, and draft-output status.
- Add deterministic fixtures and tests for selection, exclusion, absent documents, Draft-design handling, and manifest overwrite behavior.

## Non-goals

- Do not parse or fetch the Issue contract beyond consuming Issue #8's normalized result.
- Do not replace `docs/current-slice.md`, approve work, or start implementation.
- Do not discover all repository files, sibling repositories, or remote project context.
- Do not add a database, general run-record system, or automated retention process.

## Acceptance criteria

- [ ] For a normalized Issue, the manifest records the mandatory authority sources, Issue-linked local documents, selected designs, and the reason for each selection.
- [ ] Draft designs can be recorded as candidates but are excluded from governing context; approved applicable designs are selected according to the design rules.
- [ ] Missing referenced local documents, inaccessible paths, and ambiguous selection conditions are reported as actionable warnings or blockers.
- [ ] The manifest contains no credentials, tokens, or copied full Issue/document contents and is limited to the Issue's project-local traceability.
- [ ] Deterministic tests cover bounded discovery, design selection, missing-path reporting, and repeat preparation for the same Issue.

## Existing implementation seam

- `scripts/prepare-slice.ps1` is the sole Phase 1 tool entry point. It currently exposes `Invoke-IssueNormalization`, `Get-NormalizedIssue`, and fixture-backed input; Issue #9 extends it without changing the normalizer's GitHub-read behavior.
- `tests/prepare-slice.ps1` dot-sources the tool with `-NoRun` and directly tests exported functions. Extend this file rather than introducing a second test harness.
- `tests/fixtures/issues/` establishes the JSON-fixture convention. Add a separate context-fixture subtree for normalized contracts and small synthetic document trees; do not use the live repository or GitHub in deterministic tests.

## Component and contract map

| Responsibility | Location | Input | Output / side effect |
| --- | --- | --- | --- |
| Load normalized contract | `scripts/prepare-slice.ps1` | A serialized normalized-contract fixture or object produced by Issue #8 | A contract containing source number/title/URL, relevant-document text, readiness, and optional bug details. It must not re-fetch or re-parse an Issue. |
| Discover bounded candidates | `scripts/prepare-slice.ps1` | Normalized contract and explicit repository root | Mandatory authority records, Issue-linked path records, and local design candidates only. |
| Classify and select context | `scripts/prepare-slice.ps1` | Candidate records and design status | Selected records with reasons; excluded candidates; warnings and blockers. |
| Render and write manifest | `scripts/prepare-slice.ps1` | Classified manifest model and explicit output root | One Markdown file named for the source Issue; creates only its containing manifest directory and overwrites only that Issue's prior manifest. |
| Verify behavior | `tests/prepare-slice.ps1` | Local normalized-contract and document-tree fixtures | Deterministic assertions over every selection, exclusion, warning, blocker, content-safety, and overwrite branch. |

## Deterministic decision rules

| Condition | Classification | Manifest behavior | Side effect |
| --- | --- | --- | --- |
| Required authority exists: `AGENTS.md`, project, architecture, decisions, testing, or active slice | Selected | Record path and reason `mandatory authority` | None |
| Required authority path is absent or inaccessible | Blocker | Record the path and actionable missing/inaccessible reason | Do not report the manifest as ready for downstream use |
| Issue-linked relative local document exists | Selected | Record path and reason `linked by source Issue` | None |
| Issue-linked local document is absent or inaccessible | Blocker | Record the exact path and an actionable reason | Do not report the manifest as ready for downstream use |
| Issue-linked path is outside the allowed local project-document set | Warning and excluded | Record the path and explain that it was not loaded | None |
| Explicitly linked approved design exists | Selected | Record path and reason `approved design linked by source Issue` | None |
| Draft design is explicitly linked or discovered | Warning and excluded candidate | Record its path, status, and `Draft designs do not govern execution` | None |
| Approved design is discovered but not explicitly linked by the Issue | Excluded candidate | Record `not linked by source Issue`; do not infer semantic relevance | None |
| A design lacks a recognizable status or its relevance cannot be determined from an explicit Issue link | Warning and excluded candidate | Record the ambiguity; do not treat it as governing input | None |
| Same source Issue is prepared again | No warning by itself | Replace only that source Issue's existing manifest | Preserve other Issue manifests |

## Implementation plan

1. In `scripts/prepare-slice.ps1`, add a context-manifest mode that accepts a normalized contract object or a normalized-contract JSON path plus an explicit repository root. Keep `Invoke-IssueNormalization` unchanged as the sole Issue-reader/parser boundary; the new mode must not call `gh` or parse Issue-form Markdown.
2. Add focused helper responsibilities in the same script: extract relative paths from the contract's `RelevantDocuments`; build mandatory authority candidates; enumerate only markdown files under the local design directory; read a design's `## Status`; and return records with path, classification, reason, and source category. Do not enumerate source code, sibling repositories, or arbitrary project files.
3. Implement `Resolve-ContextManifest` (or equivalently named focused function) to apply the decision table exactly. Return a model containing source number/title/URL, readiness summary, selected records, excluded candidates, warnings, blockers, and a downstream-ready flag. Retain only the normalized contract fields needed for traceability; omit `Source.UnparsedBody`, credentials, tokens, and full document contents.
4. Implement `Write-ContextManifest` to render the model as concise Markdown in the context-manifest directory. The filename is the source Issue number with a Markdown extension. Create the directory when absent; overwrite only the same Issue-number file; never write `docs/current-slice.md`, GitHub state, a database, or a general run record.
5. Extend `tests/prepare-slice.ps1` with fixture-root helpers and assertions for mandatory selections, explicit linked-document selection, approved-design selection, Draft-design exclusion, unlinked approved-design exclusion, missing authority or linked-document blockers, ambiguous-design warnings, secret/content omission, and same-Issue overwrite isolation. Add only the normalized-contract and synthetic document fixtures required by those cases.
6. Update the command help or top-level output in `scripts/prepare-slice.ps1` so the manifest mode reports selected count, warning count, blocker count, and output path without claiming it has produced or approved a slice.

## File-by-file change plan

| File | Change | Tests / constraints |
| --- | --- | --- |
| `scripts/prepare-slice.ps1` | Add normalized-contract input, bounded discovery, design-status inspection, decision-table classification, Markdown rendering, and same-Issue manifest writing. | Must not call GitHub in manifest mode or alter the existing normalizer contract. |
| `tests/prepare-slice.ps1` | Extend the existing direct-function test harness with manifest behavior assertions. | Must remain self-contained and avoid live GitHub access. |
| Context fixture subtree under `tests/fixtures/` | Add minimal normalized-contract JSON and synthetic project-document trees for each material branch. | Include approved, Draft, unlinked, missing, and repeat-write cases; no real project secrets or copied full documents. |
| Project-owned context-manifest directory | Created by `Write-ContextManifest` when an explicit manifest operation runs. | Contains concise references and summaries only; never full Issue bodies or document contents. |
| `docs/current-slice.md` | Record execution evidence and exact files after implementation. | This Draft is the only permitted current-slice change in this operation. |

## Acceptance-criterion mapping

| Acceptance criterion | Implementation evidence | Validation method |
| --- | --- | --- |
| Mandatory authorities, Issue-linked documents, selected designs, and reasons are recorded | Candidate builder and manifest renderer include classified records and reason text. | Fixture with all mandatory files, one linked document, and one linked approved design; assert manifest sections and reasons. |
| Draft designs are excluded and approved applicable designs are selected | Design-status reader and selection classifier follow the decision table. | Fixtures with linked Approved and Draft designs plus an unlinked Approved design; assert selected versus excluded records. |
| Missing, inaccessible, and ambiguous context is actionable | Classifier emits blockers for required/linked missing paths and warnings for ambiguous design status or relevance. | Missing-path and no-status fixtures; assert classification, reason, and downstream-ready result. |
| Manifest contains no secrets or copied full content | Model excludes unparsed Issue body and renderer emits only source metadata, paths, statuses, reasons, and counts. | Fixture with sentinel token and document text; assert neither appears in rendered manifest. |
| Tests cover bounded discovery and same-Issue overwrite | Writer uses a deterministic per-Issue path and the discovery functions limit enumeration. | Test two Issue numbers, repeat one write, and assert only the matching file changes; assert no unrelated files or GitHub commands are used. |

## Expected files

- `scripts/prepare-slice.ps1` — existing normalizer seam extended with the context-manifest mode and focused helper functions.
- `tests/prepare-slice.ps1` — existing test harness extended with all manifest behavior branches.
- A new context fixture subtree beneath `tests/fixtures/` — normalized contracts and synthetic project document trees.
- A project-owned context-manifest directory created only by the explicit manifest operation.
- `docs/current-slice.md` — this Draft slice and later execution evidence only.

## Validation plan

Run from the repository root after implementation:

```powershell
powershell -NoProfile -File tests/prepare-slice.ps1
powershell -NoProfile -File scripts/validate.ps1
powershell -NoProfile -File tests/validate-structure.ps1
```

Manual checks:

- Invoke manifest mode with a normalized Issue #9 contract and the repository root; inspect the output for mandatory authorities, Issue-linked documents, the approved Phase 1 design, reasons, warnings, blockers, counts, and the per-Issue output path.
- Repeat with a linked Draft design and a missing linked path; confirm the Draft design is excluded with a warning and the missing path is a blocker.
- Run the same source Issue twice after changing only its synthetic fixture input; confirm only that Issue's manifest is replaced and a second Issue's manifest remains unchanged.
- Inspect the generated manifest to confirm it contains no GitHub token, normalized unparsed body, or copied full document text.
- Confirm manifest mode neither calls `gh`, replaces `docs/current-slice.md`, selects an Issue, approves a slice, nor starts implementation.

## Failure conditions

Stop and revise before implementation or approval if:

- discovery requires a whole-repository crawl, source-code discovery, or another repository to select context;
- context-manifest mode would call `gh`, parse an Issue form, or change the Issue #8 normalized contract;
- a Draft or ambiguous design would be treated as governing input;
- a missing mandatory or Issue-linked path could be silently treated as selected;
- the manifest would retain credentials, tokens, an unparsed Issue body, or full document contents;
- repeat preparation could overwrite another Issue's manifest;
- writing a manifest would replace the active slice or create a database/general run-record system; or
- a test fixture cannot prove a material decision-table branch deterministically.

## Review checklist

- Does the implementation extend the existing normalizer seam without re-fetching or re-parsing an Issue?
- Are discovery paths limited to mandatory authorities, Issue-linked local documents, and local design files?
- Does every selected, excluded, warning, and blocker record have an inspectable deterministic reason?
- Are Draft and ambiguous designs excluded from governing context?
- Are missing mandatory and Issue-linked paths explicit blockers?
- Does the manifest omit secrets, unparsed Issue bodies, and copied full documents?
- Does repeated preparation overwrite only the matching Issue manifest?
- Are all decision-table branches covered by local deterministic tests, with no live GitHub dependency?
- Does the operation preserve the active slice, GitHub state, approval boundary, and one-work-item invariant?

## Completion evidence

**Implementation status:** Pending human approval and implementation authorization.

**Acceptance-criteria status:** Pending.

**Files changed:** `docs/current-slice.md` (re-prepared Draft only).

**Validation results:** Structural validation is pending after this re-prepared Draft is saved.

**Manual checks:** GitHub Issue #9 was retrieved read-only on 2026-07-24. It is open, contains all required Issue-contract sections, and has every readiness confirmation checked. GitHub Issue #8 is closed, satisfying the sole phase-local prerequisite. The existing implementation seam and fixture convention were inspected on 2026-07-24.

**Implementation adjustments or deviations:** Reprepared to the updated executability gate. The prior broad plan is replaced with an existing-seam, file-level implementation plan, deterministic decision table, behavior-branch test matrix, and acceptance mapping. No implementation occurred.

**Known limitations or follow-up Issues:** Guarded Draft-slice generation remains deferred to Issue #10. End-to-end workflow integration remains deferred to Issue #11.

**Implementation summary:** Draft slice prepared from GitHub Issue #9. Implementation has not started.

## Dependencies and assumptions

- **Phase-local prerequisite:** Issue #8 — Normalize supported GitHub Issue forms — is Complete and closed.
- The approved Phase 1 design remains available at `docs/design/phase-1-context-and-slice-assistance.md`.
- The normalized contract's `RelevantDocuments` field is the authoritative input for explicit Issue-linked path selection. The manifest mode accepts this contract as input and does not invoke the Issue reader/parser.
- An approved design is selected only when the source Issue explicitly links it. An unlinked approved design is recorded as an excluded candidate instead of inferring semantic relevance.

## Relevant project documents

- `AGENTS.md`
- `docs/project.md`
- `docs/architecture.md`
- `docs/decisions.md`
- `docs/testing.md`
- `docs/design/phase-1-context-and-slice-assistance.md`
- `scripts/prepare-slice.ps1`
- `tests/prepare-slice.ps1`
- `skills/validate-slice/SKILL.md`

## Implementation constraints

- Preserve GitHub Issue #9's goal, scope, non-goals, and acceptance criteria.
- Keep the manifest operation project-local, bounded, and explainable; do not load unrelated repositories or arbitrary source files.
- Consume the normalized contract from Issue #8. Do not duplicate the GitHub Issue reader or Issue-form parser.
- Do not replace the active slice, change GitHub state, approve work, or start implementation from the manifest operation.
- This slice remains `Draft` until explicit human approval; implementation requires separate explicit authorization after approval.
