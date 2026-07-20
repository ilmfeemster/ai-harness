# Fantasy Workflow Comparison

## Purpose and method

This comparison evaluates the workflow mechanics proven in the sibling
`live-draft-tool-v2` repository against the Phase 0 harness. It does not
import fantasy-football product context, source code, backlog content, design
decisions, or domain testing guidance.

Sources reviewed on 2026-07-19:

- sibling `AGENTS.md` and `CLAUDE.md`;
- sibling `docs/tasks.md`, `docs/current-slice.md`, and
  `docs/completed-tasks.md`;
- sibling `docs/testing.md`, `docs/architecture.md`, `docs/decisions.md`, and
  `docs/future_ideas.md`;
- harness `AGENTS.md`, lifecycle skills, testing standards, architecture,
  decisions, README, structural validator, and Issue #5.

The sibling workflow is evidence of practices that have been exercised during
real implementation. The harness remains the authoritative reusable workflow
and uses GitHub Issues rather than the sibling repository's legacy
`docs/tasks.md` backlog.

## Comparison

| Workflow concern | Proven sibling practice | Harness disposition |
| --- | --- | --- |
| Document loading | Load only documents required for the operation; reuse already-loaded context; do not browse unrelated files. | Already covered by the context-loading rules and operation skills. |
| Planning and task shaping | Define a bounded, observable increment; keep task-level intent separate from detailed execution steps. | Already covered by the Issue contract, readiness requirements, and slice-promotion rules. |
| Slice preparation | Make one explicit implementation contract with scope, non-goals, ordered steps, expected files, validation, failure conditions, and review questions. | Already covered, with the harness adding mandatory human approval and source-Issue traceability. |
| Implementation | Follow the slice sequentially; avoid unrelated cleanup, dependency changes, placeholder behavior, and backlog-driven scope expansion; report blockers. | Already covered and strengthened by explicit lifecycle transitions, implementation authorization, and blocker requirements. |
| Validation | Use declared checks, manual QA, and observable acceptance evidence; do not weaken tests to make them pass. | Already covered by the validation skill and project testing standards. |
| Review and completion | Keep validation, review, and completion distinct; preserve concise evidence and do not start the next item automatically. | Already covered and strengthened: review is independent, human approval is required, and finalization alone closes the Issue. |
| Interruption recovery | When context is lost, finish a coherent unit where possible and hand off progress, decisions, remaining work, blockers, and next prompt. | Adopted below as a project-neutral handoff rule, adapted to the harness lifecycle. |
| Backlog migration | The sibling uses `docs/tasks.md` and temporary issue-import artifacts while migrating to GitHub Issues. | Intentionally not adopted: GitHub Issues are already the harness work queue. |

## Adopted project-neutral improvement

### Interrupted-work handoff

The sibling process has demonstrated the value of an explicit recovery path
when an agent loses sufficient context to continue safely. The harness now
adds `AGENTS.md` section 6.1, which requires a concise handoff containing
progress, decisions, remaining work, blockers, and the next authorized
operation.

This is project-neutral because interruptions can occur in any repository. It
is deliberately adapted rather than copied: the handoff cannot bypass the
harness's approval boundaries or advance a work item automatically.

## Already-covered harness behavior

No change was needed for the following sibling practices because the harness
already provides an equal or stricter reusable rule:

- selective, operation-specific context loading and reuse of loaded context;
- one bounded, independently reviewable work item and active slice;
- explicit scope, non-goals, observable acceptance criteria, failure
  conditions, and expected files;
- no unsupported shortcuts, test weakening, placeholders, unrelated cleanup,
  or speculative abstraction;
- focused validation followed by separate formal validation and independent
  review;
- documented completion evidence and no automatic next-item selection;
- durable decisions and architecture changes recorded only in their governing
  documents.

The harness's Issue-based lifecycle, authority-by-concern model, one-work-item
invariant, and human approval boundaries are stronger than the corresponding
manual controls in the sibling workflow and remain unchanged.

## Intentionally excluded patterns

- Fantasy-football product scope, roster, ranking, draft, recommendation, and
  integration rules.
- Sibling product architecture, decisions, test scenarios, completed-task
  history, and future-feature backlog.
- `docs/tasks.md` as the authoritative or staging work queue, issue-import
  artifacts, their status taxonomy, and YAML reasoning-tier metadata. These
  are migration-specific mechanisms that conflict with the harness's GitHub
  Issue contract.
- A blanket instruction to suggest the next work item after implementation:
  this conflicts with the harness requirement to stop after the current
  operation and prevents implicit work selection.
- Sibling-specific current-slice schema and status names, which lack the
  harness's explicit approval, validation, review, and finalization states.
- Product-specific manual browser QA details and all speculative automation,
  orchestration, plugin, and cross-repository mechanisms.

## Result

The Phase 0 harness retains the demonstrated low-friction manual workflow:
selective context, a small execution contract, focused implementation,
evidence-based validation, independent review, and human-controlled
completion. GitHub Issues continue to define outcomes, current slices continue
to define execution, and only the interruption handoff was added as a missing
reusable protection.
