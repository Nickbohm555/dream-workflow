# dream-workflow

This repository now contains four working areas:

- `GSD for Cursor/`: the Cursor adaptation of GSD, moved in from `gsd-for-cursor`
- `Ralph loop/`: the loop workflow files moved in from `my-ralph`
- `custom-commands/`: local custom Cursor command files
- `custom-skills/`: local custom skill definitions

## Structure

```text
dream-workflow/
├── GSD for Cursor/
├── Ralph loop/
├── custom-commands/
└── custom-skills/
```

## Project roadmap

This is the starting workflow I use to complete projects in Cursor.

### Step 1: Start in Cursor with GSD

I start with `GSD for Cursor/`, which is the cloned Get Shit Done context-engineering repo adapted for Cursor. The first practical setup step is installing its commands and subagents into Cursor so the `/gsd/...` workflow is available inside the editor.

### Step 2: Map the codebase first

Before planning work in an existing project, I use the `map-codebase` command from the GSD command set:

- Command: `/gsd/map-codebase`
- Source: [map-codebase.md](/Users/nickbohm/Desktop/Tinkering/dream-workflow/GSD%20for%20Cursor/src/commands/gsd/map-codebase.md)

What it does:

- It analyzes the current codebase with parallel `gsd-codebase-mapper` agents.
- It writes the output directly into `.planning/codebase/`.
- It is designed for brownfield repos, unfamiliar codebases, onboarding, and refreshes after large changes.

What it produces:

- `.planning/codebase/STACK.md`
- `.planning/codebase/INTEGRATIONS.md`
- `.planning/codebase/ARCHITECTURE.md`
- `.planning/codebase/STRUCTURE.md`
- `.planning/codebase/CONVENTIONS.md`
- `.planning/codebase/TESTING.md`
- `.planning/codebase/CONCERNS.md`

How it works:

- It checks whether a previous `.planning/codebase/` map already exists.
- It creates the `.planning/codebase/` directory.
- It spawns 4 parallel `gsd-codebase-mapper` agents.
- Each agent owns a focus area and writes files directly instead of sending big summaries back to the orchestrator.
- The orchestrator then verifies that all 7 files exist, checks line counts, and offers the next step.

The mapping split is:

- Tech mapper: `STACK.md` and `INTEGRATIONS.md`
- Architecture mapper: `ARCHITECTURE.md` and `STRUCTURE.md`
- Quality mapper: `CONVENTIONS.md` and `TESTING.md`
- Concerns mapper: `CONCERNS.md`

Why I do this first:

- It gives me a grounded picture of the repo before I start shaping work.
- It marks up the important files, structure, conventions, integrations, and risk areas in reusable planning docs.
- It gives later commands a stable context base instead of relying on memory or a shallow scan.

### Step 3: Run new-project after the map

Once the codebase is mapped, I run the project initialization command:

- Command: `/gsd/new-project`
- Source: [new-project.md](/Users/nickbohm/Desktop/Tinkering/dream-workflow/GSD%20for%20Cursor/src/commands/gsd/new-project.md)

What it does:

- It initializes the project through one flow: questioning, optional research, requirements definition, and roadmap creation.
- It creates the planning artifacts that the rest of the workflow uses.
- It is the handoff from an idea or repo into a buildable plan.

What it asks:

- First, it checks whether the project is already initialized.
- It initializes git in the current directory if needed.
- It detects whether code already exists and whether a codebase map already exists.
- If it sees an existing codebase without a map, it asks whether to run `map-codebase` first.
- It then asks deep project questions starting with: "What do you want to build?"
- It follows up to clarify scope, motivation, constraints, vague terms, and what success should look like.
- It asks for workflow preferences such as mode, planning depth, parallel execution, git tracking, research, plan-checking, verifier usage, and model profile.
- It asks whether to run research before requirements.
- It asks the user to scope feature categories into v1, v2, or out of scope.
- It asks for roadmap approval before committing the roadmap.

What it produces:

- `.planning/PROJECT.md`
- `.planning/config.json`
- `.planning/research/` if research is enabled
- `.planning/REQUIREMENTS.md`
- `.planning/ROADMAP.md`
- `.planning/STATE.md`

### Step 4: Understand the new-project logic

The command runs in a structured sequence:

1. Setup and brownfield detection.
2. Deep questioning until there is enough context to write `PROJECT.md`.
3. Write and commit `PROJECT.md`.
4. Collect workflow settings and write `config.json`.
5. Optionally run domain research in parallel.
6. Turn the project idea and research into scoped requirements.
7. Spawn a roadmapper to convert requirements into phases with success criteria.
8. Ask for approval, revise if needed, then commit the roadmap artifacts.

### Step 5: Subagents called by new-project

If research is enabled, `new-project` calls these subagents:

- `gsd-project-researcher`
- `gsd-research-synthesizer`
- `gsd-roadmapper`

What the research agents produce:

- 4 parallel `gsd-project-researcher` runs create:
  - `.planning/research/STACK.md`
  - `.planning/research/FEATURES.md`
  - `.planning/research/ARCHITECTURE.md`
  - `.planning/research/PITFALLS.md`
- The `gsd-research-synthesizer` then reads those files and produces:
  - `.planning/research/SUMMARY.md`

What the roadmapper produces:

- The `gsd-roadmapper` reads `PROJECT.md`, `REQUIREMENTS.md`, `SUMMARY.md` when present, and `config.json`.
- It writes:
  - `.planning/ROADMAP.md`
  - `.planning/STATE.md`
- It also updates requirement traceability in `.planning/REQUIREMENTS.md`.

What those agent outputs are for:

- `PROJECT.md` captures the actual product context.
- `config.json` controls how the workflow behaves.
- `research/*` gives domain evidence, standard patterns, stack choices, feature expectations, and pitfalls.
- `REQUIREMENTS.md` turns ideas into atomic, testable requirements.
- `ROADMAP.md` turns requirements into ordered phases.
- `STATE.md` becomes project memory for later GSD steps.

### Step 6: End state of initialization

At the end of this step, the project is initialized and ready for the next GSD action:

- `/gsd/discuss-phase 1` to clarify implementation approach
- or `/gsd/plan-phase 1` to go straight into execution planning

This is the front end of how I complete projects: install GSD into Cursor, map the codebase, initialize the project with `new-project`, and leave the repo with concrete planning artifacts instead of loose notes.

## Ralph loop contents

The `Ralph loop/` folder currently includes:

- `AGENTS.md`
- `IMPLEMENTATION_PLAN.md`
- `PROMPT_build.md`
- `loop.sh`

## Custom folders

The custom folders currently include:

- `custom-commands/`: `cyberpunk-readme.md`, `ralph-merge.md`, `ralph-start.md`, `section-brainstorm.md`, `section-template.md`, and `test-plan.md`
- `custom-skills/`: the `playwright/` skill

## Next steps

- Expand this README with setup and usage notes for all four folders
- Add any missing Ralph loop documents if the workflow grows beyond the current four files
- Keep this repo focused on these four directories only
