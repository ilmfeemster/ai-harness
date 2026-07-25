# Phase 1: Generate guarded Draft slices

> **Project operational state:** This is the Complete execution package for GitHub Issue #10. Final approval is recorded and the source Issue is closed.

## Status

Complete

## Source Issue

- **Issue:** #10 - Phase 1: Generate guarded Draft slices
- **URL:** https://github.com/ilmfeemster/ai-harness/issues/10

## Context

Issue #8 already produces a normalized contract and Issue #9 produces a bounded Markdown context manifest. Phase 1 still needs a guarded local path that can consume those two artifacts, preserve the Issue contract, and replace only an empty or Complete active slice with a structurally valid Draft. The generator must surface missing information and guard failures rather than inventing semantic execution detail or changing workflow state.

## Goal

Generate a complete, structurally checked Draft active slice from a passing normalized Issue and context manifest without replacing unresolved work or approving execution.

## Scope

- Enforce readiness, dependency, required-document, context-manifest, and unresolved-active-slice guards before active-slice replacement.
- Generate every required slice section from the neutral schema and preserve the source Issue's context, goal, scope, non-goals, and acceptance criteria.
- Add bounded execution detail, validation/review guidance, and manifest links only from selected governing documents.
- Add deterministic structural, traceability, and source-to-slice scope checks, with fixtures for success and blocked cases.

## Non-goals

- Do not fetch or parse Issue forms independently of Issue 01.
- Do not perform broad document discovery independently of Issue 02.
- Do not set a slice to `Approved`, mark an Issue Active, run implementation, or write to GitHub.
- Do not claim semantic equivalence or replace human review with generated checks.

## Acceptance criteria

- [x] A passing normalized Issue and manifest produce a complete `docs/current-slice.md` with status `Draft`, source traceability, and no unresolved scaffold markers.
- [x] The generated slice preserves the source Issue's context, goal, scope, non-goals, and acceptance criteria without omission or material alteration.
- [x] An unchecked readiness item, unresolved dependency, missing required document, closed Issue, or unresolved active slice prevents active-slice replacement and records the blocker in the manifest.
- [x] Structural and source-to-slice checks identify missing required headings, invalid status, broken traceability, and altered or omitted contract sections.
- [x] Tests demonstrate that preparation does not approve a slice, begin implementation, or write to GitHub.

## Governing-rule reconciliation

| Rule | Governing source | Slice interpretation | Difference |
| --- | --- | --- |
| Issue outcome and lifecycle boundary | GitHub Issue #10; `AGENTS.md` sections 5, 10, 11, and 12 | The generator consumes a normalized contract and may write only a `Draft` slice or update the matching context manifest with a sanitized guard result. It never approves, implements, changes Issue state, or writes GitHub state. | None |
| Normalized Issue input | Approved Phase 1 design, **Inputs and normalized work-item contract**; Issue #8 outcome | Reuse `Get-NormalizedIssueContractFromFile` and the existing normalized-object shape. Draft generation neither calls the source-Issue reader nor parses an Issue form. | None |
| Bounded context input | Approved Phase 1 design, **Local document inputs**, **Context manifest**, and **Preparation behavior and guards**; Issue #9 outcome | Require one matching Issue #9 manifest with no existing blockers and downstream-ready true; use only its selected local document references and do not rediscover the repository. A missing, unreadable, or source-mismatched manifest is command-reported only because no safe matching manifest exists to update. | Implementation refinement within authority |
| Guarded active-slice replacement | Approved Phase 1 design, **Preparation behavior and guards**; Issue #10 scope | Permit replacement only when the existing active slice is empty or `Complete`. Treat `Draft`, `Approved`, `In progress`, `Blocked`, and `Ready for review` as blockers and preserve the existing file byte-for-byte. | None |
| Readiness, source state, and dependencies | Approved Phase 1 design, **Preparation behavior and guards**; Issue #10 acceptance criterion 3; local phase-plan front matter | Require normalized source state `OPEN`, every readiness confirmation checked, and every sequence in the matching local phase draft's `depends_on` list to map to a closed GitHub Issue. Read dependency state only; do not fetch or parse dependency Issue forms. | Implementation refinement within authority |
| Generated source contract | Approved Phase 1 design, **Draft-slice construction** and **Structural and scope checks**; Issue #10 acceptance criterion 2 | Render normalized `Context`, `Goal`, `Scope`, `NonGoals`, and `AcceptanceCriteria` verbatim in their corresponding slice sections. Structural comparison detects omission or alteration but does not claim semantic equivalence. | None |
| Generated execution detail | Approved Phase 1 design, **Draft-slice construction** and **Warnings and blockers** | Generate only fixed, provenance-labeled preparation guidance and selected-document links. When selected sources do not establish file-level execution detail, render an explicit human-review warning instead of inferring APIs, relevance, or semantic policy. | Implementation refinement within authority |
| Deterministic generated-artifact interface | `AGENTS.md` section 11; `skills/prepare-slice/SKILL.md`, **Deterministic interface requirement** | Define fixed command inputs, manifest validation, ordering, empty states, guard outcomes, UTF-8 output, overwrite behavior, and sanitized failure records. Keep fixture substitution internal rather than exposing test-only operator parameters. | None |

