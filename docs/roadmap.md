# Harness Roadmap

> **Project-context document:** This roadmap describes the future development of the AI Development Harness. It is not reusable roadmap content for projects created from the harness. New projects should initialize their own roadmap from an appropriate scaffold.

The harness is a project template. Each project owns its documents, code, workflow state, and implementation history.

Every phase must produce a usable workflow. Later phases extend the existing model rather than replacing it.

This document defines future direction and sequencing. It is not the active work queue.

## Phase 0 — Usable document-driven workflow template

### Outcome

A complete, manually operated workflow at least as useful as the current `live-draft-tool-v2` workflow.

```text
project.md
→ design documents when needed
→ GitHub Issues
→ current-slice.md
→ manual implementation
→ validation
→ review
→ approval
```

### Planned slices

1. **0.1 Establish the harness repository**
   - Create the constitution and core documents.
2. **0.2 Define document responsibilities and reuse boundaries**
   - Separate reusable workflow rules from project context and remove ambiguity between document levels.
3. **0.3 Define the GitHub Issue workflow**
   - Add reusable Issue forms, the readiness and promotion contract, a minimal label policy, and project-specific Issues for the remaining Phase 0 work.
4. **0.4 Define the slice standard**
   - Finalize the reusable execution-package schema while ensuring every active slice is reset and populated as project-specific state.
5. **0.5 Define planning modes**
   - Formalize document loading and output expectations by operation.
6. **0.6 Add lightweight local validation**
   - Check required files, slice sections, references, commands, unresolved placeholders, and separation between reusable assets and project context.
7. **0.7 Add project-start instructions**
   - Package reusable assets and initialize clean project documents without copying harness context.
8. **0.8 Compare against the fantasy workflow**
   - Bring over proven rules without copying domain-specific content.
9. **0.9 Use the workflow on a real fantasy-app slice**
   - Test Issue → slice → implementation → validation → review.
10. **0.10 Stabilize Phase 0**
    - Correct friction found through real use and declare the phase complete.

## Phase 1 — Context and slice assistance

### Outcome

A ready GitHub Issue can become a high-quality `current-slice.md` with little repetitive prompting.

### Capabilities

- local document discovery;
- Issue-form parsing;
- context manifests;
- design-document selection;
- slice drafting;
- structural and scope checks;
- missing-information warnings;
- explicit slice approval.

Implementation remains manually invoked.

## Phase 2 — Controlled implementation

### Outcome

An approved slice can be executed once by a project-local implementation runner, followed by deterministic validation and a structured result.

### Capabilities

- one supported implementation path;
- bounded repository access;
- allowed command configuration;
- changed-file tracking;
- validation execution;
- structured completion and blocker states;
- optional branch or worktree isolation.

No automatic repair.

## Phase 3 — Independent evaluation and bounded repair

### Outcome

Implementation results are independently evaluated against the Issue, slice, architecture, tests, and validation evidence. Identified defects may receive limited repair attempts.

### Capabilities

- acceptance-criteria evaluation;
- scope and architecture review;
- test-quality review;
- repair attempt limits;
- revalidation and reevaluation;
- escalation when the slice or design is flawed.

## Phase 4 — GitHub delivery workflow

### Outcome

A ready Issue can become a review-ready draft pull request while preserving human approval before merge.

### Capabilities

- branch and commit creation;
- Issue, slice, commit, and PR linkage;
- draft PR creation;
- CI status collection;
- selected review-feedback repair;
- merge-readiness reporting;
- Issue closure after merge.

## Phase 5 — Proven reusable tooling

### Outcome

Mechanics demonstrated across multiple projects are extracted into a versioned package or CLI while project intelligence remains local.

Possible components:

- document validators;
- Issue parsers;
- context assembly;
- execution runners;
- model adapters;
- evaluation rubrics;
- run records;
- GitHub integrations.

## Phase 6 — Optional higher-level orchestration

Consider only after repeated use demonstrates value.

Possible capabilities:

- recommending the next ready Issue;
- detecting blocked work;
- preparing several future slices;
- comparing model cost and quality;
- resuming interrupted runs;
- project progress summaries;
- documentation-drift detection;
- optional multi-project coordination.
