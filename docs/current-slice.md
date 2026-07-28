# Phase 1: Deliver the manual slice-preparation workflow

> **Project-owned operational state:** This is the Complete execution package for GitHub Issue #11. Final approval is recorded and the source Issue is closed.

## Status

Complete

## Source Issue

- **Issue:** #11 - Phase 1: Deliver the manual slice-preparation workflow
- **URL:** https://github.com/ilmfeemster/ai-harness/issues/11

## Context

Issues #8, #9, and #10 already provide normalized Issue contracts, bounded context manifests, and guarded Draft rendering. They remain separate command modes. Phase 1 needs one documented, manually invoked foreground command that composes those capabilities for a single explicit Ready Issue, writes only the existing per-Issue manifest and permitted Draft slice, and leaves approval and implementation under human control.

## Goal

Deliver and exercise one documented local command that prepares an inspectable context manifest and a Draft slice from one explicit Ready GitHub Issue.

## Scope

- Add one foreground integrated preparation mode that reads one explicitly supplied Issue through the existing read-only GitHub client, normalizes it in memory, writes its context manifest, and invokes the existing guarded Draft-generation path.
- Define compact, sanitized success and failure results for prerequisite, parser, discovery, manifest-write, dependency, and active-slice guard outcomes.
- Add deterministic end-to-end workflow fixtures for successful preparation and blocked preparation without live GitHub access or GitHub mutation.
- Document prerequisites, command invocation, outputs, warnings/blockers, and the required Draft-to-approval handoff in the repository README and current Phase 1 project/testing state.

## Non-goals

- Do not select an Issue automatically, prepare multiple Issues, schedule background work, or add configuration for batch execution.
- Do not implement from a generated slice, approve a slice, change Issue state, run validation or repair for generated work, or close Phase 1 automatically.
- Do not add remote services, persistent workflow state, databases, cross-repository control, or general-purpose agent abstractions.
- Do not change the supported Issue forms, context-selection rules, Draft-rendering rules, lifecycle states, or the existing standalone component modes.

## Acceptance criteria

- [ ] An operator can invoke one documented local path for an explicit Ready Issue and receive an inspectable context manifest plus a Draft slice when all guards pass.
- [ ] The integrated workflow reports actionable prerequisite, parser, discovery, and guard failures without overwriting an unresolved active slice or changing GitHub state.
- [ ] Documentation makes clear that the output remains Draft and requires explicit human approval before implementation authorization.
- [ ] Focused tests and the repository structural validation pass for successful and blocked end-to-end preparation scenarios.
- [ ] Manual review confirms the workflow stays project-local, does not select work automatically, and preserves existing validation, review, and finalization boundaries.

## Governing-rule reconciliation

| Rule | Governing source | Slice interpretation | Difference |
| --- | --- | --- | --- |
| Explicit work selection and foreground execution | GitHub Issue #11; `AGENTS.md` sections 5, 7, and 11; approved Phase 1 design, **Design summary** and **Preparation behavior and guards** | The only new public workflow mode requires an explicit positive Issue number and runs synchronously in the current repository. It performs no discovery of candidate Issues and no background work. | None |
| Read-only GitHub boundary | GitHub Issue #11 non-goals; approved Phase 1 design, **Source Issue** and **Boundaries and dependency direction** | Reuse the existing `gh issue view` reader for the source and mapped dependency state only. The new orchestration path contains no GitHub mutation command. | None |
| Existing component ownership | Issues #8, #9, and #10; approved Phase 1 design | Compose existing normalization, bounded context-manifest, and guarded Draft-generation responsibilities. Do not duplicate Issue-form parsing, broad discovery, or Draft policy. | None |
| Draft and approval boundary | `AGENTS.md` sections 5, 11, and 12; `docs/decisions.md`, **Slice lifecycle uses explicit approval states** | Successful workflow output remains `Draft`; README handoff directs human review and the separate `approve-slice` operation. The command neither approves nor authorizes implementation. | None |
| Context and active-slice guard handling | Approved Phase 1 design, **Warnings and blockers** and **Preparation behavior and guards**; Issue #10 outcome | A blocked normalized/discovery/guarded run may write or update only the matching manifest when its identity is known and safe; it never replaces an unresolved `docs/current-slice.md`. Pre-normalization failures write neither artifact. | Implementation refinement within authority |
| Deterministic command interface | `AGENTS.md` section 11; `skills/prepare-slice/SKILL.md`, **Deterministic interface requirement** | Use one fixed operator command and fixed repository-relative outputs. Test isolation uses internal readers and temporary roots, not additional public paths or test switches. | Implementation refinement within authority |
| Documentation currency | `AGENTS.md` section 5.6; GitHub Issue #11 scope; `docs/testing.md` | Update operator guidance, current Phase 1 state, and Phase 1 workflow-test standards in the same slice. Architecture, decisions, and approved design do not change. | None |