## Existing implementation seam

- `scripts/prepare-slice.ps1` already separates Issue normalization (`Invoke-IssueNormalization`) from context-manifest mode (`Invoke-ContextManifest`) and supports dot-sourcing with `-NoRun`.
- `Get-NormalizedIssueContractFromFile` validates the normalized contract that Issue #10 must consume; `Write-ContextManifest` provides the existing UTF-8, same-Issue manifest write boundary.
- `templates/docs/current-slice.md` is the neutral required-heading schema. `scripts/validate.ps1` already defines structural current-slice checks and lifecycle/evidence consistency rules.
- `tests/prepare-slice.ps1` is the focused PowerShell harness, and `tests/fixtures/context/` supplies normalized contracts plus minimal synthetic repositories without live GitHub dependence.

## Component and contract map

| Responsibility | Location | Inputs | Output or side effect |
| --- | --- | --- |
| Draft-generation command mode | `scripts/prepare-slice.ps1` | `-GenerateDraftSlice`, normalized-contract path, matching context-manifest path, explicit repository root | One Draft-generation result object; no Issue-form parse or GitHub write |
| Read and validate manifest | `scripts/prepare-slice.ps1` | UTF-8 Markdown manifest and normalized source number | Source-match, selected-path, readiness, blocker, and output-status records without loading unrelated files |
| Guard evaluation | `scripts/prepare-slice.ps1` | Normalized contract, local phase draft, manifest, current slice, selected paths | Ordered sanitized blockers or permission to generate |
| Dependency-state reader | `scripts/prepare-slice.ps1` | Mapped prerequisite Issue numbers | Read-only `gh issue view <number> --json state` result in command mode; internal injected reader in tests |
| Slice renderer and writer | `scripts/prepare-slice.ps1` | Normalized contract, selected document records, guard result, neutral schema | UTF-8 `docs/current-slice.md` only after all guards and self-checks pass |
| Manifest result update | `scripts/prepare-slice.ps1` | Existing matching manifest, generated/blocked result | Replace only the matching manifest's guard/result records; no source or full document content |
| Structural and scope verification | `scripts/prepare-slice.ps1` | Generated Markdown and normalized contract | Required-heading, Draft-status, traceability, exact source-section, placeholder, and local-reference findings |
| Focused verification | `tests/prepare-slice.ps1` | Existing and added context fixtures with temporary repository roots | Deterministic success, guard, preservation, manifest-update, and no-side-effect assertions |

## Interface contracts

### Command-line mode

```powershell
powershell -NoProfile -File scripts/prepare-slice.ps1 `
  -GenerateDraftSlice `
  -NormalizedIssueJsonPath "tests/fixtures/context/normalized/issue-10.json" `
  -ContextManifestPath "docs/context-manifests/10.md" `
  -RepositoryRoot "."
```

