# Start Project

## Purpose

Define a repeatable, human-operated process for initializing a new project with reusable workflow mechanics and project-owned documents that contain only the new project's context.

This skill is a checklist and boundary definition. It is not a generator, hosted service, synchronization process, or automatic Git workflow.

## When to use

Use this skill when asked to:

- start a new project from the repository's reusable workflow assets;
- initialize project-owned document paths from neutral scaffolds;
- install the reusable GitHub Issue forms in a new repository;
- verify that source-project context did not leak into a new project.

## Do not use when

Do not use this skill when:

- the target already contains project content that must be preserved;
- the request is to synchronize an existing project with the source repository;
- the request is to select or implement a work item;
- the target's product scope, architecture, or testing policy has not been supplied;
- a required input would have to be guessed.

## Authority and boundaries

Read and obey `AGENTS.md` before using this skill.

This skill describes how to initialize a project. It does not create authority beyond the constitution and does not copy project intelligence from the source repository. The initialized project remains responsible for its own scope, roadmap, architecture, decisions, designs, Issues, active slice, source code, and tests.

Do not:

- overwrite an existing project;
- copy the source repository's current README, `docs/`, Issues, active slice, or implementation history;
- create a hosted generator, registry, synchronization service, or central controller;
- initialize a work item or mark an Issue ready automatically;
- invoke a model or make product decisions from missing input;
- initialize an active slice with copied state or unresolved placeholders.

## Required inputs

Collect these inputs before changing the target:

- the source asset location;
- the target repository path;
- confirmation that the target is a new, empty project directory or an explicitly designated empty repository;
- project name;
- one-sentence purpose or product description;
- target users and the problem being addressed;
- current goals, included scope, non-goals, and initial exit criteria;
- initial roadmap direction, even if it is only the next outcome;
- architecture constraints and dependency direction, or an explicit statement that none are established;
- testing and validation expectations, tools, and initial commands, or an explicit initial testing policy;
- GitHub owner and repository name when GitHub Issues will be used.

Use explicit `None established` or equivalent project language for genuinely undecided inputs. Do not infer product context from the source project.

## Optional inputs

These may improve the initialized documents but are not required:

- an existing product brief or approved design;
- initial durable decisions and their rationale;
- deployment, contribution, or support expectations;
- initial source-code layout and local development commands;
- a preferred project-specific design-document naming convention.

## Reusable assets

Copy these assets with little or no project-specific editing:

| Source path | Target path | Boundary |
| --- | --- | --- |
| `AGENTS.md` | `AGENTS.md` | Workflow constitution and authority rules |
| `skills/` | `skills/` | Repeatable operation procedures |
| `.github/ISSUE_TEMPLATE/` | `.github/ISSUE_TEMPLATE/` | Issue forms and blank-Issue configuration |
| `templates/` | `templates/` | Neutral document and active-slice scaffolds |
| `scripts/validate.ps1` | `scripts/validate.ps1` | Local structural validator |
| `tests/validate-structure.ps1` | `tests/validate-structure.ps1` | Deterministic validator tests |

Preserve the contents of these reusable assets unless the new project has an explicitly approved workflow change. In particular, do not copy the source repository's submitted Issues or any source-specific files referenced by those assets.

## Project-owned paths

Create these paths from the neutral scaffolds, then replace every placeholder with the new project's information:

| Target path | Scaffold | Initialization rule |
| --- | --- | --- |
| `README.md` | `templates/README.md` | Replace the project name, purpose, setup, and navigation content |
| `docs/project.md` | `templates/docs/project.md` | Record current purpose, users, goals, scope, non-goals, and exit criteria |
| `docs/roadmap.md` | `templates/docs/roadmap.md` | Record future direction and sequencing owned by this project |
| `docs/architecture.md` | `templates/docs/architecture.md` | Record the current structure and constraints, including explicit unknowns |
| `docs/decisions.md` | `templates/docs/decisions.md` | Record only decisions made for this project |
| `docs/testing.md` | `templates/docs/testing.md` | Record project-wide confidence standards and commands |
| `docs/design/` | `templates/docs/design.md` | Create the directory; initialize each capability design when needed |
| `docs/current-slice.md` | none | Create an empty file until a Ready Issue is promoted |