## Existing implementation seam

- `scripts/prepare-slice.ps1` currently exposes three separate modes: Issue normalization through `Invoke-IssueNormalization`, context-manifest writing through `Invoke-ContextManifest`, and guarded Draft creation through `Invoke-DraftSliceGeneration`.
- `Get-IssueSnapshotFromGitHub` is the sole source-Issue reader and uses `gh issue view`; `Get-DraftDependencyState` reads only mapped dependency states. Neither component provides a GitHub write path.
- `Resolve-ContextManifest` already accepts an in-memory normalized contract, while `Invoke-DraftSliceGeneration` currently reads that contract from JSON. Refactor only as needed to let the integrated workflow pass the same validated in-memory contract to the existing guarded generation behavior.
- `tests/prepare-slice.ps1` dot-sources the script and uses temporary fixture repositories plus injected readers. `tests/fixtures/issues/` contains normalized Issue-form snapshots, and `tests/fixtures/context/` provides the bounded local authority set.
- `README.md` currently describes Phase 1 only at a maturity level; it has no operator prerequisites, command, artifact, blocker, or approval-handoff instructions.

## Component and contract map

| Responsibility | Location | Inputs | Output or side effect |
| --- | --- | --- | --- |
| Integrated operator command | `scripts/prepare-slice.ps1` | `-PrepareDraftSlice` and one explicit Issue number, invoked from repository root | Compact workflow result; no automatic Issue selection or GitHub mutation |
| Source normalization | existing Issue reader and normalizer | Read-only source snapshot | Validated in-memory normalized contract, or sanitized pre-normalization blocker |
| Context preparation | existing context resolver and writer | Normalized contract and repository root | Only `docs/context-manifests/<issue-number>.md` for a valid normalized source |
| Guarded Draft generation | existing Draft helper, refactored only for in-memory contract reuse | Validated contract, matching manifest, repository root | Only permitted `docs/current-slice.md` Draft plus matching manifest result update |
| Workflow result rendering | `scripts/prepare-slice.ps1` | Stage outcomes and existing sanitized blocker records | Stable JSON result with no Issue body, document contents, credentials, absolute paths, stack traces, or approval claims |
| End-to-end workflow tests | `tests/prepare-slice.ps1` and fixtures | Injected source and dependency readers, temporary repository roots | Success and blocked workflow evidence without live GitHub reads or writes |
| Operator documentation | `README.md`, `docs/project.md`, `docs/testing.md` | Approved command contract and lifecycle rules | Accurate prerequisites, outputs, boundaries, and workflow-test standards |

## Interface contracts

### Operator command

