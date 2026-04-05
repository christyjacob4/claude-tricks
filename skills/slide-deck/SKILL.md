---
name: slide-deck
description: Create stunning interactive slide deck presentations on any topic. Researches the topic using web search and academic papers (via alphaxiv), extracts figures and diagrams from papers (via pdf skill), gathers case studies and real-world examples, then produces a self-contained interactive HTML slide deck with D3.js charts, Anime.js animations, and a companion markdown file with speaker notes. TRIGGER THIS SKILL when users want to create a presentation, slide deck, talk, pitch deck, lecture slides, keynote, or any slide-based content — whether they say "make a presentation on X", "create slides about X", "build a deck for my talk on X", "I need slides for X", "prepare a presentation", "make a pitch deck", or any request involving slides, decks, or presentations.
argument-hint: "<topic>"
---

# Slide Deck Creator

Create stunning, interactive HTML slide deck presentations backed by deep research — academic papers, case studies, and real-world examples. Every deck is a self-contained HTML file with D3.js visualizations, Anime.js animations, keyboard/click navigation, and embedded figures extracted from referenced papers. Plus a companion markdown file with speaker notes.

## Dependencies

This skill uses other skills from the claude-tricks plugin:
- **alphaxiv-paper-lookup** — for fetching structured overviews of arxiv papers
- **pdf** — for extracting figures, tables, and diagrams from paper PDFs
- **frontend-design** — for visual design principles and aesthetics

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

### Agent 1 — Academic Research & Figure Extraction

> Research academic foundations for: `$ARGUMENTS`
>
> **Step 1: Find papers**
> Use **WebSearch** to find relevant arxiv paper IDs on the topic.
>
> **Step 2: Get paper overviews via alphaxiv**
> For each promising paper, fetch its structured overview:
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
> - Important diagrams, figures, tables, or results worth showing in slides
> - Quotable findings or conclusions
> - How it connects to the presentation topic
>
> **Step 3: Extract figures and diagrams from papers**
> For papers with important visuals (architecture diagrams, result tables, charts, figures), download the PDF and extract the images using the **pdf** skill:
>
> ```bash
> # Download the paper PDF
> curl -sL "https://arxiv.org/pdf/{PAPER_ID}" -o /tmp/{PAPER_ID}.pdf
>
> # Convert relevant pages to images
> python3 scripts/convert_pdf_to_images.py /tmp/{PAPER_ID}.pdf /tmp/{PAPER_ID}_pages/
> ```
>
> Use `pdfplumber` to identify figure bounding boxes and extract specific figures:
>
> ```python
> import pdfplumber
> from PIL import Image
>
> pdf = pdfplumber.open(f"/tmp/{PAPER_ID}.pdf")
> page = pdf.pages[PAGE_NUMBER]
> # Extract image at bounding box coordinates
> im = page.to_image(resolution=300)
> im.crop((x0, y0, x1, y1)).save(f"/tmp/{PAPER_ID}_fig{N}.png")
> ```
>
> Convert extracted images to base64 for embedding in the HTML deck:
>
> ```bash
> base64 -i /tmp/{PAPER_ID}_fig{N}.png
> ```
>
> Return: a structured summary of 3-8 relevant papers with extracted insights, ordered by relevance. For each paper with useful visuals, include the base64-encoded figure data and a caption/citation.
>
> Also search for survey papers that provide broader context.

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
> - What data should be visualized, and how? (D3.js charts, animated diagrams, interactive graphs)
> - Which concepts need interactive visualizations vs static figures from papers?
>
> For each slide concept, decide the diagram type:
> - **Paper figure**: Use extracted image from the paper (architecture diagrams, published results, tables)
> - **Interactive D3.js**: Use for data that benefits from interactivity (charts, graphs, network diagrams, treemaps, timelines)
> - **Animated diagram**: Use Anime.js for step-by-step concept explanations (algorithm flows, process diagrams, build-up sequences)
> - **CSS visual**: Use for simple decorative or conceptual visuals (geometric patterns, gradients, shapes)
>
> Return: a proposed narrative arc (beginning/middle/end), 3-5 visual concepts with diagram type for each, the central "aha moment", and a suggested slide outline.

