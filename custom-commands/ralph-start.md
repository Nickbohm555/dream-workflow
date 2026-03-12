# Ralph start: save main, then create branch

Use this command to **save all work on main**, then **create a new ralph branch** for feature work.

**What to do:**

1. **Confirm branch**  
   Check that the current branch is `main`. If not, tell me and stop.

2. **Stage and commit**  
   - `git add -A` (add everything).  
   - `git status` — show me what will be committed.  
   - Commit with a message I provide below (or a sensible default if I don’t).

3. **Push main**  
   `git push origin main` (or `git push` if upstream is set).

4. **Create ralph branch**  
   Create and checkout a new branch: `ralph/<name>`, where `<name>` is what I specify below (e.g. `ralph/add-search-ui`).  
   - `git checkout -b ralph/<name>`

**Constraint:** Only run git commands. Do not modify files. If anything fails (e.g. not on main, push rejected), stop and report.

---

**Branch name (the part after `ralph/`):**

```
(insert name, e.g. add-search-ui or fix-login)
```

---

**Commit message (optional; leave blank for a default):**

```
(your commit message, or leave blank)
```
