---
name: gsd-write-tests
description: Generate phase test markdown from SUMMARY files
argument-hint: "[phase number | all]"
tools:
  read: true
  edit: true
  glob: true
  grep: true
  bash: true
  task: true
---

<objective>
Create phase-level test docs from built work summaries using the GSD UAT structure as the template style.

If a phase number is provided, generate tests for that phase only.
If no phase (or `all`) is provided, process all phases in ascending order using up to 4 concurrent subagents (worker pool).

Output files:
- Phase 1 -> `tests-1.md`
- Phase 2 -> `tests-2.md`
- etc.

Store each test file in its own phase folder (`.planning/phases/{phase-dir}/`).
</objective>

<template>
@~/.cursor/get-shit-done/templates/UAT.md
</template>

<context>
Target: $ARGUMENTS (optional)
- Numeric (example: `1` or `01`) -> single phase
- `all` or empty -> every phase in `.planning/phases/`

Inputs:
- `@.planning/ROADMAP.md` (optional helper context)
- `Glob: .planning/phases/*/*-SUMMARY.md` (required source of deliverables)
</context>

<process>
## 1. Validate environment

```bash
ls .planning/phases/ 2>/dev/null
```

If missing, stop and tell user to initialize a project first.

## 2. Resolve phase scope

Determine target set:
- If `$ARGUMENTS` is numeric: normalize (`1` -> `01`) and find matching phase dir (`.planning/phases/01-*`)
- If `$ARGUMENTS` is `all` or empty: collect all phase dirs sorted ascending

If no matching phase directory exists, return a clear error with available phase directories.

## 3. Generate tests

### 3A. Single phase mode (`$ARGUMENTS` is numeric)

Process directly in the current agent:
1. Locate summary:
   ```bash
   ls "{PHASE_DIR}"/*-SUMMARY.md 2>/dev/null
   ```
2. Read summary content and extract user-observable outcomes/deliverables
3. Extract implementation context needed for testing from the summary:
   - what was delivered
   - files created and modified
   - what kind of code changed (UI, API, database, auth, infra, etc.)
   - key decisions or deviations that affect testing
4. Convert outcomes into concrete manual tests using the UAT structure and observable expectations
4. Write markdown file in same directory as:
   - `tests-{phase_number_without_zero_padding}.md`
   - Examples: `tests-1.md`, `tests-2.md`, `tests-10.md`

### 3B. All phases mode (`$ARGUMENTS` is `all` or empty)

Use a 4-worker subagent pool:
1. Keep phases sorted ascending.
2. Launch up to 4 subagents in parallel, each assigned exactly one phase.
3. When any subagent finishes, immediately assign the next unprocessed phase (maintain max concurrency = 4).
4. Continue until every target phase is completed or skipped.

Each subagent must:
1. Handle one `{PHASE_DIR}` only.
2. Locate `*-SUMMARY.md` in that phase directory.
3. Extract summary context needed for testing:
   - delivered behaviors
   - files changed
   - changed code areas/subsystems
   - testing-relevant decisions or deviations
4. Build UAT-style tests from observable outcomes.
4. Write `tests-{phase_number_without_zero_padding}.md` in the same phase directory.
5. Return structured result:
   - phase number + phase name
   - output path (or skipped reason)
   - test count
   - source summary filename

Subagent prompt template:
```text
Generate phase tests for exactly one phase directory.
Phase directory: {PHASE_DIR}
Requirements:
- Read {PHASE_DIR}/*-SUMMARY.md
- Extract implementation context from the summary: delivered behaviors, changed files, changed code areas, relevant decisions/deviations
- Produce UAT-style tests based on observable outcomes
- Write {PHASE_DIR}/tests-{phase_number_without_zero_padding}.md
- If summary missing, do not fail the batch; return skipped with reason
- Return: phase, phase_name, output_path_or_skip_reason, test_count, source_summary
```

Use this file template style, based on `UAT.md`:

```markdown
---
status: pending
phase: {phase_slug}
source: {summary_filename}
started: {YYYY-MM-DDT00:00:00Z}
updated: {YYYY-MM-DDT00:00:00Z}
---

## Current Test

number: 1
name: {first test name}
expected: |
  {what user should observe}
awaiting: user execution

## Information Needed from the Summary

what_changed: |
  {short summary of what shipped in this phase}

files_changed:
- {key created or modified file}
- {key created or modified file}

code_areas:
- {ui|api|database|auth|infra|tests|worker|cli|other}
- {area}

testing_notes:
- {important detail from summary that tells the tester where to look}
- {decision, deviation, or risk that affects verification}

## Tests

### 1. {Test Name}
expected: {observable behavior}
result: [pending]

### 2. {Test Name}
expected: {observable behavior}
result: [pending]

### 3. {Test Name}
expected: {observable behavior}
result: [pending]

## Summary

total: {N}
passed: 0
issues: 0
pending: {N}
skipped: 0

## Gaps

[]
```

If a summary has little detail, still write a minimal UAT-style file using the best available outcomes.
If summary context is available, always populate `## Information Needed from the Summary` so testers know what changed and where to look.

## 4. Commit generated test files

After writing the test files, commit the generated changes before finishing.

- If `$ARGUMENTS` is numeric, commit with:
  - `test({normalized_phase}): generate phase tests`
- If `$ARGUMENTS` is `all` or empty, commit with:
  - `test(phases): generate phase tests`

Stage and commit the generated test files and any directly related planning updates created by this command.
Do not leave the command with uncommitted `tests-*.md` changes.
If there are no file changes, do not create an empty commit.

## 5. Present progress as phases are processed

After each phase file is written, print:
- phase number + phase name
- output path
- test count

When running `all`, print progress whenever each subagent completes, and continue dispatching queued phases automatically until complete.

## 6. Final response

Return a concise completion report:
- total phases processed
- files created
- any phases skipped (with reason, e.g., missing SUMMARY.md)
- whether a git commit was created and the commit subject
</process>

<offer_next>
Output this markdown directly (not as a code block):

## ✓ Tests Generated

Processed {N} phase(s).

### Files Created
{one bullet per file path}
</offer_next>

<success_criteria>
- [ ] Accepts one phase number or all phases
- [ ] Iterates phases in ascending order
- [ ] Reads phase `*-SUMMARY.md` files
- [ ] Writes `tests-{phase}.md` into each phase directory
- [ ] Uses 4 concurrent subagents when target is `all`
- [ ] Uses UAT-style structure from `@~/.cursor/get-shit-done/templates/UAT.md`
- [ ] Uses non-zero-padded phase number in filename (`tests-1.md`, `tests-2.md`)
- [ ] Reports created files and skipped phases
- [ ] Commits generated test files when changes exist
</success_criteria>
