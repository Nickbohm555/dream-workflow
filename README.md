# dream-workflow

A repository for shaping rough ideas into repeatable agent workflows.

## Purpose

This project is a place to:

- capture thoughts worth revisiting
- document reusable workflows in Markdown
- keep small `.sh` utilities that drive those workflows
- turn loose ideas into execution systems that an agent can run repeatedly

## Core Idea

This repo bridges two useful patterns:

- `gsd-for-cursor`: use explicit phases like map, discuss, plan, execute, and verify so the agent does not jump straight into coding with weak context
- `agent-search`: use a tight shell loop where prompts + `AGENTS.md` + `IMPLEMENTATION_PLAN.md` define one repeatable operating cycle

The result is a workflow where GSD provides the shape of the work, and the `loop.sh` pattern provides the day-to-day execution engine.

## Workflow

### 1. Map and frame the work

Start by understanding the codebase and the scope before asking an agent to build. This is the GSD part:

- map the codebase when the repo is unfamiliar
- discuss gray areas and decisions that affect implementation
- do discovery only when current docs or ecosystem details matter
- convert that into a concrete implementation direction

### 2. Lock the operating context

Keep operational rules in `AGENTS.md` only:

- how to run the app
- how to test it
- service names, ports, restart commands, and debugging notes
- local codebase conventions the agent must follow

Do not put the work queue in `AGENTS.md`. That causes drift. Keep execution rules separate from task state.

### 3. Build the plan artifact

Keep the evolving task list in `IMPLEMENTATION_PLAN.md`:

- ordered in required implementation sequence
- broken into sections that fit a single context window
- each section includes what to build and how it should be verified
- one section is marked as the current section to work on

This is the handoff between planning and execution. GSD would normally create plan artifacts per phase; the loop pattern compresses that into a single practical working plan.

### 4. Use prompt files to switch agent mode

Prompt files act as mode selectors:

- `PROMPT_plan.md`: inspect specs and code, then update `IMPLEMENTATION_PLAN.md`
- `PROMPT_plan_work.md`: do the same, but only for a scoped slice of work
- `PROMPT_build.md`: execute the current section, test it, log it, and move the pointer forward

This is the cleanest part of the `agent-search` pattern. The shell loop stays dumb; the prompts define the behavior.

### 5. Let `loop.sh` run the execution rhythm

`loop.sh` ties everything together:

- selects planning vs build mode
- pipes `PROMPT_*.md` and `AGENTS.md` into the agent
- repeats for as many iterations as needed
- commits changes after each iteration
- optionally pushes the branch

The loop is the orchestrator. The prompt is the role. `AGENTS.md` is the runtime contract. `IMPLEMENTATION_PLAN.md` is the state of work.

### 6. Record completion and verification

After each build iteration:

- copy the completed item into `completed.md`
- include commands run, useful logs, and test results
- advance `Current section to work on`
- write `.loop-commit-msg` so the shell loop can create a meaningful commit

This is where GSD's verify step gets grounded in a lightweight artifact trail instead of a separate heavy process.

### 7. Feed gaps back into planning

If testing, logs, or review reveal gaps:

- update `IMPLEMENTATION_PLAN.md`
- add follow-up sections in implementation order
- rerun planning mode or scoped planning mode

That closes the loop: discovery -> plan -> execute -> verify -> replan.

## File Roles

| File | Role |
| --- | --- |
| `AGENTS.md` | Operational rules for build, run, test, and local conventions |
| `IMPLEMENTATION_PLAN.md` | Ordered backlog and current execution pointer |
| `PROMPT_plan.md` | Planning behavior |
| `PROMPT_plan_work.md` | Scoped planning behavior |
| `PROMPT_build.md` | Execution behavior |
| `completed.md` | Completed work log with commands, tests, and useful logs |
| `.loop-commit-msg` | One-line summary consumed by `loop.sh` |
| `loop.sh` | Repeating orchestrator for plan/build iterations |

## Practical Flow

1. Map the repo and clarify ambiguous decisions.
2. Write or refresh `AGENTS.md`.
3. Create or update `IMPLEMENTATION_PLAN.md`.
4. Run planning mode until the plan is credible.
5. Run build mode to execute one section at a time.
6. Verify with tests and logs every iteration.
7. Move completed work into `completed.md`.
8. Replan when verification exposes new gaps.

## Structure

- `thoughts/` for raw notes and idea fragments
- `workflows/` for documented processes, checklists, and experiments
- `scripts/` for shell scripts that automate parts of the workflow

## Current Projects

- [Nickbohm555 on GitHub](https://github.com/Nickbohm555) - Active projects, experiments, and repositories in progress.
