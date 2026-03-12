<purpose>
**Phase 1: Requirements Definition.** Build specs from a Job to be Done (JTBD) by identifying topics of concern, capturing requirements, and defining acceptance criteria (observable, verifiable outcomes). One spec file per topic in `specs/`. Use ask_question throughout; use subagents to load external context when needed. Acceptance criteria in specs become the foundation for deriving test requirements in the planning phase.
</purpose>

<concepts>
| Term | Definition |
|------|------------|
| **Job to be Done (JTBD)** | High-level user need or outcome |
| **Topic of concern** | A distinct aspect/component within a JTBD |
| **Spec** | Requirements doc for one topic of concern → `specs/FILENAME.md` |
| **Task** | Unit of work derived from comparing specs to code (later step) |

**Relationships:**
- 1 JTBD → multiple topics of concern
- 1 topic of concern → 1 spec
- 1 spec → multiple tasks (specs are larger than tasks)

**Acceptance criteria:** Observable, verifiable outcomes that indicate success for a topic. Must be **behavioral** (what we observe or can check), not implementation (how to build it). Planning phase derives test requirements from these.

**Example:**
- JTBD: "Help designers create mood boards"
- Topics: image collection, color extraction, layout, sharing
- Each topic → one spec file in specs/ (with acceptance criteria)
- Each spec → many tasks + test requirements in planning phase
</concepts>

<topic_scope_test>
**Topic Scope Test: "One Sentence Without 'And'"**

Can you describe the topic of concern in one sentence without conjoining unrelated capabilities?

✓ "The color extraction system analyzes images to identify dominant colors"
✗ "The user system handles authentication, profiles, and billing" → 3 topics

If you need "and" to describe what it does, it's probably multiple topics. Split them.
</topic_scope_test>

<process>

<step name="setup" priority="first">
**Ensure specs directory exists:**
```bash
mkdir -p specs
```

**If $ARGUMENTS provided:** Treat as initial JTBD statement. Confirm with user or refine via ask_question.

**If no $ARGUMENTS:** Discover JTBD using ask_question:
- header: "Job to be Done"
- question: "What's the high-level user need or outcome you're building for?"
- options: Offer 2–3 common patterns if helpful, plus "Describe in my own words" (or freeform follow-up)

Capture JTBD in one clear sentence. Continue to load_external_context (or identify_topics if skip).
</step>

<step name="load_external_context">
**When to use:** Domain is unfamiliar, or user asks for research / "what's standard?" / "load docs or examples."

Use ask_question:
- header: "External context"
- question: "Need to load external context before we spec? (e.g. domain research, API docs, patterns)"
- options: "Yes — research / load context" / "No — continue with what we have"

**If "Yes":** Spawn a subagent (e.g. generalPurpose or research-type) with a prompt to gather the needed context (docs, patterns, examples). Inline the JTBD and topic list. Wait for subagent to complete. Summarize or attach key findings, then continue to identify_topics with that context in mind.

**If "No":** Continue to identify_topics.
</step>

<step name="identify_topics">
From the JTBD, propose 3–6 candidate **topics of concern**. Each must pass the one-sentence-without-"and" test.

**Apply the test:** For each candidate, can you state it in one sentence without "and"? If not, split.

**Then use ask_question (multiSelect: true):**
- header: "Topics to spec"
- question: "Which of these topics do you want to spec for [JTBD]? (Each becomes one spec file.)"
- options: List the candidate topics, each as a short label with optional one-line description

**Do NOT include "skip" or "all done."** User ran this to build specs — give real choices. They can add more topics later.

**If user says "I need another topic":** Add it, re-run scope test, then continue.

Continue to discuss_topic for each selected topic (in an order that makes sense).
</step>

<step name="discuss_topic">
For each selected topic, run a short discussion loop to capture requirements.

**1. State the topic and scope:**
```
Topic: [Name]
One-sentence scope: [The sentence without "and"]
We'll capture requirements for this only. Other capabilities = other specs.
```

**2. Ask 4–6 questions using ask_question** to cover:
- Boundaries (in scope vs out of scope for this topic)
- Key behaviors or outcomes
- Constraints or preferences (e.g. format, performance, UX)
- "You decide" where implementation can be flexible

Use ask_question each time:
- header: "[Topic name]"
- question: [Specific question]
- options: 2–4 concrete choices; include "You decide" when reasonable
- ask_question adds "Other" automatically

**3. Discuss and define acceptance criteria** (before "Write spec"):

Use ask_question to define 2–5 **acceptance criteria** for this topic. Criteria must be:
- **Observable, verifiable outcomes** — what we can see or check (e.g. "User sees 3–5 colors within 2s")
- **Behavioral** — outcomes, not implementation (✓ "Export produces a PDF" ✗ "Use library X to generate PDF")
- Will become the **foundation for test requirements** in the planning phase

Use ask_question:
- header: "[Topic name] — Acceptance criteria"
- question: "What observable outcomes indicate success for this topic? (We'll use these to derive tests later.)"
- options: Propose 2–4 concrete criteria; allow "Other" for user to add. Optionally a second question: "Any other success outcomes we should verify?"

**Rule:** Phrase each criterion as something we can observe or verify, not as a technical step.

**4. After requirements + acceptance criteria, check:**
- header: "[Topic name]"
- question: "More to capture for [topic], or ready to write the spec?"
- options: "More questions" / "Write spec"

If "More questions" → ask 2–4 more, then check again.
If "Write spec" → continue to write_spec for this topic.
</step>

<step name="write_spec">
For the topic just discussed, create one spec file.

**Filename:** `specs/[slug].md` — slug from topic name (lowercase, hyphens, e.g. `color-extraction.md`).

**Content:** Use the spec template. Include:
- Topic name and one-sentence scope
- Requirements/decisions captured from ask_question answers
- **Acceptance criteria** — observable, verifiable outcomes from discussion (behavioral, not implementation). Include in whatever structure fits this spec best: dedicated section, list, or woven into requirements. Planning phase will derive test requirements from these.
- Boundaries (what this spec does not cover)
- Claude's discretion (where implementation is flexible)

**Template reference:** @~/.cursor/get-shit-done/templates/spec.md

Write the file. If more topics remain, return to discuss_topic. Otherwise continue to confirm_creation.
</step>

<step name="confirm_creation">
Summarize what was created and offer next steps:

```
Created specs:
- specs/[slug1].md — [Topic 1]
- specs/[slug2].md — [Topic 2]
...

JTBD: [One-sentence JTBD]

---
▶ Next steps
- **Planning phase:** Derive tasks from specs (compare to code) and **derive test requirements from acceptance criteria** in each spec
- Add more topics: run /gsd-discuss-specs again and add topics for the same JTBD
- Edit any spec file in specs/ then re-run planning
---
```
</step>

</process>

<success_criteria>
- JTBD is clear and in one sentence
- External context loaded via subagents when needed
- Every topic passes the one-sentence-without-"and" test
- Acceptance criteria defined per topic (observable, verifiable, behavioral)
- One spec file per discussed topic in specs/ including acceptance criteria
- Each spec has boundaries, requirements, acceptance criteria, and discretion areas
- Specs ready for planning to derive tasks and test requirements from acceptance criteria
- User knows how to add more topics or run planning next
</success_criteria>
