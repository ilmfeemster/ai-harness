# Phase 1: Assemble bounded context manifests

> **Project operational state:** This is a newly prepared Draft execution package for GitHub Issue #9. It preserves the Issue outcome and does not authorize approval or implementation.

## Status

Draft

## Source Issue

- **Issue:** #9 - Phase 1: Assemble bounded context manifests
- **URL:** https://github.com/ilmfeemster/ai-harness/issues/9

## Context

An Issue parser alone does not identify the local documents that constrain later work. The approved Phase 1 design requires a project-local manifest that records selected documents, design-selection reasoning, candidate exclusions, missing paths, warnings, and blockers without becoming a database or loading unrelated repository content.

## Goal

For a normalized Issue, discover its bounded local governing context and write an inspectable per-Issue context manifest.

## Scope

- Discover the mandatory Phase 1 authority documents and local documents explicitly referenced by a normalized Issue.
- Enumerate local design documents and apply the approved-design selection rules.
- Write `docs/context-manifests/<issue-number>.md` with source traceability, selection reasons, warnings, blockers, and draft-output status.
- Add deterministic fixtures and tests for selection, exclusion, absent documents, Draft-design handling, and manifest overwrite behavior.

## Non-goals

- Do not parse or fetch the Issue contract beyond consuming Issue 01's normalized result.
- Do not replace `docs/current-slice.md`, approve work, or start implementation.
- Do not discover all repository files, sibling repositories, or remote project context.
- Do not add a database, general run-record system, or automated retention process.

## Acceptance criteria

- [ ] For a normalized Issue, the manifest records the mandatory authority sources, Issue-linked local documents, selected designs, and the reason for each selection.
- [ ] Draft designs can be recorded as candidates but are excluded from governing context; approved applicable designs are selected according to the design rules.
- [ ] Missing referenced local documents, inaccessible paths, and ambiguous selection conditions are reported as actionable warnings or blockers.
- [ ] The manifest contains no credentials, tokens, or copied full Issue/document contents and is limited to the Issue's project-local traceability.
- [ ] Deterministic tests cover bounded discovery, design selection, missing-path reporting, and repeat preparation for the same Issue.

## Governing-rule reconciliation

| Rule | Governing source | Slice interpretation | Difference |
| --- | --- | --- | --- |
| Bounded local discovery | Approved Phase 1 design, **Local document inputs** | Read only the fixed authority set, Issue-linked allowed paths, and direct `docs/design/*.md` candidates. | None |
| Design selection and semantic applicability | Approved Phase 1 design, **Local document inputs** and **Risks and open questions**; `skills/prepare-slice/SKILL.md`, **Automated-classification boundary** | An explicitly linked Approved design governs. For the active phase's expected design, use Assumption A-1 below when exact local phase traceability maps the source Issue to that phase; record the assumption prominently in the selection reason and warnings. All other unlinked candidates remain non-governing. | Implementation refinement within authority |
| Draft designs | Approved Phase 1 design, **Local document inputs** | List a Draft design as considered when discovered or linked, emit a warning, and never select it as governing context. | None |
| Missing or inaccessible governing input | Approved Phase 1 design, **Warnings and blockers** | Missing or inaccessible mandatory and allowed Issue-linked files are blockers. Invalid or out-of-bound Issue references are warnings because they are not eligible governing inputs. | Implementation refinement within authority |
| Manifest safety and isolation | Approved Phase 1 design, **Context manifest** | Render references, metadata, classification, and short reasons only; overwrite only the file for the same Issue number. | None |
| Lifecycle and external-state boundary | Issue #9 non-goals; `AGENTS.md` sections 5, 11, and 12 | Manifest mode consumes an already normalized contract and writes its manifest only. It neither calls GitHub nor changes the active slice, Issue state, approval state, or implementation state. | None |

## Existing implementation seam

- `scripts/prepare-slice.ps1` already owns Issue #8 normalization. Its `Get-NormalizedIssue` output supplies the in-memory contract for this Issue; manifest mode must not call its GitHub reader or re-parse an Issue form.
- `tests/prepare-slice.ps1` dot-sources the script with `-NoRun` and tests public functions directly. Extend this focused suite rather than adding a second harness.
- `tests/fixtures/issues/` supplies raw Issue snapshots. Add a distinct `tests/fixtures/context/` tree for normalized contracts and minimal synthetic repository roots, so manifest tests never depend on live GitHub state.

