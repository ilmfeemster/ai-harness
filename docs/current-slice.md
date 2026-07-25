# Phase 1: Assemble bounded context manifests

> **Project operational state:** This file is the active execution package for the current project. It is a Draft translation of GitHub Issue #9 and does not authorize implementation.

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

## Governing-rule reconciliation

| Rule | Governing source | Slice interpretation | Difference |
| --- | --- | --- | --- |
| Bounded authority discovery | `docs/design/phase-1-context-and-slice-assistance.md` — Local document inputs | Consider mandatory authorities, Issue-linked project documents, and local design candidates only. | None |
| Approved-design selection | Approved Phase 1 design — Local document inputs | Select an approved design when explicitly linked, or when it is the approved design for the active phase and its stated capability matches the Issue. Surface ambiguity rather than guessing. | None |
| Draft-design handling | Approved Phase 1 design — Local document inputs and warnings | Record Draft designs as excluded candidates with a warning; never use them as governing input. | None |
| Missing referenced documents | Approved Phase 1 design — Warnings and blockers | A missing Issue-linked governing document is a blocker. Missing mandatory authority paths are also blockers because every run requires them. | Implementation refinement within authority |
| Manifest safety | Approved Phase 1 design — Context manifest | Store references, metadata, statuses, reasons, and counts; omit secrets and copied full content. | None |
| Per-Issue overwrite | Approved Phase 1 design — Context manifest | Replace only `docs/context-manifests/<issue-number>.md` for the same Issue. | None |
| No GitHub or active-slice write | Issue #9 non-goals and approved design boundaries | Manifest mode consumes a normalized contract and writes only the manifest. | None |

## Existing implementation seam

- `scripts/prepare-slice.ps1` is the sole Phase 1 entry point. It exposes `Invoke-IssueNormalization`, `Get-NormalizedIssue`, and fixture-backed input. Extend it without changing the normalizer's GitHub-read behavior.
- `tests/prepare-slice.ps1` dot-sources the tool with `-NoRun` and directly tests functions. Extend it rather than adding another harness.
- `tests/fixtures/issues/` establishes the JSON-fixture convention. Add a separate context fixture subtree for normalized contracts and synthetic document trees.

## Component and contract map

| Responsibility | Location | Input | Output or side effect |
| --- | --- | --- | --- |
| Load normalized contract | `scripts/prepare-slice.ps1` | JSON fixture for CLI use or object from Issue #8 for internal use | Normalized contract only; no Issue fetch or form parsing |
| Parse Issue-linked paths | `scripts/prepare-slice.ps1` | `RelevantDocuments` Markdown | Ordered, deduplicated, validated repository-relative file paths plus rejected entries |
| Discover bounded candidates | `scripts/prepare-slice.ps1` | Normalized contract and explicit repository root | Mandatory authorities, Issue-linked records, and local design candidates |
| Classify and select context | `scripts/prepare-slice.ps1` | Candidates, active phase, and design metadata | Selected, excluded, warnings, blockers, and downstream-ready flag |
| Render and write manifest | `scripts/prepare-slice.ps1` | Manifest model and output root | One deterministic Markdown file for the source Issue |
| Verify behavior | `tests/prepare-slice.ps1` | Local normalized-contract and document-tree fixtures | Assertions for every material branch |

## Interface contracts

### Internal functions

- `Get-RelevantDocumentPaths -RelevantDocuments <string>` returns ordered records containing `Path`, `Original`, and optional rejection reason.
- `Get-ContextCandidates -NormalizedIssue <psobject> -RepositoryRoot <path>` returns mandatory, Issue-linked, and design candidate records.
- `Resolve-ContextManifest -NormalizedIssue <psobject> -RepositoryRoot <path>` returns the classified manifest model.
- `Write-ContextManifest -Manifest <psobject> -ManifestOutputRoot <path>` writes and returns the manifest path.

Equivalent focused names are acceptable when responsibilities and tests remain equivalent.

### Command-line mode

```powershell
powershell -NoProfile -File scripts/prepare-slice.ps1 `
  -ContextManifest `
  -NormalizedIssueJsonPath "tests/fixtures/context/normalized/issue-9.json" `
  -RepositoryRoot "." `
  -ManifestOutputRoot "docs/context-manifests"
```

Rules:

- `-ContextManifest`, `-NormalizedIssueJsonPath`, and `-RepositoryRoot` are required together.
- `-ManifestOutputRoot` defaults to `<RepositoryRoot>/docs/context-manifests`.
- CLI mode accepts a JSON path, not an in-memory object.
- Unit tests call object-based functions directly.
- Manifest mode must not call `gh`, `Invoke-IssueNormalization`, or the Issue-form parser.

### `RelevantDocuments` parsing

For each non-empty line:

