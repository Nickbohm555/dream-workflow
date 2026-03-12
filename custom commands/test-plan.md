# Test plan – atomic testing sections

Build a **test plan** as atomic testing sections using the **section template** format. Write the result to **`agent-search/test_plan.md`** (create or overwrite). Do not add or edit content in `IMPLEMENTATION_PLAN.md` or `completed.md`.

**What to do:**

1. **Read testing and app context**
   - Read **`agent-search/AGENTS.md`** for:
     - **Docker logs:** e.g. `docker compose logs -f`, `docker compose logs -f backend`, `docker compose logs -f frontend`, `docker compose ps`, health/API URLs.
     - **Browser / ChromeDev workflow:** e.g. `./launch-devtools.sh http://localhost:5173`, DevTools target `http://127.0.0.1:9222/json/list`, and any instructions for using the browser MCP (cursor-ide-browser) to drive the app and click "Run" or equivalent.
   - Read **`agent-search/IMPLEMENTATION_PLAN.md`** (and optionally **`agent-search/completed.md`**) to see which implementation sections exist and what each delivers, so each test section can target one capability.

2. **One section = one atomic test**
   - Each testing section must cover **exactly one** verifiable outcome (one user action, one API path, one log assertion, one UI check). If a test would verify multiple unrelated things, split it into separate sections.
   - Order tests so they can be run **sequentially** where it makes sense (e.g. start app → health → load data → run query → check UI and logs).

3. **Real tests only – no mocks**
   - Tests must be **real**: run the app (Docker), use **docker logs** to assert backend/frontend behavior, and use **ChromeDev** (browser MCP or launch-devtools workflow) to open the app, click "Run" (or the relevant button), and confirm the UI and flow behave as expected.
   - For each section, specify: exact **docker** commands (e.g. `docker compose up -d`, `docker compose logs -f backend`), what to **look for in logs**, and what to **do in the browser** (e.g. navigate to URL, click Run, check for a result or error). Do not rely on unit/mock tests as the primary verification; those can be mentioned only as optional extras.

4. **Use the section template**
   - For every testing section use this structure (same as the section-documentation-template rule):

```md
---
## Test Section N: Title – scope

**Single goal:** One sentence: the one thing this test proves (e.g. "Confirm backend health returns 200 after startup" or "Confirm clicking Run runs the agent and shows a result in the UI").

**Details:**
- Requirement or constraint 1.
- Requirement or constraint 2.

**Tech stack and dependencies**
- Docker Compose (backend, frontend, db); browser (ChromeDev / cursor-ide-browser). No new packages unless a test explicitly needs one.

**Files and purpose**

| File | Purpose |
|------|--------|
| (N/A or path) | What this test touches or verifies. |

**How to test:** Step-by-step: (1) Docker commands to run and what to check in logs, (2) Browser: open app, what to click (e.g. Run), what to expect on screen or in DevTools. Be specific so someone can run it manually or via ChromeDev.

**Test results:** (Fill when test has been run.)
- Command and outcome.
---
```

5. **Output**
   - Create or overwrite **`agent-search/test_plan.md`** with:
     - A short intro that says tests are atomic, sequential where applicable, and use docker logs + ChromeDev (real runs, no mocks).
     - Then one **Test Section N** per atomic test, in execution order, using the template above.
   - Optionally map each test section to the implementation section(s) it validates (e.g. "Validates Section 2: Initial search" in the Details or Single goal).

**Constraint:** Only add or edit content in **`agent-search/test_plan.md`**. Do not create or modify other files unless the user asks.

After generating `test_plan.md`, give a one-paragraph summary of how many test sections you added and how they are ordered (e.g. startup → health → data load → run flow → UI/log checks).