## Component and contract map

| Responsibility | Location | Inputs | Output or side effect |
| --- | --- | --- | --- |
| Read normalized fixture | `scripts/prepare-slice.ps1` | `-NormalizedIssueJsonPath` | One normalized contract; no GitHub access |
| Parse linked paths | `scripts/prepare-slice.ps1` | `RelevantDocuments` text | Ordered valid paths plus rejected-entry warnings |
| Build bounded candidates | `scripts/prepare-slice.ps1` | Contract and explicit repository root | Mandatory, linked, and design candidate records |
| Resolve context | `scripts/prepare-slice.ps1` | Candidates, active phase, and design metadata | Selected, excluded, warnings, blockers, and downstream-ready state |
| Render and write | `scripts/prepare-slice.ps1` | Context model and output root | One deterministic manifest for the source Issue |
| Verify behavior | `tests/prepare-slice.ps1` | Fixtures and temporary output directory | Assertions for every material branch |

## Automated-classification evidence

| Classification | Evidence source | Result when evidence is absent |
| --- | --- | --- |
| Mandatory authority | Fixed list in the approved design; local file existence | Missing or inaccessible path is a blocker. |
| Issue-linked governing document | Exact allowed repository-relative path parsed from normalized `RelevantDocuments` | Invalid or missing reference is excluded and reported. |
| Explicitly linked governing design | Exact Issue-linked design path plus `Approved` status in that design | Draft, missing, or unrecognized design is excluded and reported. |
| Active-phase governing design | `Expected design` metadata in `docs/project.md` | Consider the candidate but do not select it automatically. |
| Active expected design applicable to the source Issue | Assumption A-1: exact GitHub Issue-to-local phase-draft mapping plus matching active-phase metadata is sufficient phase-level applicability evidence for this Phase 1 implementation | Select with the assumption recorded as a warning for human review; do not use free-text similarity. |
| Other unlinked design applicable to the source Issue | No approved structured capability mapping or explicit human confirmation exists in the current contract | Warning and non-governing candidate; do not infer applicability from free text. |
| Dependency `01` complete | Local phase-plan mapping from sequence `01` to Issue #8 plus GitHub Issue #8 state `CLOSED` | Block promotion when completion cannot be verified. |

## Interface contracts

### Command-line mode

```powershell
powershell -NoProfile -File scripts/prepare-slice.ps1 `
  -ContextManifest `
  -NormalizedIssueJsonPath "tests/fixtures/context/normalized/issue-9.json" `
  -RepositoryRoot "." `
  -ManifestOutputRoot "docs/context-manifests"
```

- `-ContextManifest`, `-NormalizedIssueJsonPath`, and `-RepositoryRoot` are required together.
- `-ManifestOutputRoot` defaults to `<RepositoryRoot>/docs/context-manifests`.
- Context-manifest mode accepts a normalized-contract JSON file, not an Issue number or raw Issue snapshot.
- Unit tests invoke object-based functions directly; command tests use only local fixture files.
- Context-manifest mode must not invoke `gh`, `Get-IssueSnapshotFromGitHub`, `Invoke-IssueNormalization`, or Issue-form parsing.

### Internal inputs and path parsing

- `Get-RelevantDocumentPaths -RelevantDocuments <string>` returns ordered records with `Path`, `Original`, `Classification`, and optional `Reason`.
- `Get-ContextCandidates -NormalizedIssue <psobject> -RepositoryRoot <path>` returns mandatory, Issue-linked, and design candidates without recursively enumerating the repository.
- `Resolve-ContextManifest -NormalizedIssue <psobject> -RepositoryRoot <path>` returns selected, considered, warning, blocker, readiness, and output-model records.
- `Write-ContextManifest -Manifest <psobject> -ManifestOutputRoot <path>` renders one file and returns its resolved path.

