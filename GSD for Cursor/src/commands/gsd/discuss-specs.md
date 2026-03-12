---
name: gsd-discuss-specs
description: Build specs from Job to be Done → topics of concern using guided questioning
argument-hint: "[JTBD or leave blank to discover]"
tools:
  read: true
  write: true
  bash: true
  glob: true
  grep: true
  ask_question: true
---

<objective>
**Phase 1: Requirements Definition.** Turn a Job to be Done (JTBD) into concrete spec files: one spec per topic of concern, written to `specs/`. Each spec includes requirements and **acceptance criteria** (observable, verifiable outcomes). Uses ask_question to discover JTBD, identify topics, capture requirements, and define acceptance criteria. Use subagents when external context is needed (research, docs, patterns).

**Concepts:**
- **JTBD** — High-level user need or outcome
- **Topic of concern** — Distinct aspect within a JTBD (one sentence without "and")
- **Spec** — Requirements doc for one topic → `specs/FILENAME.md` (includes acceptance criteria)
- **Acceptance criteria** — Observable, verifiable outcomes that indicate success; behavioral (what we see), not implementation (how to build). Foundation for deriving test requirements in planning phase.
- **Task** — Unit of work from comparing specs to code (later step)

**Flow:** 1 JTBD → multiple topics → 1 topic → 1 spec (with acceptance criteria) → (planning) test requirements + tasks.

**Output:** `specs/*.md` — one file per topic, with acceptance criteria; ready for implementation and test planning.
</objective>

<execution_context>
@~/.cursor/get-shit-done/workflows/discuss-specs.md
@~/.cursor/get-shit-done/templates/spec.md
</execution_context>

<context>
Optional argument: $ARGUMENTS (JTBD or empty to discover)

**If project has planning state, load:**
@.planning/PROJECT.md
@.planning/STATE.md

**If specs already exist:**
@specs/
</context>

<process>
1. **Discover or confirm JTBD** — If no argument, use ask_question to capture the high-level job to be done.
2. **Load external context when needed** — If domain is unfamiliar or user asks ("research X", "what's standard?"), use subagents to gather external context (docs, patterns, examples); then resume discussion with that context.
3. **Identify topics of concern** — Use ask_question (multiSelect) so user selects which topics to spec. Apply Topic Scope Test: one sentence without "and".
4. **Deep-dive each topic** — Use ask_question to capture requirements, boundaries, and decisions per topic.
5. **Discuss and define acceptance criteria** — For each topic, use ask_question to define observable, verifiable outcomes (what we can see or check). Keep criteria **behavioral** (outcomes), not implementation (how to build). These become the foundation for test requirements in the planning phase.
6. **Write spec files** — One file per topic in `specs/` using the spec template. Include acceptance criteria in whatever structure fits the spec best (dedicated section, list, or woven into requirements).
7. **Offer next steps** — Derive tasks and test requirements from specs (planning phase), or add more topics.

**Topic Scope Test:** Can you describe the topic in one sentence without "and"?
- ✓ "The color extraction system analyzes images to identify dominant colors"
- ✗ "The user system handles authentication, profiles, and billing" → split into 3 topics

**Acceptance criteria rule:** Describe outcomes we can observe or verify, not the implementation. ✓ "User sees 3–5 dominant colors within 2s after adding an image" ✗ "Use k-means for color clustering"
</process>

<success_criteria>
- JTBD clearly stated
- Topics pass the one-sentence-without-"and" test
- External context loaded via subagents when needed
- Acceptance criteria defined per topic (behavioral, verifiable)
- One spec file per topic in specs/ including acceptance criteria
- Specs ready for planning phase to derive tasks and test requirements
- User knows next steps
</success_criteria>
