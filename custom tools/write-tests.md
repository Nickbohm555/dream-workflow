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
---

<objective>
Create phase-level test docs from built work summaries using the GSD UAT structure as the template style.

If a phase number is provided, generate tests for that phase only.
If no phase (or `all`) is provided, process phases in order, one by one.

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

## 3. Process phases one by one

For each target phase directory, in order:

1. Locate summary:
   ```bash
   ls "{PHASE_DIR}"/*-SUMMARY.md 2>/dev/null
   ```
2. Read summary content and extract user-observable outcomes/deliverables
3. Convert outcomes into concrete manual tests using the UAT structure and observable expectations
4. Write markdown file in same directory as:
   - `tests-{phase_number_without_zero_padding}.md`
   - Examples: `tests-1.md`, `tests-2.md`, `tests-10.md`

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

## 4. Present progress as phases are processed

After each phase file is written, print:
- phase number + phase name
- output path
- test count

When running `all`, continue automatically to next phase until complete.

## 5. Final response

Return a concise completion report:
- total phases processed
- files created
- any phases skipped (with reason, e.g., missing SUMMARY.md)
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
- [ ] Uses UAT-style structure from `@~/.cursor/get-shit-done/templates/UAT.md`
- [ ] Uses non-zero-padded phase number in filename (`tests-1.md`, `tests-2.md`)
- [ ] Reports created files and skipped phases
</success_criteria>
