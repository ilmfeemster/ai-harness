---
phase: "phase-1"
roadmap_phase: "Phase 1 — Context and slice assistance"
status: "Draft"
publication: "Not published"
design: "docs/design/phase-1-context-and-slice-assistance.md"
---

# Phase 1 Work Plan

## Source phase

- **Roadmap phase:** Phase 1 — Context and slice assistance
- **Active project phase:** Harness Phase 1 — Context and slice assistance
- **Project document:** `docs/project.md`
- **Design:** `docs/design/phase-1-context-and-slice-assistance.md` (approved)

## Phase outcome

A human-selected Ready GitHub Issue can be translated into a high-quality, inspectable Draft `docs/current-slice.md` with bounded local context and without starting implementation automatically.

## Exit criteria

- A supported Ready Issue is normalized into a traceable work-item contract.
- Relevant local authorities and approved designs are selected and recorded in a context manifest.
- The harness creates a structurally valid Draft slice that preserves the Issue outcome, scope, non-goals, and acceptance criteria.
- Missing information, unresolved readiness, missing documents, and unresolved active slices prevent replacement and are reported clearly.
- A human reviews and explicitly approves a Draft slice before implementation; existing lifecycle boundaries remain intact.

## Issue sequence

| Order | Draft | Outcome | `depends_on` | Readiness |
| --- | --- | --- | --- | --- |
| 01 | `01-normalize-supported-issues.md` | Read and normalize the bundled Issue forms into a traceable work-item contract. | `""` | Ready |
| 02 | `02-assemble-context-manifest.md` | Discover bounded governing context and write an inspectable manifest for a normalized Issue. | `"01"` | Ready |
| 03 | `03-generate-guarded-draft-slice.md` | Generate a guarded Draft slice and deterministic checks from a passing contract and manifest. | `"01,02"` | Ready |
| 04 | `04-deliver-preparation-workflow.md` | Deliver and exercise the manually invoked end-to-end preparation workflow. | `"01,02,03"` | Ready |

## Dependency notes

```text
01 normalize supported Issues
             |
             v
02 assemble context manifest
             |
             v
03 generate guarded Draft slice
             |
             v
04 deliver preparation workflow
```

Later drafts are publishable as Ready because their prerequisite outcomes and execution order are explicit. Incomplete prerequisite Issues are promotion blockers, not planning-readiness failures: a later Issue must not be promoted into a slice until every sequence in its `depends_on` metadata is Complete.

## Coverage

| Phase capability or exit criterion | Covering Issue draft(s) | Coverage notes |
| --- | --- | --- |
| Issue-form parsing and normalized, traceable contract | `01-normalize-supported-issues.md` | Supports the implementation and bug forms only. |
| Local document discovery | `02-assemble-context-manifest.md` | Considers only bounded authority sources and Issue references. |
| Context manifests | `02-assemble-context-manifest.md` | Records selected, excluded, missing, warning, and blocker context. |
| Design-document selection | `02-assemble-context-manifest.md` | Selects approved applicable designs; Draft designs remain non-governing candidates. |
| Slice drafting | `03-generate-guarded-draft-slice.md` | Produces a complete `Draft` active slice while preserving the source contract. |
| Structural and scope checks | `03-generate-guarded-draft-slice.md` | Distinguishes deterministic checks from human semantic review. |
| Missing-information warnings | `02-assemble-context-manifest.md`, `03-generate-guarded-draft-slice.md` | Reports discovery warnings and generation blockers without invented requirements. |
| Explicit slice approval and preserved lifecycle | `03-generate-guarded-draft-slice.md`, `04-deliver-preparation-workflow.md` | Only Draft output is generated; workflow documentation and tests verify no automatic approval or implementation. |
| Complete manual Phase 1 workflow | `04-deliver-preparation-workflow.md` | Integrates components and exercises the intended operator path. |

## Deferred work and non-goals

- Issue selection, automatic prioritization, or batch preparation.
- Implementation execution, repair, validation orchestration, commits, pull requests, and GitHub writes.
- Arbitrary third-party Issue-form support.
- Hosted services, databases, background jobs, central registries, or cross-repository control.
- Semantic approval or review automation.

## Approval

- **Status:** Draft
- **Approved by:** Not approved
- **Approval basis:** Pending human review of the Issue sequence, dependencies, and coverage.

## Publication summary

- **Status:** Not published
- **Repository:** `ilmfeemster/ai-harness`
- **Published Issues:** None
- **Partial failures:** None
