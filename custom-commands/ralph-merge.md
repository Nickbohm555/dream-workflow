# Ralph merge: push branch, then merge to main with file instructions

Use this command when you're on a **ralph branch** to **push it**, then **merge into main** with explicit instructions on **which files to keep or change** during/after the merge.

**What to do:**

1. **Confirm branch**  
   Check that the current branch is a ralph branch (e.g. `ralph/...`). If you're on `main`, tell me and stop.

2. **Stage, commit, and push the ralph branch**  
   - `git add -A`  
   - `git status` — show what will be committed.  
   - Commit with the message I provide below (or a sensible default).  
   - `git push origin <current-branch>` (e.g. `git push origin ralph/add-search-ui`).

3. **Merge to main with my file instructions**  
   - Checkout `main`: `git checkout main`.  
   - Merge the ralph branch: `git merge <ralph-branch-name>` (e.g. `git merge ralph/add-search-ui`).  
   - **Apply my file instructions** (see below): for each file I list, keep the version I specify (main vs branch) or apply the change I describe. Resolve conflicts accordingly; if I said "keep main" for a file, keep main's version; if "keep branch", keep the branch version; if I gave specific edits, make those edits.  
   - After resolving, `git add` the affected files and complete the merge (or `git commit` if already merged with conflicts).

4. **Push main**  
   `git push origin main`.

**Constraint:** Only run git commands and apply the file keep/change instructions I give. If merge fails or instructions are unclear, stop and ask.

---

**Commit message for the ralph branch (optional):**

```
(your commit message, or leave blank)
```

---

**File instructions for the merge (what to keep or change):**

For each file that might conflict or where you must choose a version, say:
- **Keep main:** use the version from `main`.
- **Keep branch:** use the version from the ralph branch.
- **Custom:** describe exactly what the file should contain or what to change (e.g. "Remove the debug block in lines 10–15", "Use branch version but add one line from main at top").

Example:
```
config.json     → Keep branch
README.md       → Keep main
src/app.ts      → Keep branch but add the version check from main at line 5
```

```
(paste your file instructions here)
```
