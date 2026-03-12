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

Why it is effective:

- it turns the repo or idea into requirements, phases, and project memory

### 3. Plan the phase

Run:

- `/gsd/plan-phase 1`

Produces:

- phase `RESEARCH.md` when needed
- one or more phase `PLAN.md` files

Why it is effective:

- it converts roadmap phases into executable tasks
- it uses research, planning, and plan verification before execution
- if the plan is not clear enough, you can run `/gsd/discuss-phase {X}` and then rerun `/gsd/plan-phase {X}` until the phase plan is right

### 4. Generate phase tests

Run:

- your custom Cursor command for phase test generation
- `/gsd/write-tests 1`
- `/gsd/write-tests all`

Example:

- see [test-plan.md](/Users/nickbohm/Desktop/Tinkering/dream-workflow/custom%20tools/test-plan.md) in [custom tools](/Users/nickbohm/Desktop/Tinkering/dream-workflow/custom%20tools)

Produces:

- `tests-1.md`, `tests-2.md`, and so on
- one test file per phase inside that phase folder under `.planning/phases/`
- test checklists generated from each phase `*-SUMMARY.md` based on the user-visible features and outcomes delivered in that phase, not the raw implementation tasks

Why it is effective:

- it converts built phase outcomes into simple manual pass/fail test checklists
- it can process one phase or all phases in order before the Ralph loop starts
- it keeps the testing extraction logic as a reusable Cursor command instead of an ad hoc prompt

## Before Ralph starts

Before starting the Ralph loop with Codex, the planning side should already have produced the full handoff set.

Important inputs:

- `.planning/ROADMAP.md`
- `.planning/STATE.md`
- `.planning/phases/{phase-name}/`
- [test-plan.md](/Users/nickbohm/Desktop/Tinkering/dream-workflow/custom%20tools/test-plan.md)
- [launch-devtools.sh](/Users/nickbohm/Desktop/Tinkering/dream-workflow/custom%20tools/launch-devtools.sh)

Inside each phase folder, you should have:

- multiple `PLAN.md` files for a single phase
- phase `RESEARCH.md` with implementation guidance for that phase when research was needed
- one generated `tests-{phase}.md` file with the feature-level tests for that phase

**Tool setup before Ralph:**

- the most important thing is that the Chrome launcher script already exists in the repo so the agent can access it
- everything else here is a sanity check before getting started
- make sure the custom Cursor test command logic is available from [test-plan.md](/Users/nickbohm/Desktop/Tinkering/dream-workflow/custom%20tools/test-plan.md)
- the Chrome launcher script is already the setup
- make sure it is executable:
  - `chmod +x "./custom tools/launch-devtools.sh"`
- when browser validation is needed, the agent should launch:
  - `"./custom tools/launch-devtools.sh" http://localhost:5173`
- then confirm the DevTools endpoint is available:
  - `http://127.0.0.1:9222/json/list`
- after that, the main thing Codex needs is agent instructions telling it when to launch this script and use the browser target

### 5. Build the Ralph loop inputs

Use:

- [AGENTS.md](/Users/nickbohm/Desktop/Tinkering/dream-workflow/Ralph%20loop/AGENTS.md)
- [IMPLEMENTATION_PLAN.md](/Users/nickbohm/Desktop/Tinkering/dream-workflow/Ralph%20loop/IMPLEMENTATION_PLAN.md)
- [PROMPT_build.md](/Users/nickbohm/Desktop/Tinkering/dream-workflow/Ralph%20loop/PROMPT_build.md)
- [loop.sh](/Users/nickbohm/Desktop/Tinkering/dream-workflow/Ralph%20loop/loop.sh)

What goes into the handoff:

- the GSD phase tasks
- the phase test checklists generated from summaries
- clear frontend and backend test commands
- any MCP requirements needed to run or verify the app

Why it is effective:

- it merges build work and test work into one ordered execution queue

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
4. phase test files are generated from phase summaries
5. Ralph merges tasks plus testing into one implementation plan
6. Ralph loops through the work one item at a time with fresh context