- `-GenerateDraftSlice`, `-NormalizedIssueJsonPath`, `-ContextManifestPath`, and `-RepositoryRoot` are required together and form a mutually exclusive parameter set with existing Issue-normalization and context-manifest modes.
- The generated output path is fixed at `<RepositoryRoot>/docs/current-slice.md`; no output-path parameter is added.
- The manifest path must resolve beneath `<RepositoryRoot>/docs/context-manifests/`, have the source Issue number as its filename, and contain a matching `# Context Manifest — Issue #<number>` header.
- Command mode consumes only the local normalized JSON, matching local manifest, neutral schema, the manifest-selected local paths, current active slice, matching local phase draft, and read-only dependency states. It must not call `Get-IssueSnapshotFromGitHub`, `Invoke-IssueNormalization`, Issue-form parsing, or any GitHub mutation.
- Command output is a compact object containing source Issue number, `Generated`, guard-blocker count, Draft output path when generated, manifest path, and sanitized blocker summaries. It never reports approval, implementation, or Issue-state changes.

### Guard ordering and outcomes

1. Validate the normalized contract and require source state `OPEN` plus every readiness confirmation checked.
2. Locate the matching local phase draft through exact `github_issue_number` front matter; parse its `phase`, `sequence`, and comma-delimited `depends_on` values. Treat an empty value as no dependencies; otherwise split on commas, trim each token, deduplicate case-insensitively while preserving first order, and require every retained token to map exactly to one `sequence` value in the same phase.
3. Map each dependency sequence to exactly one local draft in the same phase and read only that mapped GitHub Issue's state. A missing mapping, unreadable state, or state other than `CLOSED` is a blocker.
4. Read the supplied UTF-8 context manifest. Require matching source number, `Downstream-ready: True`, `## Blockers` rendered as `- None.`, and at least the fixed mandatory selected authorities. Every selected relative path must remain a readable local file.
5. Read the current active-slice status. Empty or `Complete` is replaceable; every other recognized lifecycle status is a blocker. Missing, malformed, or unrecognized active-slice state is also a blocker.
6. Verify the neutral schema and all fixed required local documents exist before rendering.

All guard blockers are accumulated in the order above, rendered with category, repository-relative path or Issue number, and actionable sanitized message, then recorded in the matching manifest. A blocker prevents any write or replacement of `docs/current-slice.md`.

### Generated slice and manifest records

- Generate required headings in neutral-schema order. Render the exact normalized source Issue context, goal, scope, non-goals, and acceptance text without trimming content beyond the existing normalizer's contract values.
- Set generated status to `Draft`, approval evidence to pending, and every completion-evidence field to pending/not run. Do not include approval or implementation claims.
- Render selected governing document paths in manifest order, then generated fixed preparation guidance with an explicit warning when the selected documents do not justify file-level detail. Do not infer relevance, APIs, expected files, or semantic equivalence from free text.
- Include the matching manifest path as traceability and list only existing selected documents. Render empty selected-document, warning, or blocker lists as `- None.`.
- Validate the generated text before writing: all required headings, Draft status, source Issue identity, exact preserved source sections, required lifecycle evidence, no neutral-schema placeholders, and existing local references.
- Write UTF-8 without BOM through a temporary sibling file only after validation. Replace a permitted existing target only after all guards and self-checks pass; a write failure leaves the prior target intact and records a sanitized manifest blocker when possible.
- Update only a readable, source-matching supplied manifest's `## Blockers` and `## Output` result records. On success, record the Draft path and `Draft`; on a later guard failure, record `Blocked` plus sanitized blockers. When the manifest itself is missing, unreadable, outside the bounded location, or source-mismatched, preserve it and report that blocker only through the command result. Repeating the same successful invocation with identical inputs produces identical Draft content and updates no other Issue manifest.

## Deterministic decision rules