For each non-empty `RelevantDocuments` line, remove one bullet marker (`-`, `*`, or `+`) and surrounding whitespace. Use the first complete backticked value when present; otherwise accept the trimmed line only if it contains no whitespace and resembles a relative file path. Normalize `\\` to `/`, reject empty values, URLs, rooted paths, drive-qualified paths, directories, and every `..` segment. Deduplicate accepted paths case-insensitively while preserving first spelling and order. Retain each rejected entry as a warning without reading it.

The accepted Issue-linked set is root `AGENTS.md` and `README.md`, plus files under `docs/`, `templates/`, and `.github/ISSUE_TEMPLATE/`. Code, tests, scripts, skills, sibling repositories, and all other paths are warning-and-excluded records.

### Design status and applicability

Enumerate only direct `*.md` children of `docs/design/` in ordinal path order. Read the first non-empty value under `## Status`; recognize `Approved` and `Draft` case-insensitively, and warn and exclude any missing or unrecognized status.

An Approved design is selected when its exact repository-relative path is explicitly linked by the normalized Issue. `docs/project.md` may identify the active phase's expected design; the local phase draft may then map the source Issue number to a phase through its front matter.

**Assumption A-1 — phase-level design applicability:** for this Phase 1 implementation, an open Ready Issue whose retained local phase draft has the exact source Issue number and the same `phase` value as the active phase is treated as applicable to that phase's `Expected design`, when the candidate design is `Approved`. The manifest selects that candidate with reason `approved active-phase design; Assumption A-1`, and adds a warning that A-1 requires human review. This is explicit semantic policy for the Draft, not an assertion that free-text similarity can establish relevance.

An unlinked candidate outside A-1 remains considered-but-not-selected with an actionable warning. Do not add lexical, similarity, ranking, or inferred relevance matching. Draft and unrecognized-status designs are also non-governing candidates.

### Manifest schema, ordering, and failures

Render exactly these headings:

```markdown
# Context Manifest — Issue #<number>

## Preparation
## Source Issue
## Readiness
## Selected governing documents
## Considered but not selected
## Warnings
## Blockers
## Output
```

Order selected mandatory authorities as `AGENTS.md`, `docs/project.md`, `docs/architecture.md`, `docs/decisions.md`, `docs/testing.md`, and `docs/current-slice.md`; then Issue-linked paths in first-seen order; then selected designs by ordinal path. Order excluded design candidates by ordinal path and warnings/blockers by discovery order. Render every empty list as `- None.`

The model records preparation timestamp, tool version, source number/title/URL, optional snapshot identifier, readiness summary, selected and considered records, warnings, blockers, downstream-ready state, and output path. `DownstreamReady` only says that context blockers do not prevent Issue #10 from consuming the manifest; it never asserts slice approval or implementation readiness. Sanitize inaccessible-path failures to a relative path, category, and actionable message; never render stack traces, credentials, tokens, absolute profile paths, or full Issue/document content.

## Deterministic decision rules

| Condition | Classification | Manifest behavior | Test coverage |
| --- | --- | --- | --- |
| Mandatory authority exists | Selected | Fixed-path record with reason `mandatory authority` | Complete fixture root |
| Mandatory authority missing or inaccessible | Blocker | Relative path and actionable reason; downstream-ready false | Missing and injected-reader-failure fixtures |
| Allowed linked file exists | Selected | Reason `linked by source Issue` | First-seen and duplicate fixture |
| Allowed linked file missing or inaccessible | Blocker | Relative path and reason | Missing linked-file fixture |
| Linked entry is invalid or outside allowed set | Warning and excluded | Original entry and rejection reason; do not read it | URL, traversal, source-code, and duplicate fixtures |
| Explicitly linked Approved design exists | Selected | Reason `approved design linked by source Issue` | Linked Approved fixture |
| Active expected Approved design maps through A-1 | Selected with warning | Reason includes `Assumption A-1`; warning requires human review | Exact phase-mapped fixture |
| Active expected design has no exact phase mapping | Warning and excluded | Record that A-1 evidence is incomplete | Missing or mismatched phase-mapping fixture |
| Approved non-active design is unlinked | Considered and excluded | Record that no explicit link establishes governing relevance | Unlinked Approved-design fixture |
| Linked or discovered Draft design | Warning and excluded | Record Draft status and exclusion reason | Draft-design fixture |
| Same source Issue written again | Normal overwrite | Replace only `<output-root>/<issue-number>.md` | Repeat-write isolation fixture |

