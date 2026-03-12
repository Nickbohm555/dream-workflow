# dream-workflow

![Dream Workflow banner](assets/dream-banner.svg)

Dream Workflow combines GSD with the Ralph loop to 100x development by pairing deep planning with fresh-context execution loops.

This repo has two parts:

- `GSD for Cursor/`
- `Ralph loop/`
- `custom tools/`

## Requirements

- Codex membership
- Cursor membership

The workflow is simple: use GSD for extensive planning, then hand the scoped work into Ralph for repeated fresh-context execution loops.

## Structure

```text
dream-workflow/
├── GSD for Cursor/
├── Ralph loop/
└── custom tools/
```

## Why this works

It pairs extensive planning with an agent loop where each run starts with fresh context and a limited, specific task.

- GSD is effective because it forces codebase mapping, requirements, roadmap creation, and phase planning before execution.
- Ralph is effective because each loop works on a narrow item, follows explicit run and test instructions, and avoids context drift.

## Handoff process

### 1. Map the codebase

Run:

- `/gsd/map-codebase`

Produces:

- `.planning/codebase/STACK.md`
- `.planning/codebase/INTEGRATIONS.md`
- `.planning/codebase/ARCHITECTURE.md`
- `.planning/codebase/STRUCTURE.md`
- `.planning/codebase/CONVENTIONS.md`
- `.planning/codebase/TESTING.md`
- `.planning/codebase/CONCERNS.md`

Why it is effective:

- it creates a grounded map of the existing repo before planning starts

### 2. Initialize the project

Run:

- `/gsd/new-project`

Produces:

- `.planning/PROJECT.md`
- `.planning/config.json`
- `.planning/REQUIREMENTS.md`
- `.planning/ROADMAP.md`
- `.planning/STATE.md`
- `.planning/research/` when research is enabled

Why these files matter:

- `PROJECT.md` captures what the product is and what matters most
- `REQUIREMENTS.md` is one of the most important files because it turns the idea into specific capabilities that must be built
- `ROADMAP.md` groups those requirements into ordered phases
- `STATE.md` becomes the running memory of progress and current position
- `research/` adds domain and implementation context when the project needs it

Build-up tree:

- `PROJECT.md` -> defines the product
- `REQUIREMENTS.md` -> defines what must be delivered
- `ROADMAP.md` -> defines phase order from those requirements
- `STATE.md` -> tracks where execution currently is

Why it is effective:

- it turns the repo or idea into requirements, phases, and project memory

### 3. Plan the phase

Run:

- `/gsd/plan-phase 1`

Produces:

- phase `RESEARCH.md` when needed
- one or more phase `PLAN.md` files

Uses from Section 2:

- `ROADMAP.md` to decide which phase is being planned
- `REQUIREMENTS.md` to know what the phase must actually cover
- `STATE.md` to know the current project position
- `PROJECT.md` and `config.json` as supporting context
- `RESEARCH.md` or `CONTEXT.md` when extra phase guidance exists

Why it is effective:

- it converts roadmap phases into executable tasks
- it uses research, planning, and plan verification before execution
- if the plan is not clear enough, you can run `/gsd/discuss-phase {X}` and then rerun `/gsd/plan-phase {X}` until the phase plan is right

## Before Ralph starts

Before starting the Ralph loop with Codex, the planning side should already have produced the full handoff set.

Important inputs:

- `.planning/ROADMAP.md`
- `.planning/STATE.md`
- `.planning/phases/{phase-name}/`
- [launch-devtools.sh](/Users/nickbohm/Desktop/Tinkering/dream-workflow/custom%20tools/launch-devtools.sh)

Inside each phase folder, you should have:

- multiple `PLAN.md` files for a single phase
- phase `RESEARCH.md` with implementation guidance for that phase when research was needed

**Tool setup before Ralph:**

- the most important thing is that the Chrome launcher script already exists in the repo so the agent can access it
- everything else here is a sanity check before getting started
- the Chrome launcher script is already the setup
- make sure it is executable:
  - `chmod +x "./custom tools/launch-devtools.sh"`
- when browser validation is needed, the agent should launch:
  - `"./custom tools/launch-devtools.sh" http://localhost:5173`
- then confirm the DevTools endpoint is available:
  - `http://127.0.0.1:9222/json/list`
