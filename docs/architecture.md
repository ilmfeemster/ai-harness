# Architecture

## Current architecture stage

Phase 0 is a document-first project template with lightweight local tooling.

The template must remain usable without a hosted service, central controller, database, or autonomous agent system.

## Core boundary

Each project created from the template is self-contained.

```text
project repository
├── workflow constitution
├── project intelligence
├── design documents
├── GitHub work items
├── active execution package
├── source code
├── tests
└── validation history
```

The harness repository is the source template, not a runtime control plane for other repositories.

## Ownership model

### Project-owned intelligence

The following should remain in each project:

- product vision and current scope;
- architecture;
- durable decisions;
- domain knowledge;
- detailed designs;
- GitHub Issues;
- active slice;
- testing strategy;
- project-specific agent instructions.

### Potential shared mechanics, later

Only after repeated use may these be extracted:

- structural document validation;
- issue parsing;
- context assembly;
- command execution;
- run reporting;
- model invocation adapters;
- evaluation logic.

## Phase 0 components

### `AGENTS.md`

The workflow constitution. It defines instruction priority, context loading, work modes, implementation boundaries, validation, review, and completion behavior.

### Project documents

Durable layers of project intelligence:

```text
roadmap
  ↓
project
  ↓
architecture and decisions
  ↓
design
```

Each layer should add detail without duplicating lower or higher layers.

### GitHub Issues

The implementation work queue. Issues define meaningful outcomes and acceptance criteria.

### `current-slice.md`

The single approved bounded execution package. It converts one ready issue into specific implementation steps, files, commands, and review conditions.

### Local validation

Small scripts may validate document structure and execute declared commands. These tools must remain understandable and replaceable.

## Architecture principles

- Documents before orchestration code.
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
- project self-containment;
- issue-to-slice traceability;
- bounded execution;
- inspectable decisions;
- deterministic validation;
- explicit human approval.

Automation that obscures these properties should be rejected even if it reduces manual steps.
