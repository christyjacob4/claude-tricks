---
name: slide-deck
description: Create stunning interactive slide deck presentations on any topic. Researches the topic using web search and academic papers, gathers case studies and real-world examples, then produces a self-contained interactive HTML slide deck with animations and a companion markdown file with speaker notes. TRIGGER THIS SKILL when users want to create a presentation, slide deck, talk, pitch deck, lecture slides, keynote, or any slide-based content — whether they say "make a presentation on X", "create slides about X", "build a deck for my talk on X", "I need slides for X", "prepare a presentation", "make a pitch deck", or any request involving slides, decks, or presentations.
argument-hint: "<topic>"
---

# Slide Deck Creator

Create stunning, interactive HTML slide deck presentations backed by deep research — academic papers, case studies, and real-world examples. Every deck is a self-contained HTML file with keyboard/click navigation and cinematic animations, plus a companion markdown file with speaker notes.

## Arguments

- `$ARGUMENTS` - The topic, theme, or subject for the presentation

---

## Phase 0: Requirements Clarification

Before any research or design, ask the user targeted questions to shape the presentation:

- **Audience**: Who is this for? (executives, engineers, students, general public, investors?)
- **Goal**: What should the audience walk away with? (convince, educate, inspire, inform?)
- **Depth**: High-level overview or deep technical dive?
- **Duration**: How many slides / how long is the talk? (5-min lightning talk vs 45-min keynote)
- **Tone**: Formal/corporate, casual/fun, academic, provocative, storytelling?
- **Must-include**: Any specific papers, case studies, data points, or examples to feature?
- **Must-avoid**: Any topics, framing, or competitors to steer clear of?
- **Branding**: Any color scheme, logo, or visual identity to match?
- **Code**: Should slides include code snippets or live demos?
- **Format preferences**: Dark/light theme? Any reference presentations they admire?

Present questions as a concise numbered list. **WAIT for the user to answer before proceeding.**

---

## Phase 1: Research (Parallel Agents)

After getting requirements, launch **parallel research agents** to gather material.

### Agent 1 — Academic Research

> Research academic foundations for: `$ARGUMENTS`
>
> Use **WebSearch** to find relevant arxiv paper IDs. For each promising paper, fetch its structured overview using alphaxiv:
>
> ```bash
> curl -s "https://alphaxiv.org/overview/{PAPER_ID}.md"
> ```
>
> If the overview doesn't have enough detail, fetch the full text:
>
> ```bash
> curl -s "https://alphaxiv.org/abs/{PAPER_ID}.md"
> ```
>
> For each paper, extract:
> - Key concepts and contributions
> - Important diagrams, figures, or data worth referencing
> - Quotable findings or conclusions
> - How it connects to the presentation topic
>
> Also search for survey papers that provide broader context.
>
> Return: a structured summary of 3-8 relevant papers with extracted insights, ordered by relevance.

### Agent 2 — Case Studies & Industry Research

> Research real-world applications and case studies for: `$ARGUMENTS`
>
> Use **WebSearch** and **WebFetch** to find:
> - Real-world case studies from companies using or building this
> - Industry reports, benchmarks, and statistics
> - Notable success stories and failure postmortems
> - Current trends and state of the art
> - Compelling data visualizations or metrics worth citing
> - Controversies, debates, or open questions in the field
> - Expert opinions and notable quotes
>
> Return: 5-10 concrete case studies / examples with source URLs, key data points, and how each connects to the narrative.

### Agent 3 — Visual & Narrative Inspiration

> Research presentation design and narrative structure for: `$ARGUMENTS`
>
> Consider:
> - What's the most compelling narrative arc for this topic?
> - What analogies or metaphors would make complex ideas click?
> - What visual metaphors or imagery best represent key concepts?
> - What's the "aha moment" — the single insight that makes the whole talk worth attending?
> - What data should be visualized, and how? (charts, diagrams, timelines, comparisons)
>
> Return: a proposed narrative arc (beginning/middle/end), 3-5 visual concepts, the central "aha moment", and a suggested slide outline.

**Wait for all agents to complete.** Synthesize findings into a unified content plan.

---

## Phase 2: Outline & Approval

Present a detailed slide-by-slide outline to the user:

```
## Presentation Outline: [Title]

### Narrative Arc
[One paragraph describing the story being told]

### Slide-by-Slide Plan

1. **[Slide Title]** — [What it covers, key visual, animation idea]
2. **[Slide Title]** — [What it covers, key visual, animation idea]
...
N. **[Slide Title]** — [What it covers, key visual, animation idea]

### Design Direction
- Theme: [dark/light, color palette, mood]
- Typography: [font pairing]
- Visual style: [e.g., "geometric minimalism with data-heavy accents"]
- Animation approach: [e.g., "staggered reveals, morphing transitions"]

### Sources
- [Paper 1 — how it's used]
- [Case study 1 — which slide]
- ...
```

**WAIT for user approval. Revise if requested. Do not build until approved.**

---

## Phase 3: Build the Deck

After approval, build both deliverables. These can be built in parallel by two agents.

### Agent 1 — HTML Slide Deck

Build a single self-contained HTML file with ALL CSS and JS inline. No external dependencies except Google Fonts CDN.

#### Slide Engine Requirements