Do not use the source repository's current versions of these paths as templates. The neutral files under `templates/` are the only source for initial document structure in this process.

## Procedure

1. Read `AGENTS.md` and this skill. Confirm that project initialization, rather than implementation or synchronization, is the requested operation.
2. Inspect the target path. Stop unless it is absent, empty, or an explicitly designated repository containing only allowed repository metadata such as `.git`. Do not remove or overwrite existing project files.
3. Confirm all required project inputs. Stop if a document would require guessing.
4. Copy the reusable assets listed above into the target. Preserve their paths and workflow meaning.
5. Create `docs/` and `docs/design/` as needed. Initialize each project-owned document from its listed neutral scaffold.
6. Create `docs/current-slice.md` as an empty file. Do not copy `docs/current-slice.md` from the source repository or `templates/docs/current-slice.md` into the active path.
7. Install `.github/ISSUE_TEMPLATE/` from the reusable forms. The forms define how future project Issues are submitted; they do not copy or create the source repository's backlog.
8. Fill the initialized documents with the required project inputs. Replace placeholders, remove unused optional sections, and keep the documents self-contained.
9. Run the local checks from the target repository:

   ```powershell
   powershell -NoProfile -File scripts/validate.ps1 -InitializedProject -CleanInitialization
   powershell -NoProfile -File tests/validate-structure.ps1
   ```

10. Review the output and inspect project-owned documents for source-specific names, URLs, scope, phases, decisions, active-slice state, and completion claims. A clean initialization must leave `docs/current-slice.md` empty.
11. Report the target path, copied assets, initialized documents, validation results, unresolved project decisions, and the next human handoff. Do not promote an Issue or begin implementation as part of initialization.

## Expected outputs

A successful initialization produces:

- the reusable workflow constitution and operation skills;
- reusable Issue forms and local structural validation tools;
- neutral templates retained for future document initialization;
- project-owned README and `docs/` documents populated with the new project's context;
- an empty `docs/current-slice.md`;
- a target repository that can be validated without access to the source repository;
- a human-readable report of inputs, outputs, checks, and unresolved decisions.

## Leakage checks

Check both categories separately:

- reusable assets must remain free of source-project active state;
- project-owned documents must contain the new project's name, scope, roadmap, architecture, decisions, and testing policy rather than source-project content.

The local validator supports the clean-target check with `-InitializedProject -CleanInitialization`. It checks required paths, neutral scaffold headings, source-context patterns in project-owned documents, and the empty active-slice requirement. The validator is mechanical evidence; a human must still inspect whether the initialized documents make sense for the new project.

At minimum, search the project-owned paths for:

- source project names or repository URLs;
- source Issue URLs or copied Issue numbers;
- source phase names or completion evidence;
- source-specific roadmap, architecture, decision, or active-slice content.

## Stop conditions

Stop before modifying the target when:

- the target contains existing project files that cannot be explicitly discarded;
- required project information is missing or contradictory;
- a reusable asset contains source-project state that cannot be separated locally;
- a project-owned document would be copied from the source rather than initialized from a neutral scaffold;
- the active slice would contain copied state or unresolved placeholders;
- Issue forms would be coupled to the source backlog;
- validation cannot be run or its failure cannot be explained;
- the requested process requires synchronization, a registry, a hosted service, automatic Git operations, or model invocation.

## Handoffs

After initialization:

- use `skills/orient-repository/SKILL.md` to understand the new project's documents and structure;
- use `skills/plan-change/SKILL.md` for any project, architecture, or design planning;
- use `skills/create-work-item/SKILL.md` to create the first bounded Issue;
- use `skills/prepare-slice/SKILL.md` only after an Issue is Ready and the active slice is empty;
- use `skills/validate-slice/SKILL.md` and `skills/review-slice/SKILL.md` only for an active implementation slice.

Initialization itself does not authorize any of these later operations.

## Completion conditions

This skill is complete when:

- reusable assets and project-owned paths are clearly separated;
- all required project inputs are recorded without guessing;
- clean scaffolds have been used for project-owned documents;
- Issue forms are installed without source backlog state;
- the new active slice is empty;
- clean-target validation passes;
- the target is self-contained and the human handoff is reported.