## Implementation plan

1. Add a mutually exclusive context-manifest parameter set to `scripts/prepare-slice.ps1`. It must load a local normalized-contract JSON file, validate required contract properties, and preserve the existing Issue-number and raw-fixture normalization paths unchanged.
2. Implement the path parser and bounded candidate builder using the accepted-path, normalization, rejection, ordering, and duplicate rules above. Do not enumerate source, test, skill, or sibling-repository content.
3. Read active-phase expected-design metadata from `docs/project.md`, enumerate direct design files, and classify their statuses. Select exact Issue-linked Approved paths. For the expected design only, resolve the exact GitHub Issue-to-local-phase-draft mapping and apply Assumption A-1; record its warning. Keep every other unlinked applicability question non-governing.
4. Build a manifest model that keeps selected and considered records separate, makes every selection reason inspectable, classifies blockers versus warnings, and calculates `DownstreamReady` only from context blockers.
5. Add deterministic Markdown rendering and isolated writing to `docs/context-manifests/<issue-number>.md`. Render empty states and ordering exactly as specified; overwrite only the same source Issue's file.
6. Extend `tests/prepare-slice.ps1` and add local fixtures for parser branches, mandatory and linked inputs, linked Approved and Draft designs, exact and missing A-1 phase mappings, unlinked non-active Approved candidates, sanitized inaccessible reads, deterministic rendering, secret/full-content exclusion, and same-Issue overwrite isolation.
7. Keep command output limited to manifest counts, downstream-ready state, and output path. Do not report Draft-slice generation, approval, or implementation.

## Expected files

- `scripts/prepare-slice.ps1`
- `tests/prepare-slice.ps1`
- `tests/fixtures/context/`
- `docs/context-manifests/` when manifest mode is explicitly run
- `docs/current-slice.md` for lifecycle evidence only; manifest mode must not write it

## Documentation impact

| Source | Impact | Required action |
| --- | --- | --- |
| `README.md` | None | Issue #11 owns the documented end-to-end operator workflow. |
| `docs/project.md` | None | The active Phase 1 scope and exit criteria already govern this capability. |
| `docs/architecture.md` | None | The approved design and architecture already establish the dependency direction. |
| `docs/decisions.md` | None | This slice makes no new durable product or workflow decision. |
| `docs/design/*.md` | None | Implement the approved design; do not narrow or broaden it. |
| `docs/testing.md` | None | Existing Phase 1 standards require the fixture and validation coverage in this slice. |

## Validation plan