1. remove one Markdown bullet prefix (`-`, `*`, or `+`) and surrounding whitespace;
2. when a complete backticked value exists, use the first backticked value;
3. otherwise accept the whole trimmed line only when it contains no whitespace and resembles a repository-relative file path;
4. normalize `\` to `/`;
5. reject URLs, rooted paths, drive-qualified paths, empty values, directories, and any `..` segment;
6. deduplicate case-insensitively while preserving first-seen spelling and order;
7. retain rejected entries as warning records without reading them.

### Allowed Issue-linked set

Accept files under:

- repository root only for `AGENTS.md` and `README.md`;
- `docs/`;
- `templates/`;
- `.github/ISSUE_TEMPLATE/`.

References to source code, tests, scripts, skills, sibling repositories, or other paths are warning-and-excluded records unless a later approved design expands the set.

### Design status and applicability

- Enumerate only `*.md` files directly under `docs/design/`.
- Read the first value under `## Status`.
- Recognize `Approved` and `Draft` case-insensitively.
- Determine active phase from `docs/project.md`.
- Select an approved design when:
  - explicitly linked by the Issue; or
  - it is the approved design named for the active phase and its problem, goals, or design summary clearly covers the Issue capability.
- When applicability cannot be established mechanically, emit a warning and exclude rather than guessing.
- Draft or unrecognized-status designs never govern.

### Inaccessible paths

A path is inaccessible when it exists but `Get-Item` or `Get-Content` fails with an access, path, or I/O exception.

Record repository-relative path, classification, sanitized exception category, and actionable message. Do not include stack traces, credentials, absolute user-profile paths, or environment secrets.

### Manifest model

The model contains:

- preparation timestamp;
- tool version;
- source number, title, URL, and optional snapshot identifier;
- readiness summary;
- selected records;
- considered-but-not-selected records;
- warnings;
- blockers;
- downstream-ready flag;
- output path and Draft-output status when known.

`DownstreamReady` means only that no context blocker prevents later Issue #10 consumption. It does not mean the Issue or slice is approved or implementation-ready.

### Markdown schema and deterministic order

Render exactly:

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

Ordering:

1. mandatory authorities in fixed order:
   - `AGENTS.md`
   - `docs/project.md`
   - `docs/architecture.md`
   - `docs/decisions.md`
   - `docs/testing.md`
   - `docs/current-slice.md`
2. Issue-linked documents in first-seen order;
3. selected design paths by ordinal path order;
4. excluded design candidates by ordinal path order;
5. warnings and blockers in discovery order.

Render empty lists as `- None.`

## Deterministic decision rules

| Condition | Classification | Manifest behavior | Governing source |
| --- | --- | --- | --- |
| Mandatory authority exists | Selected | Record fixed path and reason `mandatory authority` | Approved Phase 1 design |
| Mandatory authority absent or inaccessible | Blocker | Record path and actionable reason; downstream-ready false | Required local inputs and guards |
| Issue-linked allowed local file exists | Selected | Reason `linked by source Issue` | Approved Phase 1 design |
| Issue-linked allowed file absent or inaccessible | Blocker | Record exact path and reason | Approved blocker rules |
| Parsed path invalid or outside allowed set | Warning and excluded | Record original entry and reason; do not load | Bounded-context rule |
| Explicitly linked Approved design exists | Selected | Reason `approved design linked by source Issue` | Approved design-selection rule |
| Approved active-phase applicable design is unlinked | Selected | Reason `approved active-phase design applicable to Issue` | Approved design-selection rule |
| Active-phase applicability is ambiguous | Warning and excluded | Record ambiguity; do not infer | Approved risk and warning behavior |
| Draft design is linked or discovered | Warning and excluded | Record status and exclusion reason | Approved design-selection rule |
| Design status absent or unrecognized | Warning and excluded | Record ambiguity | Approved warning behavior |
| Same Issue is written again | Normal overwrite | Replace only that Issue file | Approved overwrite rule |

## Implementation plan

1. Extend `scripts/prepare-slice.ps1` with the exact CLI mode and internal responsibilities above. Preserve Issue #8's normalizer and GitHub-read boundary.
2. Implement `Get-RelevantDocumentPaths` according to the parsing and rejection contract.
3. Build mandatory candidates in fixed order, Issue-linked candidates in first-seen order, and direct design candidates in ordinal path order.
4. Read project active-phase metadata and design statuses; apply the explicit-link or applicable-active-phase rule without semantic guessing.
5. Implement `Resolve-ContextManifest` with selected, excluded, warning, blocker, and downstream-ready records.
6. Implement deterministic Markdown rendering with the exact schema and empty-state behavior.
7. Write only the same Issue's manifest under the explicit output root.
8. Extend `tests/prepare-slice.ps1` for every parsing, selection, warning, blocker, safety, ordering, and overwrite branch.
9. Update command help and output to report counts, downstream-ready value, and output path without claiming slice generation or approval.

## File-by-file change plan

| File | Change | Tests and constraints |
| --- | --- | --- |
| `scripts/prepare-slice.ps1` | Add manifest CLI mode, path parsing, discovery, design selection, classification, rendering, and writing. | No GitHub access or Issue parsing in manifest mode. |
| `tests/prepare-slice.ps1` | Add direct-function and CLI-fixture assertions. | No live GitHub dependency. |
| `tests/fixtures/context/` | Add normalized contracts and synthetic project trees. | Cover linked, applicable, Draft, ambiguous, invalid, missing, inaccessible-simulated, ordering, and repeat-write cases. |
| `docs/context-manifests/` | Created only by explicit manifest execution. | References and summaries only. |
| `docs/current-slice.md` | Lifecycle and evidence only. | Manifest operation never writes it. |

