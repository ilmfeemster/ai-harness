# Architecture

> **Project-context document:** This file describes the current architecture. Future projects may reuse its scaffold but must replace this content. Reusable governance belongs in `AGENTS.md`.

## Current architecture stage

Phase 1 is in progress.

The complete Phase 0 document-first workflow remains usable. Phase 1 is adding one project-local foreground preparation tool and deterministic data formats around Issue normalization, bounded context manifests, and guarded Draft-slice generation.

The harness remains usable without a hosted service, central controller, database, background worker, or autonomous agent system.

## Core boundary

Each project is self-contained.

```text
project repository
├── reusable workflow assets
├── project-owned governing documents
├── project-specific GitHub Issues
├── optional context manifests
├── one active execution package
├── source code
├── tests
└── validation and review evidence
```

The source repository is the design and test project for the template, not a runtime control plane.

## Template composition

### Reusable workflow assets

- `AGENTS.md`;
- `skills/`;
- Issue forms;
- neutral templates;
- structural validators;
- proven local workflow mechanics.

### Project-owned intelligence and state

- README;
- project and roadmap;
- architecture and decisions;
- designs and testing strategy;
- Issues and context manifests;
- active slice;
- code and tests.

Current harness contents are not reusable project content.

## Current slice and approval model

```text
Ready Issue
↓
complete Draft slice
↓
explicit human approval recorded
↓
Approved slice
↓
separate implementation authorization
↓
In progress
```

Approval recording changes lifecycle state but does not implement or change GitHub state.

## Phase 1 preparation model

```text
explicit Issue number
↓
read-only Issue snapshot
↓
normalized contract
↓
bounded local authority discovery
↓
per-Issue context manifest
↓
guarded Draft current slice
↓
human review
```

The path does not select work, write GitHub state, approve, invoke implementation, or control another repository.

## Authority and rule translation

Authority is determined by concern.

A slice may translate authority into execution rules, but each material deterministic rule remains traceable to its source. Implementation refinements cannot narrow or broaden approved behavior.

Parsers, commands, manifests, generated documents, and serialized artifacts require explicit deterministic contracts before implementation.

## Documentation currency

Project documents are architecture inputs, not commentary.

Every slice assesses impact on project state, architecture, decisions, design, testing, and operator guidance. Required in-scope updates are implemented and validated with behavior changes. Completion is blocked when governing authority is knowingly stale.

## Project-local intelligence

Product vision, roadmap, architecture, decisions, domain knowledge, designs, Issues, manifests, current slice, testing strategy, code, and tests remain local to each project.

## Dependency direction

```text
GitHub Issue outcome
        |
        v
normalized contract
        |
        +-----------------------+
        |                       |
        v                       v
local authority discovery   current-slice guard
        |                       |
        +-----------+-----------+
                    v
             context manifest
                    |
                    v
             Draft current slice
                    |
                    v
           explicit human approval
```

## Architecture principles

- Documents before orchestration code.
- Reasoning resolved by the owning stage.
- Reusable mechanics separated from project context.
- Project-local intelligence.
- Human approval at meaningful boundaries.
- One active slice.
- Explicit states and operations.
- Selective context loading.
- Deterministic validation.
- Independent review.
- Documentation currency.
- Small increments.
- Abstraction after demonstrated repetition.

## Non-goals

- central project registration;
- remote repository control;
- queues or workers;
- workflow database;
- web dashboard;
- multi-agent negotiation;
- provider-neutral model abstractions;
- background execution;
- automatic Git operations;
- automatic implementation or repair.

## Evolution constraints

Future automation must preserve document authority and currency, project self-containment, Issue-to-slice traceability, rule provenance, bounded execution, inspectable approval evidence, deterministic validation, independent review, and explicit human control.