Run from repository root:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests/prepare-slice.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/validate.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File tests/validate-structure.ps1
```

Manual checks:

- Run manifest mode from a normalized Issue #9 fixture and inspect every required heading, selected reason, warning, blocker, count, downstream-ready value, and output path.
- Confirm the Phase 1 design is selected because Issue #9 explicitly links it; separately verify that an exactly mapped active expected design is selected with the Assumption A-1 warning and that unmapped or non-active unlinked candidates remain non-governing.
- Confirm Draft, invalid, outside-set, missing, and inaccessible inputs never govern and are classified as specified.
- Repeat one Issue write and verify only that Issue's manifest changes; verify a second Issue manifest remains unchanged.
- Inspect rendered output for credentials, tokens, full source text, absolute profile paths, and stack traces.
- Confirm context-manifest mode makes no GitHub call, does not parse raw Issue forms, change `docs/current-slice.md`, approve a slice, or start implementation.

## Failure conditions

Stop and revise before approval or implementation if:

- the normalized contract lacks required source, goal, context, scope, non-goals, acceptance, dependency, document, or readiness data;
- a material design-selection rule cannot be reconciled with the approved design, Assumption A-1 is not explicit and reviewable, or a lexical, similarity, ranking, or inferred applicability heuristic is introduced;
- discovery expands into a whole-repository crawl or uses an unapproved linked path;
- a Draft, unrecognized, or ambiguous design can govern;
- path normalization, ordering, duplicate handling, output schema, overwrite behavior, or sanitized error handling is unspecified;
- a missing mandatory or linked governing document can be silently selected;
- manifest content can contain secrets, full Issue/document content, absolute profile paths, or stack traces;
- manifest mode calls GitHub, re-parses an Issue form, writes the active slice, or changes approval/implementation state; or
- a material decision branch lacks a deterministic local test.

## Review checklist

- Does the new parameter set preserve the Issue #8 normalizer and GitHub-read boundary?
- Are all considered documents bounded, classified, and explained?
- Do parser acceptance, rejection, normalization, ordering, and duplicate rules match this slice?
- Does every selected design have an inspectable exact Issue-link or Assumption A-1 evidence plus Approved-status reason?
- Is Assumption A-1 prominent, narrowly scoped, and suitable for human approval, while Draft and other unlinked candidates remain non-governing?
- Are warning and blocker classifications actionable and sanitized?
- Is the Markdown schema deterministic, including empty states and overwrite isolation?
- Do fixtures cover every decision-table branch without live GitHub dependence?
- Are active-slice, approval, Issue-state, and implementation boundaries preserved?
- Does the documentation-impact assessment remain accurate after implementation?

## Approval evidence

**Slice approval:** Pending.

**Slice approved by:** Pending.

**Slice approval basis:** Pending.

**Slice approved at:** Pending.

**Final approval:** Pending.

**Final approved by:** Pending.

**Final approval basis:** Pending.

**Final approved at:** Pending.

## Completion evidence

**Implementation status:** Pending human approval and separate implementation authorization.

**Acceptance-criteria status:** Pending.

**Files changed:** `docs/current-slice.md` only, to recreate this Draft.

**Validation results:** Pending structural validation of the recreated Draft.

**Manual checks:** Issue #9 readiness, Issue #8 closure, the approved design, existing normalizer seam, local phase traceability, and test conventions were inspected during preparation.

**Documentation-impact result:** No governing-document update is expected for Issue #9; confirm this during implementation and validation.

**Review result:** Pending.

**Implementation adjustments or deviations:** The prior phrase-match proposal remains removed. Under the updated preparation skill, Assumption A-1 is now explicit, reviewable semantic policy for the single active-phase expected-design branch; it is surfaced as a manifest warning rather than hidden as a heuristic. Other unlinked candidates remain non-governing.

**Known limitations or follow-up Issues:** Issue #10 owns guarded Draft-slice construction; Issue #11 owns the integrated operator workflow.

**Issue closure:** Pending.

**Implementation summary:** Fresh, decision-complete Draft prepared from GitHub Issue #9. No implementation has started.

## Dependencies and assumptions

- The local phase plan maps dependency sequence `01` to GitHub Issue #8; GitHub confirms #8 is closed.
- GitHub Issue #9 is open, has all seven readiness confirmations checked, and remains authoritative for outcome.
- `docs/design/phase-1-context-and-slice-assistance.md` remains Approved.
- The existing unapproved Draft was for this same Issue; the user explicitly requested that it be recreated.
- **Assumption A-1:** exact local phase membership is sufficient evidence to treat the active phase's expected approved design as applicable to that phase's Issue. Human approval of this Draft accepts, rejects, or revises that assumption before implementation.
- Inaccessible-read coverage may use an injected file-reader failure or equivalent deterministic test seam instead of changing file-system permissions.

## Relevant project documents

- `AGENTS.md`
- `docs/project.md`
- `docs/architecture.md`
- `docs/decisions.md`
- `docs/testing.md`
- `docs/design/phase-1-context-and-slice-assistance.md`
- `docs/issues/phase-1/02-assemble-context-manifest.md`
- `scripts/prepare-slice.ps1`
- `tests/prepare-slice.ps1`
- `skills/prepare-slice/SKILL.md`

## Implementation constraints

- Preserve Issue #9's goal, scope, non-goals, and acceptance criteria.
- Keep all processing project-local, bounded, deterministic, and inspectable.
- Consume Issue #8's normalized contract; do not duplicate Issue reading or form parsing.
- Do not create a general database, run record, retention process, repository crawler, or automation controller.
- This slice remains `Draft` until a separate approval operation records human approval.
