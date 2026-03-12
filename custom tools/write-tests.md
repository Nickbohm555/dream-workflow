---
name: gsd-write-tests
description: Generate phase test markdown from SUMMARY files
argument-hint: "[phase number | all]"
tools:
  read: true
- Write
  - Edit
  - Glob
  - Grep
  - Bash
---

<objective>
Create simple, phase-level test docs from built work summaries.

If a phase number is provided, generate tests for that phase only.
If no phase (or `all`) is provided, process phases in order, one by one.

Output files:
- Phase 1 -> `tests-1.md`
- Phase 2 -> `tests-2.md`
- etc.

Store each test file in its own phase folder (`.planning/phases/{phase-dir}/`).
</objective>

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
3. Convert outcomes into concrete manual tests (clear pass/fail checks)
4. Write markdown file in same directory as:
   - `tests-{phase_number_without_zero_padding}.md`
   - Examples: `tests-1.md`, `tests-2.md`, `tests-10.md`

Use this file template:

```markdown
# Phase {N} Tests

Generated: {YYYY-MM-DD}
Source: {summary_filename}

## Test Checklist

- [ ] Test 1: {expected user-visible behavior}
- [ ] Test 2: {expected user-visible behavior}
- [ ] Test 3: {expected user-visible behavior}

## Notes

- Scope: Phase {N}
- Run manually and mark each checkbox
```

If a summary has little detail, still write a minimal checklist using the best available outcomes.

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

### Skipped
{none OR list phase + reason}

Next:
- Run `/gsd-verify-work {phase}` to validate interactively
- Or open `tests-{phase}.md` and execute manually
</offer_next>

<success_criteria>
- [ ] Accepts one phase number or all phases
- [ ] Iterates phases in ascending order
- [ ] Reads phase `*-SUMMARY.md` files
- [ ] Writes `tests-{phase}.md` into each phase directory
- [ ] Uses non-zero-padded phase number in filename (`tests-1.md`, `tests-2.md`)
- [ ] Reports created files and skipped phases
</success_criteria>