| Condition | Classification | Slice/manifest behavior | Test coverage |
| --- | --- | --- | --- |
| Open source and all readiness confirmations checked | Guard passes this branch | Continue to dependency and manifest guards | Passing normalized fixture |
| Source state closed or a readiness confirmation unchecked | Blocker | Preserve active slice; update only matching manifest with sanitized guard record | Closed and unchecked-contract fixtures |
| Local dependency mapping missing, ambiguous, unreadable, or mapped Issue not `CLOSED` | Blocker | Preserve active slice; report sequence and mapped Issue information without Issue body | Missing mapping, duplicate mapping, reader failure, and open-state fixtures |
| Matching manifest is blocked, not downstream-ready, or has a selected path missing | Blocker | Preserve active slice; update only that matching manifest with an actionable result | Manifest validity and missing selected-path fixtures |
| Manifest is missing, unreadable, outside the bounded location, or source-mismatched | Blocker | Preserve active slice and manifest; emit only a sanitized command result because no safe matching manifest can be updated | Missing, unreadable, outside-root, and source-mismatch fixtures |
| Existing active slice is empty or `Complete` | Replaceable | Generate and self-check a new Draft | Empty and Complete active-slice fixtures |
| Existing active slice is Draft, Approved, In progress, Blocked, or Ready for review | Blocker | Preserve target byte-for-byte and record blocker | One fixture for each unresolved status |
| Neutral schema or selected required document missing/inaccessible | Blocker | Preserve target; record relative sanitized path | Missing schema and injected-reader failure fixtures |
| Generated structural or source-contract comparison fails | Blocker | Do not replace target; record failed self-check | Missing heading, invalid status, broken traceability, and altered/omitted-section fixtures |
| All guards and self-checks pass | Generated Draft | Write only `docs/current-slice.md`; update only same-Issue manifest output record | End-to-end deterministic success and repeat-write fixtures |

## Implementation plan

1. Extend `scripts/prepare-slice.ps1` with a mutually exclusive `GenerateDraftSlice` parameter set and an `Invoke-DraftSliceGeneration` orchestration function. Reuse the normalized-contract reader and keep existing Issue-normalization and context-manifest invocations unchanged. Require local normalized JSON, matching manifest path, and repository root; keep output fixed to the active-slice path.
2. Add bounded readers for the matching UTF-8 manifest, neutral schema, current slice, and local phase draft. Parse only the manifest headings/records and YAML front matter needed for the declared guards. Reuse repository-relative path validation; never crawl source, tests, skills, sibling repositories, or arbitrary Markdown.
3. Implement ordered guard evaluation for source state/readiness, normalized exact local dependency mapping plus read-only dependency state, manifest source/readiness/blocker/selected-path integrity, current-slice replaceability, and required local inputs. Return accumulated sanitized blocker records; update a manifest only after its path and source identity are safely verified.
4. Implement deterministic Draft rendering from the neutral schema plus normalized source contract. Preserve required source sections exactly; add provenance-labeled selected-document links, fixed validation/review guidance, and explicit human-review warnings for any execution detail not established by selected documents. Do not generate approval evidence, implementation status, or semantic assertions.
5. Add generated-slice structural and source-to-slice comparison functions. Validate the Draft before writing and use a temporary sibling file plus replacement only after all guards and checks pass. On success, write UTF-8 without BOM to `docs/current-slice.md` and update the matching manifest's output record; on any failure, preserve the prior active slice and update only a safely identified matching manifest.
6. Extend `tests/prepare-slice.ps1` and `tests/fixtures/context/` with normalized-contract, manifest, phase-draft, current-slice, schema, and dependency-reader branches. Cover every decision-table row, exact source preservation, deterministic repeat generation, target and cross-Issue manifest isolation, no GitHub mutation, and no approval/implementation transition.
7. Keep command output limited to source Issue, generated/blocked state, counts, output path, manifest path, and sanitized blocker summaries. Do not modify `README.md` or governing project/design/architecture/decision/testing documents in this slice; Issue #11 owns the integrated operator workflow documentation.

## Expected files

- `scripts/prepare-slice.ps1`
- `tests/prepare-slice.ps1`
- `tests/fixtures/context/`
- `docs/current-slice.md` when Draft-generation mode is explicitly run against a permitted target
- `docs/context-manifests/<issue-number>.md` when Draft-generation mode records its result

## Documentation impact

