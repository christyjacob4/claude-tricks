# claude-tricks

A collection of my favourite skills for [Claude Code](https://claude.ai/claude-code) — some written by me, some sourced from the web.

## Skills

| Skill | Description |
|-------|-------------|
| [code-explainer](skills/code-explainer/SKILL.md) | Explains codebases visually with ASCII architecture diagrams, code flow tracing, and interactive deep-dives |
| [auto-research](skills/auto-research/SKILL.md) | Autonomous research loop — runs experiments on GPUs, keeps improvements, discards failures, and iterates until stopped |
| [alphaxiv-paper-lookup](skills/alphaxiv-paper-lookup/SKILL.md) | Look up any arxiv paper on alphaxiv.org to get a structured AI-generated overview |
| [guided-learning](skills/guided-learning/SKILL.md) | Adaptive tutor that traces prerequisites, assesses your level, and teaches using Socratic/Bloom's/Visual styles — with code examples and a shareable HTML page |
| [frontend-design](skills/frontend-design/SKILL.md) | Create distinctive, production-grade frontend interfaces with high design quality that avoids generic AI aesthetics |
| [investigate](skills/investigate/SKILL.md) | Deep investigation of bugs, performance issues, or unexpected behavior with parallel evidence collection and root cause analysis |
| [debug](skills/debug/SKILL.md) | Systematically debug and fix failing tests, build errors, or runtime issues with aggressive parallelization |
| [opentui](skills/opentui/SKILL.md) | Comprehensive OpenTUI skill for building terminal user interfaces — covers core API, React reconciler, and Solid reconciler |
| [slide-deck](skills/slide-deck/SKILL.md) | Create stunning interactive HTML slide decks — researches papers (alphaxiv), extracts figures (pdf), builds D3.js charts and Anime.js animations with speaker notes |
| [pdf](skills/pdf/SKILL.md) | PDF processing — text/table extraction, figure extraction with bounding boxes, form filling, merging, creation, and OCR |

## Agents

| Agent | Description |
|-------|-------------|
| [100x-engineer](agents/100x-engineer.md) | Autonomous full-stack engineer — takes a requirement from idea to production-ready code with research, spikes, parallel execution, testing, security audit, and handoff report |

## Status Lines

| Status Line | Description |
|-------------|-------------|
| [default](statuslines/default/) | Two-line status bar — directory, git branch, model name (Claude orange), context window bar, and session cost |

### Install a status line

```bash
git clone https://github.com/christyjacob4/claude-tricks.git
cd claude-tricks/statuslines/default
./install.sh
```

Or one-liner (no clone needed):

```bash
curl -fsSL https://raw.githubusercontent.com/christyjacob4/claude-tricks/main/statuslines/default/statusline.sh -o ~/.claude/statusline.sh && chmod +x ~/.claude/statusline.sh
```

Then add to `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/statusline.sh"
  }
}
```

## Install Skills

### Option 1: Plugin (recommended)

1. Open Claude Code and run `/plugin`
2. Select **Add Marketplace**
3. Enter `christyjacob4/claude-tricks`
4. Install the `claude-tricks` plugin

This installs all skills and keeps them updated automatically.

### Option 2: npx

Install all skills globally:

```bash
npx skills add christyjacob4/claude-tricks -g -y
```

Or install a specific skill:

```bash
npx skills add christyjacob4/claude-tricks -g -y --skill code-explainer
```

Preview available skills without installing:

```bash
npx skills add christyjacob4/claude-tricks --list
```

Skills are installed to `~/.claude/skills/` and available globally across all projects. No restart needed.

## License

[MIT](LICENSE)
