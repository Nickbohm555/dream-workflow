# Generate implementation plan from phases

Generate `IMPLEMENTATION_PLAN.md` from the current repository's planning files using the phase/task structure below.

## Goal

Create a deterministic execution plan document from `./.planning/phases/...` (or `./planning/phases/...` if that is what exists). Assume `IMPLEMENTATION_PLAN.md` may be missing or blank and generate the full document from scratch.

## Inputs to read

- `.planning/ROADMAP.md`
- `.planning/STATE.md`
- `.planning/config.json` (if present)
- Phase directories under `.planning/phases/*`
- For each phase:
  - all `*-PLAN.md`
  - the phase `*-RESEARCH.md` (always required as a reference in every section)
  - optional `*-CONTEXT.md` (include when present)

If `.planning/...` does not exist, use `planning/...` with the same rules.

## Required output file

- Create or overwrite `IMPLEMENTATION_PLAN.md` with the generated plan.

## Generation rules

1. Always bootstrap only the minimal top-of-file header even if no plan exists yet:
   - `Tasks are in **required implementation order** (1...n). Each section = one context window. Complete one section at a time.`
   - `Current section to work on: section 1. (move +1 after each turn)`
   - Then add the following top-level global blocks before any generated sections:
     - `## Global Plan Loading Rules`
     - `## Global Execution Rules`
     - `## Deviation Rules`
     - `## Task Completion Protocol`
     - `## Summary Tracking Rules`

2. Global blocks content:
   - `## Global Plan Loading Rules` must instruct the executor to fully load the referenced `*-PLAN.md` before starting a section, including:
     - frontmatter: `phase`, `plan`, `type`, `autonomous`, `wave`, `depends_on`, `files_modified`, `user_setup`, `must_haves`
     - `<objective>`
     - `<context>` and every referenced file
     - every task's `type`, `name`, `files`, `action`, `verify`, `done`
     - plan-level `<verification>`
     - `<success_criteria>`
     - `<output>`
   - If a plan references a context file, explicitly state that this file represents the user's vision for the phase and must be honored throughout execution.
   - `## Global Execution Rules` must include the executor decision rules:
     - Rule 1: auto-fix bugs
     - Rule 2: auto-add missing critical functionality
     - Rule 3: auto-fix blocking issues
     - Rule 4: stop and ask about architectural changes
     - rule priority
     - edge case guidance
   - `## Deviation Rules` must require:
     - automatically apply Rules 1-3 when new work is discovered
     - stop and ask under Rule 4
     - track every deviation for the eventual summary
   - `## Task Completion Protocol` must require, for each task:
     - execute the task `action`
     - if additional work is discovered that is not explicitly written in the plan, apply deviation rules automatically
     - run the task `verify` steps
     - confirm the task `done` criteria are met
     - do not proceed until the task is actually complete
   - `## Summary Tracking Rules` must require:
     - every completed task is traceable in the final summary
     - track verification performed, done-criteria confirmation, deviations applied, and the commit hash for that task

3. Section numbering:
   - Start at section `1`.
   - Increment by 1 for every generated section.

4. Task execution sections:
   - Iterate phases in ascending numeric order (`01`, `02`, ...).
   - For each phase, iterate plan files in ascending order.
   - For each task in each plan, create exactly one execution section.
   - Section title format:
     - `## Section N — <phase-slug> — <plan-id> — Task <task-number> (Execution)`
   - Required inputs block for every task section:
     - plan file
     - reference to phase research file (always)
     - reference to phase context file (if present)
   - Read the whole plan and extract every task in order.
   - Treat task data flexibly:
     - If the plan uses `<task>` blocks, use each task's `<name>`, `<action>`, `<verify>`, and `<done>`.
     - If the plan uses markdown sections named `Action`, `Verify`, and `Done`, use those sections in the same order.
   - Steps must include:
     1. Re-read `Global Plan Loading Rules`, `Global Execution Rules`, `Deviation Rules`, `Task Completion Protocol`, and `Summary Tracking Rules` at the top of the document.
     2. Load the full plan frontmatter, objective, context references, and all task definitions for that plan.
     3. Load the phase research file and always use it as a reference.
     4. If a phase context file is present, load it and treat it as the user's vision for how the phase should work.
     5. Execute only the current task's `action`.
     6. If additional work is discovered that is not explicitly written in the plan, apply deviation rules automatically.
     7. Run all `verify` commands/checks for the current task one by one.
     8. Do not mark the task complete until its `done` condition is satisfied.
     9. Write `.loop-commit-msg` with exactly: `<plan-id>-task<task-number>`.
     10. Update `.planning/STATE.md` with `phase=<phase>` / `plan=<plan-id>` / `task=<task-number>` / `status=implemented`.

