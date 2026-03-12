# Spec Template

Template for `specs/FILENAME.md` — one file per **topic of concern**. Each spec includes requirements and **acceptance criteria**. Acceptance criteria are observable, verifiable outcomes (behavioral, not implementation) and become the **foundation for deriving test requirements** in the planning phase.

**Concepts:**
- **Topic of concern** — One distinct aspect within a JTBD (one sentence without "and")
- **Spec** — This file. Requirements + acceptance criteria for that one topic.
- **Acceptance criteria** — Observable, verifiable outcomes that indicate success. Behavioral (what we see/check), not implementation (how to build). Planning derives test requirements from these.
- **Task** — Unit of work derived later by comparing specs to code.

**Filename:** Use a slug from the topic name: lowercase, hyphens (e.g. `color-extraction.md`, `image-collection.md`).

---

## File Template

```markdown
# [Topic Name] — Spec

**JTBD:** [One-sentence job to be done this topic supports]
**Scope (one sentence, no "and"):** [What this topic covers]
**Status:** Draft | Ready

<scope>
## Topic Boundary

[One-sentence scope repeated. What is in scope for this spec and what is explicitly out of scope (other topics/specs).]
</scope>

<requirements>
## Requirements

### [Area 1 from discussion]
- [Requirement or decision]
- [Requirement or decision]

### [Area 2 from discussion]
- [Requirement or decision]

### Claude's Discretion
[Areas where user said "you decide" — implementation can choose approach]
</requirements>

<acceptance_criteria>
## Acceptance Criteria

[Observable, verifiable outcomes that indicate success for this topic. Behavioral (outcomes we can see or check), not implementation. Planning phase will derive test requirements from these.]

Include acceptance criteria in whatever structure fits this spec best: this dedicated section, a list under requirements, or woven into requirement bullets. Each criterion should be something we can observe or verify.

Examples of good criteria:
- "User sees 3–5 dominant colors within 2s after adding an image"
- "Export produces a PDF that opens in standard viewers"
- "Empty state shows [X] and suggests [Y]"
</acceptance_criteria>

<boundaries>
## Out of Scope (Other Specs)

[Capabilities that belong to other topics/specs. Keeps this spec focused.]
</boundaries>

---

*Topic: [name]*
*Spec created: [date]*
```

---

## Good Examples

**Example: color-extraction.md (mood board JTBD)**

```markdown
# Color Extraction — Spec

**JTBD:** Help designers create mood boards
**Scope (one sentence, no "and"):** The color extraction system analyzes images to identify dominant colors.
**Status:** Ready

<scope>
## Topic Boundary

This spec covers: reading an image, computing dominant colors (e.g. 3–5), and exposing them for use by the layout/saving topics. It does not cover where images come from (image collection spec) or how colors are displayed on the board (layout spec).
</scope>

<requirements>
## Requirements

### Input
- Accept at least JPEG and PNG
- Support single image per extraction; batch is out of scope for v1

### Output
- Return 3–5 dominant colors (hex or similar)
- Order by dominance (most prominent first)

### Performance
- Result in under 2s for typical image size

### Claude's Discretion
- Exact algorithm (e.g. k-means vs palette sampling)
- Fallback when image has very few colors
</requirements>

<acceptance_criteria>
## Acceptance Criteria

- Given an image (JPEG/PNG), user sees 3–5 dominant colors displayed within 2 seconds.
- Colors are ordered by dominance (most prominent first).
- Result is stable for the same image (repeatable).
</acceptance_criteria>

<boundaries>
## Out of Scope (Other Specs)

- Image collection / upload → image-collection.md
- Layout of swatches on board → layout.md
- Saving or sharing the board → sharing.md
</boundaries>

---
*Topic: color-extraction*
*Spec created: 2025-03-02*
```

---

**Example: layout.md (mood board JTBD)**

```markdown
# Layout — Spec

**JTBD:** Help designers create mood boards
**Scope (one sentence, no "and"):** The layout system arranges collected images and color swatches on a canvas for the mood board.
**Status:** Ready

<scope>
## Topic Boundary

This spec covers: placement of images and color swatches on the board, grid vs freeform, and how the user can rearrange. It does not cover adding images (image collection) or extracting colors (color extraction).
</scope>

<requirements>
## Requirements

### Layout mode
- Grid or freeform (user choice per board)

### Elements on board
- Images (from image collection)
- Color swatches (from color extraction), shown as small blocks with hex label

### Interaction
- Drag to reposition
- Resize images (optional for v1 — you decide)

### Claude's Discretion
- Default grid size and spacing
- Freeform snap-to-grid behavior
- Empty state of the canvas
</requirements>

<acceptance_criteria>
## Acceptance Criteria

- User can choose grid or freeform per board and the choice is persisted.
- User can drag images and swatches to reposition; new positions persist.
- Board shows images and color swatches (with hex label) as specified.
</acceptance_criteria>

<boundaries>
## Out of Scope (Other Specs)

- Image collection → image-collection.md
- Color extraction → color-extraction.md
- Sharing/export → sharing.md
</boundaries>

---
*Topic: layout*
*Spec created: 2025-03-02*
```

---

## Anti-patterns

- **One spec per JTBD** — Wrong. One spec per *topic*. Multiple specs per JTBD.
- **Topic described with "and"** — Split into multiple topics and multiple specs.
- **Vague requirements** — Prefer testable or concrete decisions from discussion.
- **Mixing topics** — If a requirement belongs to another topic, note it in Out of Scope and give it its own spec.
- **Acceptance criteria that describe implementation** — Criteria must be outcomes we can observe or verify (behavioral), not how to build (e.g. ✓ "User sees 3–5 colors within 2s" ✗ "Use k-means for clustering").