Run from the repository root:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/prepare-slice.ps1 -PrepareDraftSlice -IssueNumber 11
```

- `-PrepareDraftSlice` is a new mutually exclusive command mode. `-IssueNumber` is mandatory, must be a positive integer, and is the sole work-selection input.
- The repository root is the current working directory. The public mode exposes no manifest path, normalized-JSON path, output path, fixture path, dependency-state override, batch input, or configuration parameter.
- The command requires an available, authenticated GitHub CLI with read access to the explicit Issue and its mapped dependencies. It reads only the source Issue snapshot and dependency `state` fields.
- Existing Issue-normalization, context-manifest, and Draft-generation modes remain callable with their current parameter contracts. The integrated mode does not alter their outputs or broaden their responsibilities.

### Ordered behavior and side effects

1. Resolve the current working directory as the repository root and validate the explicit Issue number.
2. Read and normalize the source Issue through the existing read-only reader. If the GitHub CLI is unavailable, unauthenticated, unreadable, the Issue is closed, unsupported, or required form data/readiness is invalid, return a sanitized `Normalization` blocker result and write neither manifest nor active slice.
3. For a valid normalized contract, resolve bounded context using the existing selector and write or overwrite only `docs/context-manifests/<issue-number>.md` in UTF-8 without BOM. If that manifest has existing context blockers or is not downstream-ready, return a `Context` blocker result and preserve the active slice without invoking Draft generation.
4. Only when context is downstream-ready, pass that same in-memory validated contract and the matching manifest identity to the guarded Draft-generation helper. Preserve its dependency, selected-document, source-identity, schema, self-check, and active-slice rules exactly.
5. When all guards pass, write only `docs/current-slice.md` with status `Draft` and update only the matching manifest output record. When any context or Draft guard blocks, preserve `docs/current-slice.md` byte-for-byte and leave a sanitized result in only the matching manifest when safely writable.
6. Return one compact JSON object. The command never changes a GitHub Issue, changes a slice to `Approved`, begins implementation, runs validation, repairs code, selects another Issue, or writes outside the two declared project-owned output paths.

### Workflow result schema

The command writes one JSON object to standard output with these fields:

| Field | Type | Meaning |
| --- | --- | --- |
| `IssueNumber` | integer | Explicit requested source Issue number |
| `Prepared` | boolean | `true` only when a Draft slice was written |
| `Stage` | string | `Normalization`, `Context`, or `Draft` stage that produced the final result |
| `ManifestPath` | repository-relative string or `null` | Matching manifest path only when a normalized source exists |
| `DraftPath` | `docs/current-slice.md` or `null` | Fixed path only when a Draft was written |
| `BlockerCount` | integer | Number of sanitized blockers |
| `Blockers` | array | Category, optional Issue number or repository-relative path, and actionable sanitized message |

Success emits `Prepared: true`, `Stage: "Draft"`, an empty `Blockers` array, `ManifestPath: "docs/context-manifests/<issue-number>.md"`, and `DraftPath: "docs/current-slice.md"`. A blocked run emits `Prepared: false`, never claims approval or implementation, and uses `DraftPath: null`.

### Failure, normalization, and idempotency rules

| Condition | Result | Artifact behavior | Test coverage |
| --- | --- | --- | --- |
| GitHub CLI missing, authentication/read failure, closed source, unsupported form, missing required field, or unchecked readiness | `Normalization` blocker | No manifest and no active-slice write | Injected reader and source-snapshot failure cases |
| Valid source but context discovery reports missing/inaccessible required authority or other existing context blocker | `Context` blocker | Write/update only same-Issue manifest; preserve active slice | Temporary-root discovery-blocked case |
| Matching manifest, dependency, selected-document, schema, self-check, or unresolved-active-slice guard fails | `Draft` blocker | Existing Issue #10 behavior: preserve active slice; update only safe matching manifest | Temporary-root guarded workflow case |
| All existing guards pass | `Draft` success | Write Draft active slice and matching manifest result only | Temporary-root end-to-end success case |
| Repeat after resetting the prior active slice to `Complete` with identical source and local inputs | same success result except preparation timestamp | Draft content is byte-identical; only the same manifest is overwritten | Determinism and target-isolation case |

The workflow must not reinterpret readiness, dependencies, document relevance, design applicability, or semantic equivalence. It delegates those decisions to the existing components and surfaces their blockers or warnings.

## Implementation plan

1. In `scripts/prepare-slice.ps1`, add the `PrepareDraftSlice` parameter set and command dispatcher branch. Keep the public surface limited to the mode switch and existing positive `IssueNumber`; resolve the repository root from the current directory.
2. Add a workflow orchestrator and small result/blocker constructors in `scripts/prepare-slice.ps1`. It must call the existing GitHub reader/normalizer, context resolver/writer, and guarded Draft path in the declared order, return the fixed JSON schema, and catch only expected workflow failures into sanitized stage-specific results.
3. Refactor the existing Draft orchestration internally so both the JSON-file mode and integrated workflow use one guarded generation implementation that receives a validated normalized contract. Preserve the existing file-mode contract and all Issue #10 guard ordering, manifest isolation, UTF-8 atomic write, restoration, and output semantics.
4. Add internal reader injection only to workflow-level functions needed by `tests/prepare-slice.ps1`; do not expose test substitutes through the command line. Add a source-Issue fixture for the manual workflow and minimal phase metadata/authority files needed to map Issue #11 dependencies to closed test states.
5. Extend `tests/prepare-slice.ps1` with direct end-to-end workflow cases: successful manifest plus Draft output, a pre-normalization failure with no writes, a context/discovery-blocked run, and an unresolved-active-slice/dependency-guarded run. Assert the exact result schema, same-Issue-only writes, stable Draft source sections, no approval evidence, no GitHub mutation calls, and repeat behavior after a permitted `Complete` reset.
6. Update `README.md` with one Phase 1 operator section: GitHub CLI/read-access prerequisite, the exact command, required current-slice/dependency conditions, manifest and Draft locations, how warnings/blockers are reported, and the separate human review/`approve-slice`/implementation authorization handoff.
7. Update `docs/project.md` to describe the delivered manual foreground workflow while retaining Phase 1 as active until a separate phase operation records any transition. Update `docs/testing.md` to require the integrated workflow success and blocked temporary-root cases. Do not update architecture, decisions, or the approved design.

## Expected files

- `scripts/prepare-slice.ps1`
- `tests/prepare-slice.ps1`
- `tests/fixtures/issues/`
- `tests/fixtures/context/`
- `README.md`
- `docs/project.md`
- `docs/testing.md`
- `docs/current-slice.md` when the integrated command runs successfully against a permitted target
- `docs/context-manifests/<issue-number>.md` when the integrated command has a valid normalized source

## Documentation impact

| Source | Impact | Required action |
| --- | --- | --- |
| `README.md` | Update required in this slice | Add one operator-facing Phase 1 preparation command, prerequisites, outputs, blockers, and human handoff. |
| `docs/project.md` | Update required in this slice | Record that Issue #11 delivers the manual foreground workflow without closing the phase automatically. |
| `docs/architecture.md` | None | Existing local foreground-tool boundary and dependency direction already govern the composition. |
| `docs/decisions.md` | None | Existing Issue authority, human approval, and lifecycle decisions govern the workflow. |
| `docs/design/phase-1-context-and-slice-assistance.md` | None | Implement its final suggested sequencing step without changing approved behavior. |
| `docs/testing.md` | Update required in this slice | Record the required integrated success and blocked workflow evidence. |
| `templates/docs/current-slice.md` | None | Continue to consume the neutral schema; do not alter it. |

## Acceptance-to-validation mapping

| Acceptance criterion | Automated evidence | Manual evidence |
| --- | --- | --- |
| One documented command produces manifest and Draft | Temporary-root workflow success fixture asserts JSON result, matching manifest, Draft status, and exact source sections | Follow README command against an explicit Ready Issue only after confirming it is safe to replace the active slice |
| Actionable failures preserve state and GitHub | Injected source, discovery, dependency, and active-slice blocked fixtures assert result stage, sanitized blockers, same-Issue-only writes, and unchanged active-slice bytes | Inspect that the operator command contains no GitHub mutation and failure output contains no credentials, body copies, stack traces, or absolute paths |
| Draft approval boundary is documented | README assertions or content checks verify Draft, review, approve-slice, and separate implementation authorization wording | Read the operator section and confirm it does not claim automatic approval, implementation, validation, review, or closure |
| Focused and structural checks pass | `tests/prepare-slice.ps1`, `scripts/validate.ps1`, and `tests/validate-structure.ps1` | Inspect result artifacts and changed-file scope |
| Project-local manual boundary | Fixture tests use only temporary local roots and injected readers; no test requires live GitHub or writes GitHub state | Review command surface, README, and implementation for automatic selection, batch/background behavior, remote service state, or lifecycle transitions |

## Validation plan

Run from repository root:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests/prepare-slice.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/validate.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File tests/validate-structure.ps1
```