5. Summary section:
   - After the final task section for each plan, create one additional section.
   - Section title format:
     - `## Section N — <phase-slug> — <plan-id> (Summary)`
   - Steps must include:
     1. Re-read the full plan, task outcomes, verification results, and deviations.
     2. Create `<plan-id>-SUMMARY.md` in the plan directory by following the summary formatting and steps below.
     3. Update `.planning/STATE.md` to the next plan.
     4. If this completes the phase, also update `.planning/ROADMAP.md` and `.planning/STATE.md` to mark the phase complete.
     5. Write `.loop-commit-msg` with exactly: `<plan-id>-summary`.

6. Summary creation instructions (used any time a section references `SUMMARY.md`):
   - File location:
     - `.planning/phases/XX-name/{phase}-{plan}-SUMMARY.md`
   - Title format:
     - `# Phase [X] Plan [Y]: [Name] Summary`
   - The one-liner under the title must be substantive.
     - Good: `JWT auth with refresh rotation using jose library`
     - Bad: `Authentication implemented`
   - Before writing the summary body, populate frontmatter from execution context:
     1. Basic identification:
        - `phase`: from PLAN.md frontmatter
        - `plan`: from PLAN.md frontmatter
        - `subsystem`: best category based on phase focus (`auth`, `payments`, `ui`, `api`, `database`, `infra`, `testing`, etc.)
        - `tags`: tech keywords from libraries, frameworks, and tools used
     2. Dependency graph:
        - `requires`: prior phases this plan built on, based on referenced prior summaries
        - `provides`: what this plan delivered
        - `affects`: likely future phases or areas that will depend on this work
     3. Tech tracking:
        - `tech-stack.added`: libraries or tools added during the work
        - `tech-stack.patterns`: patterns established by the implementation
     4. File tracking:
        - `key-files.created`: created files from the work
        - `key-files.modified`: modified files from the work
     5. Decisions:
        - `key-decisions`: decisions made during implementation
     6. Metrics:
        - `duration`: from `$DURATION`
        - `completed`: from `$PLAN_END_TIME` using `YYYY-MM-DD`
   - Derive file tracking from git history, not memory.
   - Execution commit convention:
     - task commits: `{phase}-{plan}-task{task-number}`
     - summary/metadata commit: `{phase}-{plan}-summary`
   - For plan `01-02`, identify relevant commits with:
     - `git log --oneline --grep="^01-02-task"`
     - `git log --oneline --grep="^01-02-summary$"`
   - Treat `01-02-task*` matches as task commits and `01-02-summary` as the summary/metadata commit.
   - Use `git show --stat --name-status <commit>` across the task commits to determine which files were created or modified and to support any summary of what was added.
   - If commit messages do not follow the convention exactly, use the closest matching history plus plan context and note the uncertainty in the summary instead of inventing precision.
   - Use best judgment if `subsystem` or `affects` are not explicit.
   - Summary must include a deviations section:
     - if no deviations occurred, state that the plan executed as written
     - if deviations occurred, list each deviation, which rule triggered it, what changed, verification, and commit hash
   - Summary must preserve task-to-commit traceability for every completed task.

7. Phase completion step (must mirror roadmap/state completion intent):
   - Do not create a separate phase-completion commit type.
   - If a summary section also completes the phase, include the roadmap/state update in that summary section and still use `<plan-id>-summary` as the commit message.

## Constraints

- Only edit `IMPLEMENTATION_PLAN.md`.
- Do not modify phase plan files, roadmap, or state while generating this document.
