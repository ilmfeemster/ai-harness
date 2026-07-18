# Decisions

> **Project-context document:** This file records durable decisions for the AI Development Harness project. New projects may reuse the decision-record format, but must not inherit these entries as their own decisions.

Record only decisions that materially affect future development.

## 2026-07-17 — Template-first architecture

### Decision

Build the harness as a reusable project template rather than a central repository that controls other repositories.

### Reason

The proven workflow is project-local: its documents, code, tests, and agent instructions live together. A template preserves self-containment, works naturally with coding agents, and avoids premature cross-project orchestration.

### Tradeoffs

- Existing projects will not receive template improvements automatically.
- Project copies may drift.
- Repeated mechanics may eventually need extraction into shared tooling.
- Project-specific evolution remains straightforward.

## 2026-07-17 — Phase 0 must be usable

### Decision

Phase 0 must support a complete manually orchestrated development workflow, not merely document future architecture.

### Reason

Each harness phase should provide immediate value and be testable through real project work.

### Tradeoffs

- Some Phase 0 structures may later be refined.
- Manual steps remain intentionally present.
- Automation is deferred until the underlying contracts are proven.

## 2026-07-17 — GitHub Issues replace `tasks.md` in new projects

### Decision

Use GitHub Issues as the implementation work queue. Preserve `current-slice.md` as the bounded execution package.

### Reason

Issues provide status, discussion, linking, and future branch/PR integration while `current-slice.md` remains better suited to precise agent execution.

### Tradeoffs

- Project work depends more directly on GitHub.
- Issue templates and readiness rules must be clear.
- Migration of existing projects should be incremental.

## 2026-07-17 — Human-orchestrated Phase 0

### Decision

Keep issue selection, slice approval, implementation invocation, repair decisions, and final approval manual during Phase 0.

### Reason

The immediate objective is deterministic quality and workflow leverage, not autonomy. Manual boundaries allow the document contracts to be validated before automation is layered on top.

### Tradeoffs

- Repetitive prompting and handoffs remain.
- Execution speed is lower than an autonomous loop.
- Workflow failures are easier to inspect and correct.

## 2026-07-17 — Intelligence remains in project documents

### Decision

Keep project-specific intelligence in local markdown documents rather than embedding it in orchestration code or large reusable prompts.

### Reason

Documents are inspectable, versioned, editable, and usable across model providers and tooling.

### Tradeoffs

- Document quality becomes a critical dependency.
- Contradictions and drift need explicit management.
- Later tooling must discover and assemble documents reliably.

## 2026-07-18 — Separate reusable workflow assets from project context

### Decision

Treat the harness output as two different categories:

1. reusable workflow assets that can be copied with little project-specific content; and
2. project-document scaffolds whose substantive contents must be initialized for each project.

`AGENTS.md` owns the reusable document responsibility and template-treatment model. Documents such as `project.md`, `roadmap.md`, `architecture.md`, `decisions.md`, `testing.md`, designs, Issues, and the active slice contain project intelligence or state.

### Reason

The harness repository is both the development project and the source for future project templates. Without an explicit separation, harness-specific scope, architecture, decisions, and active state could be mistaken for reusable template content.

### Tradeoffs

- Starting a project requires an initialization or reset step rather than copying the source repository byte for byte.
- Reusable schemas and project content must be maintained as distinct concepts.
- Phase 0.7 must define a reliable project-start process.
- The harness can test its own workflow using real documents without treating their current contents as universal defaults.

## 2026-07-18 — Authority is determined by concern

### Decision

Resolve document authority according to each source's defined responsibility rather than a universal priority list.

The active slice controls execution detail, but it cannot silently override current scope, architecture, durable decisions, approved design, project-wide testing standards, or the required outcome of its source work item.

### Reason

A universal hierarchy incorrectly implies that a more operational document may rewrite unrelated upstream constraints. Authority by concern preserves both precise execution and durable project boundaries.

### Tradeoffs

- Conflicts sometimes require an explicit stop and upstream correction.
- Agents must identify which concern a statement governs.
- The responsibility model must remain clear and current in `AGENTS.md`.