**Wait for all agents to complete.** Synthesize findings into a unified content plan.

---

## Phase 2: Outline & Approval

Present a detailed slide-by-slide outline to the user:

```
## Presentation Outline: [Title]

### Narrative Arc
[One paragraph describing the story being told]

### Slide-by-Slide Plan

1. **[Slide Title]** — [What it covers] | Visual: [paper figure / D3 chart / anime.js animation / CSS]
2. **[Slide Title]** — [What it covers] | Visual: [type + description]
...
N. **[Slide Title]** — [What it covers] | Visual: [type + description]

### Design Direction
- Theme: [dark/light, color palette, mood]
- Typography: [font pairing]
- Visual style: [e.g., "geometric minimalism with data-heavy accents"]
- Animation approach: [e.g., "staggered reveals with D3 transitions"]

### Paper Figures to Embed
- Figure X from [Paper Name] — [which slide, what it shows]
- Table Y from [Paper Name] — [which slide, what it shows]

### Interactive Visualizations
- Slide N: [D3.js chart type — what data it shows]
- Slide M: [Anime.js animation — what concept it illustrates]

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

Build a single self-contained HTML file. External dependencies loaded from CDN:
- **Google Fonts** — typography
- **D3.js** (v7) — interactive data visualizations and charts
- **Anime.js** (v3) — complex timeline animations and interactive diagrams

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
- **Data slides**: D3.js interactive charts, comparison tables, or metric callouts
- **Quote slides**: Large pull quotes with attribution
- **Paper figure slides**: Embedded images from papers with citation, styled with subtle borders/shadows
- **Interactive diagram slides**: Anime.js step-by-step animations that build up a concept
- **Two-column slides**: Side-by-side comparisons, before/after, concept vs example
- **Full-bleed slides**: Edge-to-edge visual impact for key moments

#### Two Types of Diagrams

**1. Paper Figures (static, extracted from PDFs)**
Figures, tables, results, and architecture diagrams extracted from referenced papers using the **pdf** skill. These are embedded as base64 `<img>` tags:

```html
<div class="paper-figure">
  <img src="data:image/png;base64,{BASE64_DATA}" alt="[description]" />
  <figcaption>Figure 3 from Smith et al., 2024 — "[Paper Title]"</figcaption>
</div>
```

Style paper figures with:
- Subtle border or shadow to frame them
- Caption below with paper citation in a dimmed, smaller font
- Optional zoom-on-click interaction
- Responsive sizing within the slide

**2. Interactive Visualizations (D3.js + Anime.js)**
For data and concepts that benefit from interactivity or animation:

**D3.js** — use for data-driven visuals:
- Bar charts, line charts, area charts with animated transitions
- Network/graph diagrams (force-directed layouts)
- Treemaps and sunburst charts for hierarchical data
- Timelines with interactive hover states
- Scatter plots and bubble charts
- Geographic maps if relevant
- Sankey diagrams for flow data

```html
<div class="d3-chart" id="slide-5-chart"></div>
<script>
  // D3 visualization initialized when slide becomes active
  function initSlide5Chart() {
    const svg = d3.select('#slide-5-chart').append('svg')...
  }
</script>
```

**Anime.js** — use for animated concept diagrams:
- Step-by-step algorithm or process visualizations
- Architecture diagrams that build up piece by piece
- Animated flowcharts and sequence diagrams
- Morphing shapes to illustrate transformations
- Staggered timeline animations for complex concepts
- Path-drawing animations (SVG stroke-dashoffset)

```html
<div class="anime-diagram" id="slide-8-diagram">
  <!-- SVG elements for the diagram -->
</div>
<script>
  function initSlide8Diagram() {
    anime.timeline({...})
      .add({ targets: '.step-1', opacity: [0,1], translateY: [20,0] })
      .add({ targets: '.step-2', opacity: [0,1], translateY: [20,0] })
      ...
  }
