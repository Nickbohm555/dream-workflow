# Cyberpunk README from docs

Build a **README** for this repo by reading its **architecture and system docs**, then writing a single **README.md** at the repo root with a **cyberpunk UI** (visual style; tone can be neutral) that explains the architecture of parts, the whole system, and key tradeoffs.

---

## 1. Discover and read the docs

- **Docs location:** Prefer `docs/` at the repo root. If the repo uses another path (e.g. `agent-search/docs/`, `./doc/`), discover it by scanning for markdown that describes architecture or components.
- **Piece docs:** Find all docs that describe **parts** of the system (e.g. `docs/section-01-*.md`, `docs/section-02-*.md`, `docs/METRICS.md`, `docs/COMPONENT_*.md`, or any `docs/*.md` that clearly documents a subsystem, module, or feature). Read each and extract: purpose, components, data flow, interfaces, and how it fits with the rest.
- **System doc:** Find the **single doc that describes the overall system** (e.g. `docs/SYSTEM_ARCHITECTURE.md`, `docs/OVERVIEW.md`, `docs/ARCHITECTURE.md`, or the one file that covers high-level flow, all major components, and how they connect). Read it fully.
- If no `docs/` or system doc exists, infer structure from the codebase (main packages, entrypoints, config) and from any existing README or AGENTS.md; note in the output that the README was inferred from code.

---

## 2. Content the README must include

- **Project name and one-line tagline** (optional cyberpunk flavor in the banner; otherwise keep it clear and factual).
- **Purpose (first section):** The **first substantive section** after the banner must state the **purpose of the app** — why it exists, what problem it solves, and for whom. This anchors the rest of the README; do not bury purpose in later sections.
- **Overview:** What the system does and for whom, in 1–2 short paragraphs (can reinforce purpose).
- **Architecture — parts:** For each documented piece (section/component), a subsection that summarizes:
  - What it does and its role in the system.
  - Main components, data flow, and key interfaces (keep it scannable; link to the source doc if paths are standard).
  - **Flowchart (required):** Include a **Mermaid flowchart** for the parts/subsystem (e.g. `flowchart LR` or `flowchart TB`) showing components and data flow between them. Use cyberpunk colors (see §3).
- **Architecture — whole system:** One section that describes:
  - High-level flow (request/data path end-to-end).
  - How the parts connect and where boundaries are (services, processes, deployment).
  - Runtime or deployment notes if present in the docs.
  - **Flowchart (required):** Include a **Mermaid flowchart** for the **entire system** (end-to-end flow, major components, and how they connect). Use cyberpunk colors (see §3).
- **Tradeoffs:** A dedicated section that explains:
  - Design and technology tradeoffs for the project (e.g. consistency vs speed, simplicity vs flexibility, chosen stack vs alternatives).
  - Operational or scaling tradeoffs if documented.
- **Quick start / run:** If the docs or repo contain run instructions (e.g. Docker, scripts, env vars), include a minimal "Quick start" so someone can run the system.
- **Links:** Point to the main docs (e.g. `docs/SYSTEM_ARCHITECTURE.md`, `docs/section-*.md`) and any other key references (AGENTS.md, CONTRIBUTING, etc.).

---

## 3. Cyberpunk UI (mandatory)

The README **must look** cyberpunk — visual style is required; tone can stay neutral and factual.

- **Cyberpunk colors (required for flowcharts and optional for inline):**
  - Use a **dark-background, neon palette** where the renderer allows (e.g. Mermaid `%%{init: {'theme':'base', 'themeVariables': { 'primaryColor':'#00ff9f', 'primaryTextColor':'#0d1117', 'primaryBorderColor':'#00ff9f', 'lineColor':'#ff00aa', 'secondaryColor':'#0d1117', 'tertiaryColor':'#1a1a2e'}}}%%`).
  - Preferred palette: **neon green/cyan** (`#00ff9f`, `#00ffff`) for primary/flow, **magenta/hot pink** (`#ff00aa`, `#ff006e`) for accents/edges, **dark background** (`#0d1117`, `#1a1a2e`) for nodes or panels. Use these in Mermaid diagram `style` directives (e.g. `style A fill:#0d1117,stroke:#00ff9f`) so flowcharts read as cyberpunk.
  - If the host (e.g. GitHub) does not support Mermaid theming, add a short note above each diagram: *"Rendered in neon green/cyan and magenta on dark for cyberpunk look."*
- **Visual style in Markdown (all required):**
  - Use a blockquote or banner at the top with a short, terminal-like or "system status" line (e.g. `> SYSTEM README — DOCS COMPILED` or `> [REPO_NAME] — ARCHITECTURE MAP`).
  - Use `code` or `` ` `` for technical terms, and **bold** for section headers or key concepts so they feel like labels in a HUD.
  - Use horizontal rules (`---`) to separate major sections so the page feels like discrete panels.
  - Use tables for "parts" or component summaries where it makes sense (component | role | doc).
  - Optional: use emoji sparingly and only if they fit the theme (e.g. ⚡, ▸, ◉) for bullets or status.

- **Tone:** No requirement. Write in a clear, factual way; cyberpunk phrasing is optional.

- **Structure:**
  - Clear hierarchy: tagline → **purpose** → overview → architecture (parts + part flowcharts) → architecture (whole + whole-system flowchart) → tradeoffs → quick start → links.
  - Readers should see **why the app exists** first, then "what are the pieces?" (with part flowcharts), "how does the whole thing work?" (with whole-system flowchart), and "what did we trade off?".

---

## 4. Output and constraints

- **Write to:** `README.md` at the **root of the repo** you're in (e.g. workspace root, or the folder that contains `docs/` and the main code). Overwrite if the file exists.
- **Only create or edit:** `README.md`. Do not create or change other files (e.g. do not add new docs or rename existing ones).
- **Source of truth:** Everything in the README must be derived from the repo’s docs (and, if needed, from code when docs are missing). Do not invent features or components.
- **Length:** Prefer concise over long. One page is ideal; two is acceptable if the project has many parts. Use bullets and tables so the README stays scannable.

---

## 5. After generating

Reply with a short summary: which docs you read (list paths), what you used for "parts" vs "whole system", how you stated **purpose** in the first section, and one sentence on how you applied the cyberpunk UI (including flowcharts and colors). If no system doc was found, say so and note that the full-system section was inferred from code and piece docs.
