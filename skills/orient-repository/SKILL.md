# Orient Repository

## Purpose

Explain the repository's structure, current state, governing documents, and relevant implementation areas without changing repository state.

This skill is for orientation and investigation. It does not authorize planning artifacts, work-item creation, slice preparation, implementation, or lifecycle transitions.

## When to use

Use this skill when the request asks to:

- explain the repository;
- identify where project information lives;
- summarize current scope or architecture;
- locate the source of a rule or behavior;
- identify the documents or code relevant to a question;
- determine what should be read before another operation.

## Do not use when

Do not use this skill as a substitute for:

- project, architecture, or design planning;
- drafting or creating a GitHub Issue;
- promoting an Issue into `docs/current-slice.md`;
- implementation;
- formal validation;
- review;
- finalization.

If the request requires one of those operations, use its dedicated skill after orientation is complete and the handoff is explicit.

## Authority and boundaries

Read and obey `AGENTS.md` before using this skill.

Authority remains determined by concern. Orientation may describe the repository but may not reinterpret one source as universally superior to all others.

This skill must not:

- modify files;
- create or update Issues;
- alter slice status;
- install or update dependencies;
- execute implementation;
- change project scope;
- resolve material document conflicts through assumption.

## Required inputs

- repository root;
- the user's orientation question or stated area of interest.

If no narrow area is stated, orient around the repository's current purpose, active phase, architecture, and document map.

## Required context

Load:

1. `AGENTS.md`;
2. `README.md`;
3. `docs/project.md`;
4. `docs/architecture.md`.

Load `docs/roadmap.md` when future direction, phase sequencing, or deferred work matters.

Load the following only when relevant to the question:

- `docs/current-slice.md` for active work;
- `docs/decisions.md` for durable choices and rationale;
- `docs/testing.md` for confidence or validation practices;
- `docs/design/*.md` for a specific capability;
- GitHub Issues for the work queue or a specific outcome;
- code and tests for current implementation behavior.

Do not load every project artifact merely to produce a general repository summary.

## Procedure

1. Restate the orientation question as a bounded information need.
2. Load the required sources in the listed order.
3. Identify which source governs each relevant concern.
4. Summarize:
   - repository purpose;
   - current project phase and scope;
   - major architecture boundaries;
   - active work, when relevant;
   - important durable constraints;
   - where the requested information is maintained.
5. Inspect optional sources only when the required sources:
   - reference them;
   - do not answer the question;
   - conflict materially;
   - require implementation evidence.
6. Distinguish:
   - current behavior;
   - planned behavior;
   - active approved work;
   - deferred ideas.
7. Identify the next authoritative artifact or operation when the question naturally leads to further work.
8. Stop after the orientation request has been answered.

## Validation

Before responding, verify that:

- each statement is grounded in an appropriate repository source;
- roadmap content is not presented as implemented behavior;
- an unapproved slice is not presented as authorized work;
- code behavior is not inferred solely from planning documents when implementation accuracy matters;
- no repository state was changed.

## Required outputs

Provide:

- a concise repository map;
- the current scope or state relevant to the question;
- the relevant architecture or workflow constraints;
- the authoritative sources for the requested concern;
- any material conflict, missing source, or uncertainty;
- the next source or skill needed, when applicable.

## Failure and escalation behavior

Stop and report the problem when:

- a required source is missing;
- required sources materially contradict one another;
- the repository cannot be oriented accurately without inspecting an unavailable source;
- the request has shifted into an operation that requires another skill or explicit authorization.

Do not resolve conflicts by selecting the most convenient document.

## Completion conditions

This skill is complete when:

- the requested repository orientation has been answered;
- the sources governing the answer are identified;
- relevant uncertainty or conflict is disclosed;
- no side effect has occurred.
