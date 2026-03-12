# Section template

Insert the following section template. Use this structure for every implementation section: Section title, Single goal, Details, **Tech stack and dependencies**, Files and purpose (table), How to test, Test results (when done).

**Constraint:** Only add or edit content in `IMPLEMENTATION_PLAN.md`. Add once i say to. Do not create or write to any other file.

**Atomic sections:** Each section must cover exactly one topic and one deliverable. Atomic means: one section = one capability, one feature, or one cohesive change. If a section would cover multiple distinct things (e.g. "Add auth and logging" or "API endpoint plus frontend form"), split it into separate sections. Rule of thumb: if you can list parts with "and" or "plus" or "including", it is not atomic—split it.

---

## Section N: Title – scope

**Single goal:** One sentence describing the one thing this section achieves. Must be a single outcome; if you need "and" or "including", split into more sections.

**Details:**
- Requirement or constraint 1.
- Requirement or constraint 2.

**Tech stack and dependencies**
- Libraries/packages (pip, npm, uv, etc.): list any new or changed dependencies and where they are declared (e.g. pyproject.toml, requirements.txt, package.json).
- Tooling (uv, poetry, Docker): base image, Dockerfile or docker-compose changes, new commands or scripts.

**Files and purpose**

| File | Purpose |
|------|--------|
| path/to/file | What this file does. |

**How to test:** How to verify (pytest, manual, etc.). TDD when applicable.

**Test results:** (Add when section is complete.)
- Command and outcome.

---

**MANDATORY before marking section complete or moving to `agent-search/completed.md`:**
1. **Restart the application** after all code for this section is built (e.g. stop then start the app/server/containers).
2. **Check all logs** (app logs, build logs, runtime logs) and **run all relevant tests** (unit, integration, or commands from "How to test").
3. **If anything fails** (startup error, test failure, bad logs, browser/API errors): read the logs and test output, fix the cause, then **repeat from step 1** (restart and re-check). Do **not** call the section "completed" or add it to `completed.md` until everything passes.
4. Only after a successful restart and passing checks (and browser check when applicable), record outcomes under **Test results** and then mark the section complete / move to `completed.md`.