</script>
```

Each interactive visualization should:
- Initialize only when its slide becomes active (lazy loading)
- Replay from the beginning when navigating back to the slide
- Have a fallback static state if animations are disabled
- Be sized responsively within the slide container

#### Animations & Micro-interactions

- Slide entrance: Anime.js timeline with staggered element reveals
- Text reveals: fade-up or slide-in with easing
- Code blocks: typewriter effect or line-by-line reveal via Anime.js
- Data/metrics: D3 count-up transitions for numbers
- D3 charts: animated data entry with `transition().duration(800)`
- Diagrams: Anime.js progressive build (elements appear one by one along a timeline)
- Transitions between slides: CSS translateX or fade
- Hover states on D3 chart elements (tooltips, highlights)

#### Visual Details

- Subtle noise/grain texture overlay for depth
- Geometric accent shapes (circles, lines, dots) as decorative elements
- Consistent spacing rhythm (use multiples of 8px)
- Code blocks with custom syntax highlighting via CSS (keywords, strings, comments in different colors)
- Proper quotation marks and typographic details (em dashes, ellipses)
- Slide numbers in a refined, unobtrusive style
- Paper figures framed with consistent styling throughout the deck

#### Content Formatting

- Maximum 6-8 lines of text per slide — less is more
- One key idea per slide
- Use progressive disclosure — reveal complexity gradually
- Data points should be visually prominent (large numbers, colored callouts)
- Citations as subtle footnotes (small, dimmed, bottom of slide)
- Code snippets should be real, runnable, and syntax-highlighted
- Paper figures should be large enough to read but not overwhelming

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
  <!-- D3.js from CDN -->
  <script src="https://d3js.org/d3.v7.min.js"></script>
  <!-- Anime.js from CDN -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/animejs/3.2.2/anime.min.js"></script>
  <style>
    /* CSS custom properties for the design system */
    :root { ... }

    /* Reset and base */
    /* Slide engine styles */
    /* Slide layout utilities */
    /* Paper figure styles */
    /* D3 chart container styles */
    /* Anime diagram styles */
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
    <!-- Slide with paper figure -->
    <div class="slide" id="slide-5">
      <div class="paper-figure">
        <img src="data:image/png;base64,..." alt="..." />
        <figcaption>...</figcaption>
      </div>
    </div>
    <!-- Slide with D3 chart -->
    <div class="slide" id="slide-8">
      <div class="d3-chart" id="chart-8"></div>
    </div>
    <!-- Slide with Anime.js diagram -->
    <div class="slide" id="slide-12">
      <div class="anime-diagram" id="diagram-12">...</div>
    </div>
    ...
  </div>
  <div class="controls">...</div>
  <script>
    // Slide engine: navigation, transitions, keyboard handling
    // Animation triggers on slide enter/leave
    // D3 chart initialization functions
    // Anime.js diagram initialization functions
    // URL hash management
    // Overview/grid mode
    // Lazy loading: init visualizations only when slide is active
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

**Visual on screen:** [Description of what the audience sees — paper figure, D3 chart, animation]

**Timing:** ~[X] minutes

**Notes:** [Any delivery tips, audience interaction cues, or demo instructions]

---

## Slide 2: [Title]
...
```

Each slide's notes should include:
- The key message (one sentence)
- 3-5 talking points with supporting data and citations
- Description of the visual element on screen and what to call attention to
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
   - D3 charts render and animate correctly
   - Anime.js diagrams play their timelines
   - Paper figures display at correct resolution and sizing
   - Animations are smooth and purposeful
   - Code blocks are syntax-highlighted
   - No text overflow or layout breaks
   - Responsive at different viewport sizes

2. **Cross-check** speaker notes against slides — every slide has notes, every note matches its slide content, visual descriptions match actual visuals

3. **Fix any issues** found during review

4. Present both files to the user:
   - `[topic]-slides.html` — the interactive slide deck
   - `[topic]-speaker-notes.md` — companion speaker notes

---

## Output Files

| File | Description |
|------|-------------|
| `[topic]-slides.html` | Self-contained interactive HTML slide deck with D3.js charts, Anime.js animations, and embedded paper figures |
| `[topic]-speaker-notes.md` | Markdown speaker notes with timing, talking points, and visual descriptions |
