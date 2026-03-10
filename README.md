# claude-tricks

A collection of skills for [Claude Code](https://claude.ai/claude-code).

## Skills

| Skill | Description |
|-------|-------------|
| [code-explainer](skills/code-explainer/SKILL.md) | Explains codebases visually with ASCII architecture diagrams, code flow tracing, and interactive deep-dives |
| [auto-research](skills/auto-research/SKILL.md) | Autonomous research loop — runs experiments on GPUs, keeps improvements, discards failures, and iterates until stopped |

## Install

### Option 1: Plugin (recommended)

1. Open Claude Code and run `/plugin`
2. Select **Add Marketplace**
3. Enter `christyjacob4/claude-tricks`
4. Install the `claude-tricks` plugin

This installs all skills and keeps them updated automatically.

### Option 2: Manual

Install all skills:

```bash
curl -sL https://raw.githubusercontent.com/christyjacob4/claude-tricks/main/install.sh | bash
```

Or install a specific skill:

```bash
curl -sL https://raw.githubusercontent.com/christyjacob4/claude-tricks/main/install.sh | bash -s code-explainer
```

Skills are installed to `~/.claude/skills/` and available globally across all projects. No restart needed.

## License

[MIT](LICENSE)