Manual checks:

- In a disposable local repository root with an injected or controlled Ready fixture, invoke the integrated workflow once and verify only its manifest and a Draft active slice are written.
- Verify prerequisite, parser, context/discovery, dependency, and unresolved-active-slice failures return actionable sanitized results and preserve the prior active-slice bytes.
- Read the README operator section and confirm an explicit Issue number, GitHub read prerequisite, artifact locations, warnings/blockers, Draft status, human review, separate approval, and separate implementation authorization are all clear.
- Inspect the command surface and result output for automatic selection, GitHub mutation, background/batch behavior, credentials, absolute paths, Issue/document body copies, stack traces, or lifecycle claims beyond Draft creation.
- Confirm project and testing documents describe the implemented workflow accurately but do not claim Phase 1 is closed or a generated Draft is approved.

## Failure conditions

Stop and revise before approval or implementation if:

- a single explicit Issue command cannot compose the existing components without changing their documented contracts or duplicating their policy;
- a failure must invent readiness, dependency, relevance, design-applicability, semantic-equivalence, approval, or implementation policy;
- the command needs a public fixture, output-path, manifest-path, repository-selection, or dependency-override parameter not required by the Issue or approved design;
- source-read, parser, discovery, manifest, guard, or write failures can overwrite an unresolved active slice, mutate another Issue manifest, or leak credentials, absolute paths, Issue bodies, document bodies, or stack traces;
- README/project/testing updates would assert a lifecycle transition, Phase closure, or operator behavior that the implementation does not establish; or
- focused temporary-root tests cannot exercise both successful and blocked integrated behavior without live GitHub mutation.