- after that, the main thing Codex needs is agent instructions telling it when to launch this script and use the browser target

### 4. Automating testing

Use:

- [write-tests.md](/Users/nickbohm/Desktop/Tinkering/dream-workflow/custom%20tools/write-tests.md)

When to use it:

- after you finish creating the phase plans
- before you start the Ralph build loop

What it does:

- reads the phase summaries for each phase
- generates `tests-{phase}.md` files inside the matching phase folders
- turns phase deliverables into concrete UAT-style test coverage

Why it matters:

- it gives the repo a dedicated testing pass instead of leaving testing implied
- it creates explicit phase test files that can be referenced during implementation and verification
- it keeps testing as its own automated workflow after planning is complete

### 5. Ralph loop building features

Use:

- [AGENTS.md](/Users/nickbohm/Desktop/Tinkering/dream-workflow/Ralph%20loop/AGENTS.md)
- [IMPLEMENTATION_PLAN.md](/Users/nickbohm/Desktop/Tinkering/dream-workflow/Ralph%20loop/IMPLEMENTATION_PLAN.md)
- [PROMPT_build.md](/Users/nickbohm/Desktop/Tinkering/dream-workflow/Ralph%20loop/PROMPT_build.md)
- [loop.sh](/Users/nickbohm/Desktop/Tinkering/dream-workflow/Ralph%20loop/loop.sh)

Purpose:

- Ralph is the build automation layer after planning is finished
- each task in the implementation plan gets its own fresh context window
- after each task, the loop records what was built, updates summaries, and keeps roadmap progress moving forward

#### Create the implementation plan

Run:

- your custom Cursor command for implementation-plan generation

Example:

- see [generate-implementation-plan.md](/Users/nickbohm/Desktop/Tinkering/dream-workflow/custom%20tools/generate-implementation-plan.md) in [custom tools](/Users/nickbohm/Desktop/Tinkering/dream-workflow/custom%20tools)

Produces:

- `IMPLEMENTATION_PLAN.md`

What it does:

- reads the roadmap, state, phase plan files, and phase research files
- reads generated phase test files when they exist
- converts them into one ordered execution document for the Ralph loop
- creates one section per task, plus summary and roadmap-update steps when needed

Short example of what this looks like:

- `Section 1 — phase-x — 01-01 — Task 1 (Execution)`
- `Section 2 — phase-x — 01-01 — Task 2 (Execution)`
- `Section 3 — phase-x — 01-01 — Create Summary`
- `Section 4 — phase-x — Mark Phase Complete`

What goes into the handoff:

- the GSD phase tasks
- the phase test checklists generated from summaries
- clear frontend and backend test commands
- any MCP requirements needed to run or verify the app

Why it is effective:

- it merges build work and test work into one ordered execution queue

#### `loop.sh`

`loop.sh` is the executable script for the Ralph loop.

It reads two files each iteration:

- `PROMPT_build.md`
- `AGENTS.md`

`PROMPT_build.md` should stay simple:

- read `IMPLEMENTATION_PLAN.md`
- find the current section
- build that section
- run the required checks
- update the implementation plan
- stop so the next loop starts fresh on the next section

`AGENTS.md` should stay operational only:

- how to install dependencies
- how to start and run the app
- how to run tests, lint, and typecheck
- how to access Chrome DevTools with `./custom tools/launch-devtools.sh [local app url]`
- the DevTools endpoint at `http://127.0.0.1:9222/json/list`

If the app uses Docker or another runtime, specify that directly in `AGENTS.md`.

### 6. Run the Ralph loop

Run:

- `loop.sh`

Each loop does this:

1. Read `AGENTS.md`
2. Read the next item in `IMPLEMENTATION_PLAN.md`
3. Execute that one scoped task
4. Run the required validation
5. Mark the item complete
6. Start the next loop with fresh context

Why it is effective:

- each loop starts clean
- each loop has a specified task
- the agent is constrained by explicit run, test, and verification rules

## Summary

The handoff is:

1. GSD maps the repo
2. GSD creates requirements and roadmap
3. GSD creates executable phase plans
4. phase test files are generated from phase summaries before Ralph starts
5. Ralph merges tasks plus testing into one implementation plan
6. Ralph loops through the work one item at a time with fresh context
