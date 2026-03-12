1. Read `@IMPLEMENTATION_PLAN.md` and find the next incomplete section.
2. Read `@AGENTS.md` when you need build, run, test, or browser instructions.
3. Implement only the current section. Do not skip ahead.
4. Before editing, inspect the existing code so you do not rebuild something that already exists.
5. Run the checks required by the current section and by `@AGENTS.md`.
6. Update `@IMPLEMENTATION_PLAN.md` with:
   - what was built
   - any short summary needed for the phase
   - roadmap or progress notes if the section requires them
   - the completion state of the section
7. Record the section in git before stopping:
   - task execution section: `{type}({phase}-{plan}): {task-name}`
   - plan metadata section: `docs({phase}-{plan}): complete [plan-name] plan`
   - phase completion section: `docs({phase}): complete {phase-name} phase`
8. Do not end the iteration with uncommitted changes.
9. Stop after completing that section so the next loop starts with fresh context on the next section.

Keep `@AGENTS.md` operational only. Keep all build progress and summaries in `@IMPLEMENTATION_PLAN.md`.
