# Generate testing plan from phase tests

Generate `IMPLEMENTATION_PLAN.md` from the repository planning test artifacts, producing one execution section per discovered test.

## Goal

Create a deterministic testing plan document from `./.planning/phases/...` (or `./planning/phases/...` if that is what exists). Assume `IMPLEMENTATION_PLAN.md` may be missing or blank and generate it from scratch.

Tests are expected to follow the UAT-style structure from `UAT.md` (tests under `## Tests` with `### N. [Test Name]`, `expected:`, and result metadata).

## Inputs to read

- `.planning/ROADMAP.md` (if present)
- `.planning/STATE.md` (if present)
- `.planning/config.json` (if present)
- Phase directories under `.planning/phases/*`
- For each phase directory:
  - `test-*.md` files (primary)
  - `*-UAT.md` files (also supported)
  - optional `*-RESEARCH.md` (context reference for each section when present)
  - optional `*-CONTEXT.md` (context reference for each section when present)

If `.planning/...` does not exist, use `planning/...` with the same rules.

## Required output file

- Create or overwrite `IMPLEMENTATION_PLAN.md` with the generated plan.

## Generation rules

1. Always bootstrap only the minimal top-of-file header:
   - `Tests are in **required execution order** (1...n). Each section = one atomic verification. Complete one section at a time.`
   - `Current section to work on: section 1. (move +1 after each turn)`
   - Then add the following top-level global blocks before any generated sections:
     - `## Global Test Loading Rules`
     - `## Debugger Rules`
     - `## Test Execution Protocol`

2. Global blocks content:
   - `## Global Test Loading Rules` must instruct the executor to load, before starting any section:
     - the source test file
     - the phase research file when present
     - the phase context file when present
     - relevant roadmap/state/config context when present
   - If a phase context file is present, explicitly state that it represents the user's intended vision for the phase and should guide test interpretation.
   - `## Debugger Rules` must summarize the GSD debugger guidance and require the executor to follow it throughout every section:
     - role: user reports symptoms, executor investigates
     - philosophy: rely on observable facts, not assumptions
     - discipline: treat the code as foreign, question mental models, prioritize recently changed code
     - cognitive traps to avoid: confirmation bias, anchoring, availability, sunk cost
     - when to restart: repeated failed fixes, no progress, inability to explain behavior, or accidental luck-based fixes
     - hypothesis quality: prefer specific, falsifiable hypotheses over vague guesses
     - decision point to act: only act when mechanism, evidence, reproduction, and alternatives are clear
     - recovery from wrong hypotheses: explicitly record what was disproven and what was learned
   - `## Test Execution Protocol` must require:
     - follow `Debugger Rules` throughout every section
     - use the test's expected behavior as the single validation goal
     - gather evidence before proposing fixes
     - if debugging is needed, use one hypothesis at a time
     - document test results only after observing behavior directly

3. Section numbering:
   - Start at section `1`.
   - Increment by 1 for every generated section.

4. Ordering:
   - Iterate phases in ascending numeric order (`01`, `02`, ...).
   - Within a phase, iterate files in ascending order:
     1. `test-*.md`
     2. `*-UAT.md`
   - Within each file, iterate tests in ascending test number order.

5. Test extraction:
   - Parse UAT-style test blocks from `## Tests`:
     - Header pattern: `### <number>. <test name>`
     - Required field: `expected: <observable behavior>`
     - Optional fields: `result:`, `reported:`, `severity:`, `reason:`
   - If a test file has no `###` test headers, treat the file as a single test using:
     - test id from filename (e.g., `test-2.md` -> `2`)
     - name from first heading or filename
     - expected from `expected:` field when present, otherwise "Validate behavior described in this file."

6. One section per test:
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

7. Required section content:
   - Single goal should restate the test's `expected` outcome in one sentence.
   - Details must include:
     - source phase and source test file
     - original test name and id
     - existing result/severity context when available
     - instruction to follow `Debugger Rules` throughout this section
   - Files and purpose table must include:
     - source test file path
     - referenced research file path when present
     - referenced context file path when present
   - How to test should provide manual verification steps in plain language, based on the extracted expected behavior.
   - Steps for each section must include:
     1. Execute this section under the `Global Test Loading Rules`, `Debugger Rules`, and `Test Execution Protocol` defined at the top of the document.
     2. Load the source test file, the phase research file, and the phase context file when present.
     3. Treat the expected behavior in the test as the validation target.
     4. If debugging is needed, investigate using debugger rules before changing anything.
     5. Record only directly observed test outcomes in `Test results`.

8. Empty-state behavior:
   - If no test files are found, still create `IMPLEMENTATION_PLAN.md` with header plus:
     - `No tests discovered under planning phases.`

9. Phase checkpoint step:
   - After the final test section for each phase, append:
     - `Next: update .planning/STATE.md after executing this phase's testing sections.`

## Constraints

- Only edit `IMPLEMENTATION_PLAN.md`.
- Do not modify phase test files, roadmap, or state while generating this document.
