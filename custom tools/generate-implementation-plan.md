# Generate implementation plan from phases

Generate `IMPLEMENTATION_PLAN.md` from the current repository's planning files using the phase/task/test structure below.

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
  - optional phase test files named `tests-*.md`

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

3. Task sections (first, always before tests):
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
   - Use best judgment if `subsystem` or `affects` are not explicit.

6. Phase tests sections (after all plan task sections for that phase):
   - Discover phase test files in order: `tests-1.md`, `tests-2.md`, ...
   - Parse each test case in each test file and create one section per test case.
   - Section title format:
     - `## Section N — <phase-slug> — <tests-file-name-without-.md> — Test <test-number> (Execution)`
   - Inputs block for each test section must include:
     - test file path
     - phase research file reference (always)
   - Steps must include:
     1. Read test definition from `<tests-x.md>` for that test.
     2. Execute test exactly as defined.
     3. Record outcome in `<phase-dir>/test-<x>-results.md` for that test item.
     4. Update `.planning/STATE.md` with `phase=<phase>` / `tests=test-<x>` / `test=<test-number>` / `status=implemented`.

7. Test file completion step:
   - After final test in each `tests-x.md`, append:
     - `5. Finalize <phase-dir>/test-<x>-results.md for all tests in tests-<x>.md and update .planning/STATE.md to the next tests file (or phase completion if none remain).`

8. Phase completion step (must mirror roadmap/state completion intent):
   - After all plan task sections and all phase test sections are generated for a phase, append:
     - `6. Ensure all test-*-results.md files for this phase are finalized.`
     - `7. Update .planning/ROADMAP.md and .planning/STATE.md to mark the phase complete.`

## Constraints

- Only edit `IMPLEMENTATION_PLAN.md`.
- Do not modify phase plan files, tests files, roadmap, or state while generating this document.
- If no `tests-*.md` exists for a phase, skip test sections for that phase and still include the phase-completion roadmap/state step after plan sections.
