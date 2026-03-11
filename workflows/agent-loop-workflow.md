# Agent Loop Workflow

This workflow combines a GSD-style phase model with a lightweight shell loop.

## Phase 1: Map

Before planning, inspect the repo:

- identify source roots
- identify build and test commands
- identify shared utilities and existing patterns
- identify gaps in local docs

Write stable findings into `AGENTS.md`, not into prompts.

## Phase 2: Discuss

Clarify implementation decisions before planning:

- what outcome is actually required
- what behavior is in scope
- what tradeoffs are already decided
- what should be deferred

This keeps the plan artifact cleaner and reduces rework.

## Phase 3: Plan

Create or refine `IMPLEMENTATION_PLAN.md`:

- one section per context-sized unit of work
- ordered by dependency
- include explicit verification per section
- keep a single `Current section to work on`

Use:

- `./loop.sh plan`
- `./loop.sh plan-work "scope"`

## Phase 4: Execute

Run the build loop:

- `./loop.sh`

For each iteration, the agent should:

- read `AGENTS.md`
- read `IMPLEMENTATION_PLAN.md`
- implement the current section
- validate the result
- append completion notes to `completed.md`
- advance the current section
- write `.loop-commit-msg`

## Phase 5: Verify

Verification is part of every build iteration:

- run tests
- inspect logs
- restart services when needed
- record the commands and outcome

If the work is incomplete, update the plan instead of hiding the gap.

## Phase 6: Replan

When verification reveals missing work:

- update `IMPLEMENTATION_PLAN.md`
- add follow-up sections in dependency order
- return to planning mode if the shape of work changed

That closes the loop:

`map -> discuss -> plan -> execute -> verify -> replan`
