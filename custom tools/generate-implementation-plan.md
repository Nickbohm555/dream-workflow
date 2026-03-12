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

2. Section numbering:
   - Start at section `1`.
   - Increment by 1 for every generated section.

3. Task sections:
   - Iterate phases in ascending numeric order (`01`, `02`, ...).
   - For each phase, iterate plan files in ascending order.
   - For each task in a plan, create exactly one section.
   - Section title format:
     - `## Section N — <phase-slug> — <plan-id> — Task <task-number> (Execution)`
   - Required inputs block for every task section:
     - plan file
     - reference to phase research file (always)
     - reference to phase context file (if present)
   - Steps must include:
     1. Read plan frontmatter + that task title.
     2. Implement task.
     3. Run task verification steps from that plan/task.
     4. Update `.planning/STATE.md` with `phase=<phase>` / `plan=<plan-id>` / `task=<task-number>` / `status=implemented`.

4. Plan completion step:
   - After the final task section for each `*-PLAN.md`, append:
     - `5. Create <plan-id>-SUMMARY.md in the plan directory by following the summary formatting and steps below, then update .planning/STATE.md to the next plan.`

5. Summary creation instructions (used any time a section references `SUMMARY.md`):
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
     - task commits: `{type}({phase}-{plan}): {task-name}`
     - plan metadata commit: `docs({phase}-{plan}): complete [plan-name] plan`
   - For plan `01-02`, identify relevant commits with:
     - `git log --oneline --grep="(01-02):"`
     - optionally refine metadata with `git log --oneline --grep="^docs(01-02): complete "`
   - Treat non-`docs(...)` matches as task commits and `docs({phase}-{plan}): complete ...` as the metadata commit.
   - Use `git show --stat --name-status <commit>` across the task commits to determine which files were created or modified and to support any summary of what was added.
   - If commit messages do not follow the convention exactly, use the closest matching history plus plan context and note the uncertainty in the summary instead of inventing precision.
   - Use best judgment if `subsystem` or `affects` are not explicit.

6. Phase completion step (must mirror roadmap/state completion intent):
   - After all plan task sections are generated for a phase, append:
     - `6. Update .planning/ROADMAP.md and .planning/STATE.md to mark the phase complete.`

## Constraints

- Only edit `IMPLEMENTATION_PLAN.md`.
- Do not modify phase plan files, roadmap, or state while generating this document.