## Review checklist

- Does the new mode accept exactly one explicit Issue and remain a local foreground command?
- Does it reuse the existing normalizer, context resolver/writer, and guarded Draft behavior instead of recreating their rules?
- Are all side effects limited to the matching manifest and a permitted Draft active slice, with pre-normalization failures writing neither?
- Are source, context, dependency, manifest, active-slice, and self-check failures sanitized, actionable, and covered by bounded tests?
- Is the result schema stable, minimal, and free of credentials, copied bodies, absolute paths, stack traces, approval claims, and implementation claims?
- Does the README make GitHub read prerequisites, outputs, blockers, and human approval/implementation handoffs unambiguous?
- Do project and testing documents become current without closing Phase 1, changing architecture, changing decisions, or revising the approved design?
- Are the Phase 1 manual, project-local, no-auto-selection, validation, review, and finalization boundaries preserved?

## Slice-quality assessment

- **Missing execution decisions:** None. The command surface, stage order, artifact ownership, failure behavior, result schema, test substitutions, documentation changes, and acceptance evidence are specified.
- **Incorrect assumptions:** None identified. Explicit Issue #11 readiness and the closed prerequisite Issue states were verified from GitHub; the repository-root invocation convention and GitHub CLI read access are stated assumptions.
- **Unnecessary instructions:** None. The slice preserves existing component modes and limits the new public interface to one explicit Issue command.
- **Discovery required beyond the slice:** None. Implementation can use the identified script functions, focused tests, fixture roots, README, project document, and testing document.
- **Recommended preparation improvement:** None. Formal human approval remains required before implementation.

## Approval evidence

**Slice approval:** Approved.

**Slice approved by:** Repository owner.

**Slice approval basis:** Explicit user approval of the reviewed Draft slice on 2026-07-27.

**Slice approved at:** 2026-07-27 17:11 -07:00.

**Final approval:** Approved.

**Final approved by:** Repository owner.

**Final approval basis:** Explicit user authorization to finalize after implementation, formal validation, and independent review passed.

**Final approved at:** 2026-07-27 17:21 -07:00.