**Navigation:**
- Arrow keys (left/right) to navigate between slides
- Click/tap navigation (left third = back, right third = forward)
- Slide counter showing current/total (e.g., "7 / 24")
- Progress bar across the top or bottom
- Keyboard shortcut for overview/grid mode (press `G` or `O`)
- Keyboard shortcut for presenter notes (press `N`)
- URL hash updates per slide for direct linking (#slide-7)

**Transitions:**
- Smooth transitions between slides (CSS transforms, not jarring cuts)
- Each slide can have a unique entrance animation
- Support for staggered element reveals within a slide (elements animate in sequence)
- Transition duration ~400-600ms, easing: cubic-bezier for natural feel

**Responsive:**
- Must look good on 16:9 projected displays AND laptop screens
- Font sizes adapt to viewport
- Use `vw`/`vh` units and CSS clamp() for fluid scaling

#### Design System (per /frontend-design principles)

**CRITICAL: Every deck must have a unique, distinctive visual identity. No two decks should look alike.**

Before writing any code, commit to a bold aesthetic direction for THIS specific topic:

**Typography:**
- Choose fonts that match the topic's personality — a cybersecurity talk needs different fonts than a design systems talk
- Load from Google Fonts CDN
- Pair a distinctive display/heading font with a clean body font
- NEVER use Inter, Roboto, Arial, or system fonts
- Vary font weight dramatically — ultra-bold headings, light body text

**Color & Theme:**
- Build a cohesive palette using CSS custom properties
- Dominant background color with 1-2 sharp accent colors
- Dark themes work well for technical content; light for business/design
- Use color to create visual hierarchy and emphasis
- Gradient accents, not gradient backgrounds (subtlety > spectacle)

**Slide Layouts — vary these across the deck:**
- **Title slides**: Big, bold, cinematic — minimal text, maximum impact
- **Content slides**: Clear hierarchy — heading, body, supporting visual
- **Code slides**: Syntax-highlighted code blocks with monospace font, dark background even on light themes
- **Data slides**: Custom CSS charts, comparison tables, or metric callouts — no chart libraries
- **Quote slides**: Large pull quotes with attribution
- **Image concept slides**: CSS-generated visual metaphors (geometric shapes, gradients, patterns)
- **Two-column slides**: Side-by-side comparisons, before/after, concept vs example
- **Full-bleed slides**: Edge-to-edge visual impact for key moments

**Animations & Micro-interactions:**
- Slide entrance: elements stagger in with `animation-delay` (0ms, 100ms, 200ms...)
- Text reveals: fade-up or slide-in from bottom
- Code blocks: typewriter effect or line-by-line reveal
- Data/metrics: count-up animation for numbers
- Diagrams: progressive build (elements appear one by one)
- Transitions between slides: smooth translateX or fade
- Hover states on interactive elements (if any)
- Use CSS `@keyframes` — no JS animation libraries

**Visual Details:**
- Subtle noise/grain texture overlay for depth
- Geometric accent shapes (circles, lines, dots) as decorative elements
- Consistent spacing rhythm (use multiples of 8px)
- Code blocks with custom syntax highlighting via CSS (keywords, strings, comments in different colors)
- Proper quotation marks and typographic details (em dashes, ellipses)
- Slide numbers in a refined, unobtrusive style

**Content Formatting:**
- Maximum 6-8 lines of text per slide — less is more
- One key idea per slide
- Use progressive disclosure — reveal complexity gradually
- Data points should be visually prominent (large numbers, colored callouts)
- Citations as subtle footnotes (small, dimmed, bottom of slide)
- Code snippets should be real, runnable, and syntax-highlighted

#### HTML Structure

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>[Presentation Title]</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <!-- Google Fonts -->
  <style>
    /* CSS custom properties for the design system */
    :root { ... }

    /* Reset and base */
    /* Slide engine styles */
    /* Slide layout utilities */
    /* Animation keyframes */
    /* Syntax highlighting */
    /* Individual slide styles */
    /* Navigation UI */
    /* Responsive adjustments */
    /* Print styles for PDF export */
  </style>
</head>
<body>
  <div class="deck">
    <div class="slide" id="slide-1">...</div>
    <div class="slide" id="slide-2">...</div>
    ...
  </div>
  <div class="controls">...</div>
  <script>
    // Slide engine: navigation, transitions, keyboard handling
    // Animation triggers on slide enter
    // URL hash management
    // Overview/grid mode
  </script>
</body>
</html>
```

### Agent 2 — Speaker Notes (Markdown)

Build a markdown file with detailed speaker notes for each slide:

```markdown
# Speaker Notes: [Presentation Title]

---

## Slide 1: [Title]

**Key message:** [The one thing the audience should take away]

**Talking points:**
- [Point 1 — with supporting detail]
- [Point 2 — with data/citation]
- [Point 3 — with transition to next slide]

**Timing:** ~[X] minutes

**Notes:** [Any delivery tips, audience interaction cues, or demo instructions]

---

## Slide 2: [Title]
...
```

Each slide's notes should include:
- The key message (one sentence)
- 3-5 talking points with supporting data and citations
- Suggested timing
- Transition cue to the next slide
- Delivery tips where relevant (pause here, ask the audience, demo this)

**Wait for both agents to complete.**

---

## Phase 4: Review & Polish

After both files are generated:

1. **Open the HTML file** and verify:
   - All slides render correctly
   - Navigation works (arrow keys, clicks, hash URLs)
   - Animations are smooth and purposeful
   - Code blocks are syntax-highlighted
   - No text overflow or layout breaks
   - Responsive at different viewport sizes

2. **Cross-check** speaker notes against slides — every slide has notes, every note matches its slide content

3. **Fix any issues** found during review

4. Present both files to the user:
   - `[topic]-slides.html` — the interactive slide deck
   - `[topic]-speaker-notes.md` — companion speaker notes

---

## Output Files

| File | Description |
|------|-------------|
| `[topic]-slides.html` | Self-contained interactive HTML slide deck |
| `[topic]-speaker-notes.md` | Markdown speaker notes with timing and talking points |