## Acceptance-criterion mapping

| Acceptance criterion | Implementation evidence | Validation method |
| --- | --- | --- |
| Authorities, linked documents, designs, and reasons recorded | Candidate and renderer records | Fixture with mandatory files, linked document, linked design, and applicable active-phase design |
| Draft excluded and applicable Approved selected | Status and applicability classifier | Linked Approved, unlinked applicable Approved, Draft, and ambiguous fixtures |
| Missing, inaccessible, and ambiguous conditions actionable | Sanitized warning/blocker records | Missing, rejected-path, simulated inaccessible, no-status, and ambiguous fixtures |
| No secrets or copied full content | Safe model and renderer | Sentinel secret and full-body strings absent |
| Bounded discovery and overwrite | Direct design enumeration and per-Issue writer | Unrelated files untouched and only matching Issue overwritten |

## Expected files

- `scripts/prepare-slice.ps1`
- `tests/prepare-slice.ps1`
- `tests/fixtures/context/`
- `docs/context-manifests/` when explicitly executed
- `docs/current-slice.md` for lifecycle evidence only

## Documentation impact

| Source | Impact | Required action |
| --- | --- | --- |
| `README.md` | None | Issue #11 owns final operator workflow documentation. |
| `docs/project.md` | None | Current Phase 1 state already includes this capability. |
| `docs/architecture.md` | None | Approved design already establishes the dependency direction. |
| `docs/decisions.md` | None | No new durable decision beyond the design. |
| `docs/design/*.md` | None | Implement the approved design without narrowing it. |
| `docs/testing.md` | None | Current Phase 1 standards cover deterministic fixtures and bounded discovery. |

## Validation plan

```powershell
powershell -NoProfile -File tests/prepare-slice.ps1
powershell -NoProfile -File scripts/validate.ps1
powershell -NoProfile -File tests/validate-structure.ps1
```

Manual checks:

- Run manifest mode with Issue #9 normalized input; inspect fixed sections, authorities, links, design reasons, counts, and output path.
- Confirm an unlinked applicable approved active-phase design is selected.
- Confirm ambiguous applicability warns and excludes.
- Cover Draft, invalid path, outside-set path, missing path, and simulated inaccessible read.
- Repeat the same Issue and confirm overwrite isolation.
- Inspect output for tokens, full source content, absolute profile paths, and stack traces.
- Confirm no `gh`, Issue parsing, active-slice replacement, approval, implementation, database, or general run record.

## Failure conditions

Stop and revise before approval or implementation if:

- a decision row cannot be reconciled with authority;
- design selection is narrowed to explicit links only;
- discovery requires a whole-repository crawl;
- manifest mode calls GitHub or Issue parsing;
- Draft or ambiguous design governs;
- path syntax, ordering, duplicate handling, output schema, or error behavior remains unspecified;
- missing context can be silently selected;
- secrets or full contents can enter output;
- repeat preparation can overwrite another Issue;
- the operation writes the active slice or adds a database;
- a material branch lacks a deterministic fixture.

## Review checklist

- Is Issue #8's normalizer and GitHub-read boundary preserved?
- Does every rule match authority?
- Are paths normalized, rejected, and deduplicated exactly?
- Is discovery bounded?
- Are both approved design-selection paths supported?
- Are ambiguity and Draft status excluded without guessing?
- Are all reasons inspectable?
- Is output ordering deterministic?
- Are errors sanitized?
- Is overwrite isolated?
- Are all material branches tested locally?
- Are active-slice, GitHub, approval, and implementation boundaries preserved?

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

**Files changed:** `docs/current-slice.md` only for this re-prepared Draft.

**Validation results:** Not run.

**Manual checks:** Issue #9, the approved design, implementation seam, tests, and fixtures were inspected during preparation.

**Documentation-impact result:** Pending implementation validation; no governing-document update is expected for Issue #9.

**Review result:** Pending.

**Implementation adjustments or deviations:** The explicit-link-only design rule was removed. Interface, ordering, parsing, and error contracts were added.

**Known limitations or follow-up Issues:** Guarded Draft generation remains Issue #10. End-to-end preparation remains Issue #11.

**Issue closure:** Pending.

**Implementation summary:** Decision-complete Draft prepared; implementation has not started.

## Dependencies and assumptions

- Issue #8 is complete and closed.
- The Phase 1 design remains approved.
- `RelevantDocuments` contains submitted Issue-form text.
- Inaccessible-path behavior may use an injected file-reader failure or equivalent deterministic fixture.

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

- Preserve Issue #9 outcome and criteria.
- Keep the operation project-local, bounded, and explainable.
- Consume Issue #8's normalized contract.
- Do not duplicate GitHub reading or Issue-form parsing.
- Do not replace the active slice, change GitHub state, approve, or start implementation.
- This slice remains `Draft` until approved through the dedicated approval operation.
