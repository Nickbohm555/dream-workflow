1. Read `@IMPLEMENTATION_PLAN.md` and find the next incomplete section.
2. Read `@AGENTS.md` when you need build, run, test, or browser instructions.
3. Implement only the current section. Do not skip ahead.
4. Before editing, inspect the existing code so you do not rebuild something that already exists.
5. Run the checks and actions required by the current section and by `@AGENTS.md`.
6. Do not run `git commit` or `git push` yourself. Instead, write `.loop-commit-msg` with the exact commit subject before stopping:
   - task execution section: `{type}({phase}-{plan}): {task-name}`
   - plan metadata section: `docs({phase}-{plan}): complete [plan-name] plan`
   - phase completion section: `docs({phase}): complete {phase-name} phase`
7. The first line of `.loop-commit-msg` must be only the final commit subject.
8. Do not end the iteration with uncommitted changes.
9. Stop after completing that section and return 20 thumbs up so the user knows we finished.

Keep `@AGENTS.md` operational only.
