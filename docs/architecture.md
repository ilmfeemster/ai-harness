# Architecture

> **Project-context document:** This file describes the architecture of the AI Development Harness project. A future project may reuse its headings or scaffold, but must replace the harness-specific content. Reusable workflow governance and document responsibilities live in `AGENTS.md`.

## Current architecture stage

Phase 0 is a document-first project template with lightweight local tooling.

The harness must remain usable without a hosted service, central controller, database, or autonomous agent system.

## Core boundary

Each project created from the harness is self-contained.

```text
project repository
├── reusable workflow assets
├── project-owned documents
├── project-specific GitHub Issues
├── active execution package
├── source code
├── tests
└── validation history
```

The harness repository is the source and test project for the template. It is not a runtime control plane for other repositories.

## Template composition

The template has two distinct output categories.

### Reusable workflow assets

These encode workflow mechanics rather than product knowledge:

- the default `AGENTS.md` constitution;
- `.github/ISSUE_TEMPLATE/` Issue forms;
- structural validators and workflow scripts added in later slices;
- reusable schemas or starter headings.

These assets should remain project-neutral unless a project intentionally changes its workflow.

The Issue forms define a reusable contract. They do not contain a project's backlog. Submitted Issues remain project-owned state.

### Initialized project-owned documents

These are created from scaffolds but populated with the new project's intelligence and state:

- project README;
- current project scope;
- project roadmap;
- project architecture;
- durable project decisions;
- detailed designs;
- project testing strategy;
- GitHub Issue contents;
- active slice;
- source code and tests.

The current harness contents of these sources are development context, not reusable project content.

## Source-repository dual role

This repository uses the same document paths that future projects will use because the harness must prove its own workflow through real development.

That does not mean project creation should copy all files verbatim.

A future project-start process must:

1. copy reusable workflow assets;
2. create project-document paths from approved scaffolds;
3. remove harness-specific content and operational state;
4. initialize those documents with the new project's context;
5. initialize the reusable Issue forms in the new GitHub repository;
6. preserve project self-containment.

The exact initialization procedure belongs to Phase 0.7. This architecture defines the boundary that procedure must preserve.

## GitHub work-item model

GitHub Issues are the project-owned work queue. The reusable Issue forms require enough information to determine whether one outcome is ready for promotion.

Workflow state is deliberately not encoded in custom labels during Phase 0:

- readiness is established by the Issue contract;
- active work is identified by `docs/current-slice.md`;
- completion is represented by human approval followed by Issue closure;
- labels may classify work but are not authoritative state.

This avoids coupling the reusable template to a repository-specific label inventory.

## Project-local intelligence

The following remain local to each project:

- product vision and current scope;
- roadmap;
- architecture;
- durable decisions;
- domain knowledge;
- detailed designs;
- submitted GitHub Issues;
- active slice;
- testing strategy;
- source code and tests.

Project intelligence must not be embedded in a central harness service or silently inherited from an unrelated source project.

## Potential shared mechanics, later

Only after repeated use may these be extracted into shared tooling:

- structural document validation;
- Issue parsing;
- context assembly;
- command execution;
- run reporting;
- model invocation adapters;
- evaluation logic.

Extraction should move mechanics, not project intelligence.

## Phase 0 runtime model

Phase 0 has no automated runtime orchestrator.

The operating sequence is manually initiated:

```text
project documents
↓
ready GitHub Issue
↓
approved current slice
↓
implementation agent
↓
deterministic validation
↓
human review and approval
↓
Issue closure
```

Local scripts may validate document structure and execute declared commands. These tools must remain understandable and replaceable.

## Architecture principles

- Documents before orchestration code.
- Reusable mechanics separated from project context.
- Project-local intelligence.
- Human approval at phase boundaries.
- One active implementation slice.
- Explicit work modes.
- Selective context loading.
- Deterministic mechanical validation.
- Independent evaluation only after implementation automation exists.
- Small vertical increments.
- Abstraction after demonstrated repetition.

## Non-goals

Phase 0 does not include:

- central project registration;
- remote repository control;
- queues or workers;
- a workflow database;
- a web dashboard;
- multi-agent negotiation;
- provider-neutral model abstractions;
- background execution;
- automatic Git operations.

## Evolution constraints

Future automation must preserve:

- document authority;
- the separation of reusable mechanics from project context;
- project self-containment;
- Issue-to-slice traceability;
- bounded execution;
- inspectable decisions;
- deterministic validation;
- explicit human approval.

Automation that obscures these properties should be rejected even if it reduces manual steps.