| Source | Impact | Required action |
| --- | --- | --- |
| `README.md` | None | Issue #11 owns the end-to-end operator workflow documentation. |
| `docs/project.md` | None | Current Phase 1 scope and exit criteria already govern this capability. |
| `docs/architecture.md` | None | Existing project-local dependency direction already permits this extension. |
| `docs/decisions.md` | None | This slice applies existing Issue, lifecycle, and documentation-currency decisions. |
| `docs/design/phase-1-context-and-slice-assistance.md` | None | Implement the approved Draft-generation and guard design without narrowing or broadening it. |
| `docs/testing.md` | None | Existing standards already require deterministic fixtures, command checks, structural validation, and separate review. |
| `templates/docs/current-slice.md` | None | Consume the neutral schema; do not change its project-neutral contract. |

## Validation plan

Run from repository root:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests/prepare-slice.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/validate.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File tests/validate-structure.ps1
```

Manual checks:

- Run Draft-generation mode against a local passing normalized Issue #10 fixture and matching manifest in a temporary repository root; verify the resulting active slice is Draft, has every required heading, preserves every source contract section exactly, links only selected documents, and has pending approval/completion evidence.
- Run each guarded failure branch and verify the pre-existing active-slice hash is unchanged while only the matching Issue manifest receives a relative, sanitized blocker/result record.
- Confirm a complete prior slice may be replaced, every unresolved lifecycle state blocks replacement, and repeated success produces byte-identical Draft content without modifying a second Issue manifest.
- Confirm dependency reads request state only, command mode makes no GitHub mutation, and no path approves a slice, begins implementation, or changes Issue state.
- Inspect generated Draft and manifest output for credentials, tokens, Issue/document body copies beyond preserved contract sections, absolute profile paths, stack traces, and unapproved semantic relevance claims.

## Failure conditions

Stop and revise before approval or implementation if:

- the Ready Issue, normalized contract, matching manifest, approved design, dependency completion, or current-slice state cannot be verified;
- a generated guard needs to infer dependency satisfaction, governing-document relevance, implementation files, API behavior, or semantic equivalence from free text;
- manifest parsing or result update can alter another Issue's manifest, leak full content, credentials, absolute paths, or stack traces, or silently discard an existing blocker;
- an unresolved active slice can be replaced, a failed generated-slice self-check can write output, a missing or source-mismatched manifest can be altered, or a failure can alter the prior active slice;
- output status, ordering, empty-state rendering, source preservation, overwrite behavior, or sanitized failure behavior is unspecified;
- tests depend on live GitHub bodies, mutate GitHub, or omit a material guard or source-to-slice comparison branch; or
- implementing the generator requires a change to product scope, architecture, approved design, durable decision, or testing standard.

## Review checklist

- Does the new mode consume Issue #8 and #9 artifacts rather than duplicating source-Issue parsing or broad document discovery?
- Are source state, readiness, local dependency mapping, manifest integrity, selected-path availability, and active-slice replacement guards bounded, ordered, and testable?
- Does every blocker preserve the active slice and update only the matching manifest with sanitized evidence?
- Does the renderer preserve all five required Issue contract sections exactly, produce a complete Draft schema, and avoid automated approval or implementation claims?
- Are generated execution notes strictly constrained to selected governing documents, with semantic gaps surfaced for human review rather than inferred?
- Do structural and source-to-slice checks distinguish deterministic proof from semantic judgment?
- Do fixture tests cover every decision-table branch, same-Issue idempotency, cross-Issue isolation, and no-GitHub-write behavior?
- Does the documentation-impact assessment remain accurate and leave Issue #11 as owner of operator workflow guidance?

## Approval evidence

**Slice approval:** Approved.

**Slice approved by:** Repository owner (explicit user approval).

**Slice approval basis:** Explicit user approval after the advisory planning review passed.

**Slice approved at:** 2026-07-25.

**Final approval:** Approved.

**Final approved by:** Repository owner.

**Final approval basis:** Explicit user authorization to finalize after implementation, formal validation, and independent review passed.

**Final approved at:** 2026-07-25 11:31 -07:00.

## Completion evidence

**Implementation status:** Complete; implementation, validation, review, final approval, and Issue closure completed.

**Acceptance-criteria status:** All five acceptance criteria demonstrated by focused fixture tests and formal structural validation.

**Files changed:** `scripts/prepare-slice.ps1`, `tests/prepare-slice.ps1`, and `tests/fixtures/context/repository/docs/issues/phase-1/issue-8.md`, `issue-9.md`, and `issue-10.md`.

**Validation results:** Passed the documented Draft-mode parameter-binding check using `scripts/prepare-slice.ps1` with `-GenerateDraftSlice -NoRun`, `tests/prepare-slice.ps1`, `scripts/validate.ps1`, `tests/validate-structure.ps1`, and `git diff --check`. Focused tests demonstrate successful Draft generation, exact source-section preservation, source/readiness, dependency normalization and closed-state, missing-document, unresolved active-slice, and sanitized matching-manifest guards.

**Manual checks:** Temporary-repository end-to-end generation produced a `Draft` with required headings, source traceability, selected-document links, and pending approval/completion evidence. Guarded runs preserved the unresolved active slice and recorded only the matching manifest result; all five unresolved lifecycle statuses were exercised. The public Draft-mode parameter set binds successfully. GitHub mutation and lifecycle-transition paths remain absent from the implementation. Existing project/design/architecture/decision/testing documents were unchanged.

**Documentation-impact result:** No governing-document update is required; the implementation consumes the existing neutral schema and approved design, and the project, architecture, decisions, design, testing, and operator-guidance authorities remain current.

**Review result:** Formal implementation review passed on 2026-07-25. No critical, high, medium, or low findings remain. The review verified Issue #10 traceability, approved-slice scope, governing-rule provenance, deterministic command and guard behavior, exact source-contract preservation, test coverage, sanitized failure handling, lifecycle boundaries, and documentation currency. The Draft-mode parameter-set binding correction found during review was implemented and revalidated; no scope or approved-contract change was required.

**Implementation adjustments or deviations:** Added an internal empty-collection binding allowance for successful manifest updates, fixture-only dependency metadata required to exercise the approved guard contract, and the missing Draft-mode parameter-set bindings found during independent review. No approved behavior or scope changed.

**Known limitations or follow-up Issues:** Issue #11 owns the integrated operator workflow and its user-facing documentation.

**Issue closure:** GitHub Issue #10 closed and verified `CLOSED` on 2026-07-25.

**Implementation summary:** Implemented and finalized guarded Draft-slice generation for GitHub Issue #10. The command consumes the normalized Issue and matching context manifest, accumulates sanitized ordered blockers, preserves unresolved active slices, writes only permitted UTF-8 Draft output after self-checks, and updates only the matching manifest result.

## Dependencies and assumptions

- GitHub Issue #10 is open and all seven readiness confirmations are checked.
- Local phase sequence `01` maps to GitHub Issue #8 and sequence `02` maps to GitHub Issue #9; both are closed.
- `docs/design/phase-1-context-and-slice-assistance.md` remains Approved.
- Dependency-state reads are implementation plumbing for the explicit completion guard; they read only the mapped Issue state and do not parse a form or mutate GitHub.
- The generator may report an explicit preparation warning when selected documents do not justify file-level execution detail. Human review, not generated inference, resolves that warning before a generated Draft is approved.

## Relevant project documents

- `AGENTS.md`
- `docs/project.md`
- `docs/architecture.md`
- `docs/decisions.md`
- `docs/testing.md`
- `docs/design/phase-1-context-and-slice-assistance.md`
- `docs/issues/phase-1/03-generate-guarded-draft-slice.md`
- `templates/docs/current-slice.md`
- `scripts/prepare-slice.ps1`
- `tests/prepare-slice.ps1`
- `skills/prepare-slice/SKILL.md`

## Implementation constraints

- Preserve GitHub Issue #10 goal, scope, non-goals, and acceptance criteria.
- Keep all processing project-local, bounded, deterministic, and inspectable.
- Consume Issue #8's normalized contract and Issue #9's context manifest; do not duplicate their source-Issue parser or broad document discovery responsibilities.
- Do not create a database, run record, retention process, repository crawler, automatic Issue selection, GitHub write path, approval transition, or implementation controller.
- This slice remains `Draft` until a separate approval operation records explicit human approval.
