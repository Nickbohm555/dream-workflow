# Generate testing plan from phase tests

Generate `IMPLEMENTATION_PLAN.md` from the repository planning test artifacts, producing one execution section per discovered test.

## Goal

Create a deterministic testing plan document from `./.planning/phases/...` (or `./planning/phases/...` if that is what exists). Assume `IMPLEMENTATION_PLAN.md` may be missing or blank and generate it from scratch.

Tests are expected to come from phase `test-*.md` files.

## Inputs to read

- `.planning/ROADMAP.md` (if present)
- `.planning/STATE.md` (if present)
- `.planning/config.json` (if present)
- Phase directories under `.planning/phases/*`
- For each phase directory:
  - `test-*.md` files
  - optional `*-RESEARCH.md` (context reference for each section when present)
  - optional `*-CONTEXT.md` (context reference for each section when present)

If `.planning/...` does not exist, use `planning/...` with the same rules.

## Required output file

- Create or overwrite `IMPLEMENTATION_PLAN.md` with the generated plan.

## Generation rules

1. Always bootstrap only the minimal top-of-file header:
   - `Tests are in **required execution order** (1...n). Each section = one atomic verification. Complete one section at a time.`
   - `Current section to work on: section 1. (move +1 after each turn)`

2. Section numbering:
   - Start at section `1`.
   - Increment by 1 for every generated section.

3. Ordering:
   - Iterate phases in ascending numeric order (`01`, `02`, ...).
   - Within a phase, iterate `test-*.md` files in ascending order.
   - Within each file, iterate tests in ascending test number order.

4. Test extraction:
   - Parse test blocks from `test-*.md` files:
     - Header pattern: `### <number>. <test name>`
     - Required field: `expected: <observable behavior>`
     - Optional fields: `result:`, `reported:`, `severity:`, `reason:`
   - If a test file has no `###` test headers, treat the file as a single test using:
     - test id from filename (e.g., `test-2.md` -> `2`)
     - name from first heading or filename
     - expected from `expected:` field when present, otherwise "Validate behavior described in this file."

5. One section per test:
   - For each extracted test, create exactly one section.
   - Section title format:
     - `## Section N — <phase-slug> — Test <test-id> (Validation)`
   - Every section must follow the standard section template style:
     - `**Single goal:**`
     - `**Details:**`
     - `**Tech stack and dependencies**`
     - `**Files and purpose**` table
     - `**How to test:**`
     - `**Test results:** (Fill when run.)`

6. Required section content:
   - Single goal should restate the test's `expected` outcome in one sentence.
   - Details must include:
     - source phase and source test file
     - original test name and id
     - existing result/severity context when available
    - Files and purpose table must include:
      - source test file path
      - referenced research file path when present
      - referenced context file path when present
   - How to test should provide manual verification steps in plain language, based on the extracted expected behavior.
   - Steps for each section must include:
     1. Load the source test file, the phase research file, and the phase context file when present.
     2. Treat the expected behavior in the test as the validation target.
     3. Execute the validation steps in order and record only directly observed outcomes in `Test results`.

7. Empty-state behavior:
   - If no test files are found, still create `IMPLEMENTATION_PLAN.md` with header plus:
     - `No tests discovered under planning phases.`

8. Phase checkpoint step:
   - After the final test section for each phase, append:
     - `Next: update .planning/STATE.md after executing this phase's testing sections.`

## Constraints

- Only edit `IMPLEMENTATION_PLAN.md`.
- Do not modify phase test files, roadmap, or state while generating this document.
