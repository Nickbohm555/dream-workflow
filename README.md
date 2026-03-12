# dream-workflow

This repo has two parts:

- `GSD for Cursor/`
- `Ralph loop/`

The workflow is simple: use GSD for extensive planning, then hand the scoped work into Ralph for repeated fresh-context execution loops.

## Structure

```text
dream-workflow/
├── GSD for Cursor/
└── Ralph loop/
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

### 4. Extract the testing scope for the phase

Run:

- the custom phase test command for your workflow

Produces:

- the feature list that must be tested for the phase
- the validation targets for frontend, backend, APIs, or MCP-assisted flows

Why it is effective:

- it makes the test surface explicit before the execution loop starts

### 5. Build the Ralph loop inputs

Use:

- [AGENTS.md](/Users/nickbohm/Desktop/Tinkering/dream-workflow/Ralph%20loop/AGENTS.md)
- [IMPLEMENTATION_PLAN.md](/Users/nickbohm/Desktop/Tinkering/dream-workflow/Ralph%20loop/IMPLEMENTATION_PLAN.md)
- [PROMPT_build.md](/Users/nickbohm/Desktop/Tinkering/dream-workflow/Ralph%20loop/PROMPT_build.md)
- [loop.sh](/Users/nickbohm/Desktop/Tinkering/dream-workflow/Ralph%20loop/loop.sh)

What goes into the handoff:

- the GSD phase tasks
- the features that must be tested for that phase
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
4. testing requirements are extracted for each phase
5. Ralph merges tasks plus testing into one implementation plan
6. Ralph loops through the work one item at a time with fresh context