## Completion evidence

**Implementation status:** Complete; implementation, validation, review, final approval, and Issue closure completed.

**Acceptance-criteria status:** All five criteria passed through focused workflow tests, structural validation, documentation inspection, and manual boundary checks.

**Files changed:** `scripts/prepare-slice.ps1`, `tests/prepare-slice.ps1`, `tests/fixtures/issues/manual-workflow.json`, `tests/fixtures/context/repository/docs/issues/phase-1/issue-11.md`, `README.md`, `docs/project.md`, and `docs/testing.md`.

**Validation results:** Passed `tests/prepare-slice.ps1`, public `-PrepareDraftSlice -IssueNumber 11 -NoRun` parameter binding, `scripts/validate.ps1`, `tests/validate-structure.ps1`, and `git diff --check`. Focused workflow tests cover success, source prerequisite failure, context discovery failure, unresolved active-slice preservation, sanitized result output, and no external GitHub mutation.

**Manual checks:** Temporary-root focused tests exercise integrated success, pre-normalization and parser failures with no writes, context-discovery failure, unresolved-active-slice preservation, repeated byte-identical success after a permitted `Complete` reset, and preservation of another Issue manifest. The public `-PrepareDraftSlice -IssueNumber` parameter set binds without executing the workflow. GitHub mutation, automatic selection, approval, implementation, validation, review, and closure paths are absent from the implementation.

**Documentation-impact result:** README operator guidance, current project state, and integrated workflow testing standards are updated and consistent with the implementation. Architecture, decisions, approved design, and neutral templates remain unchanged and current.

**Review result:** Formal independent implementation review passed on 2026-07-27 with no critical, high, medium, or low findings. The review verified Issue #11 traceability, approved-scope preservation, reuse of the existing component seams, result and side-effect contracts, test coverage, documentation currency, and all lifecycle boundaries. The added parser, repeat/idempotency, and cross-Issue isolation assertions resolved the only evidence gap identified during review.

**Implementation adjustments or deviations:** Added internal in-memory normalized-contract reuse so the integrated mode composes existing behavior without a temporary public JSON path; added sanitized workflow result staging, internal test readers, and explicit parser/repeat/isolation evidence. No approved outcome, public scope, architecture, or governing rule changed.

**Known limitations or follow-up Issues:** No Phase 2 selection or phase-closure operation is authorized by this slice.

**Issue closure:** GitHub Issue #11 closed and verified `CLOSED` on 2026-07-27.

**Implementation summary:** Implemented and finalized the single foreground `-PrepareDraftSlice -IssueNumber` workflow, composing read-only normalization, bounded context-manifest writing, and guarded Draft generation while preserving the human approval and implementation boundaries.

## Dependencies and assumptions

- GitHub Issue #11 is open and its seven readiness confirmations are checked.
- Local phase sequence `01`, `02`, and `03` maps to GitHub Issues #8, #9, and #10 respectively; all are closed.
- `docs/design/phase-1-context-and-slice-assistance.md` remains Approved.
- The documented operator command runs from the repository root. This is a fixed repository convention, not a new repository-selection policy.
- GitHub CLI installation, authentication, and read access are environmental prerequisites. The workflow reports their failure but neither prompts for nor stores credentials.

## Relevant project documents

- `AGENTS.md`
- `README.md`
- `docs/project.md`
- `docs/architecture.md`
- `docs/decisions.md`
- `docs/testing.md`
- `docs/design/phase-1-context-and-slice-assistance.md`
- `docs/issues/phase-1/04-deliver-preparation-workflow.md`
- `scripts/prepare-slice.ps1`
- `tests/prepare-slice.ps1`
- `skills/prepare-slice/SKILL.md`

## Implementation constraints

- Preserve GitHub Issue #11 goal, scope, non-goals, and acceptance criteria.
- Reuse the existing component behaviors and project-local output locations; do not introduce a new workflow store or a second active slice.
- Keep test substitutions internal and fixture-based; do not expose them through the public command.
- A generated active slice remains `Draft` until a separate explicit approval operation records human approval.
