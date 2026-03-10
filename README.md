# claude-tricks

A collection of skills for [Claude Code](https://claude.ai/claude-code).

## Skills

| Skill | Description |
|-------|-------------|
| [code-explainer](skills/code-explainer/SKILL.md) | Explains codebases visually with ASCII architecture diagrams, code flow tracing, and interactive deep-dives |

## Install

### Option 1: Plugin (recommended)

1. Open Claude Code and run `/plugin`
2. Select **Add Marketplace**
3. Enter `christyjacob4/claude-tricks`
4. Install the `claude-tricks` plugin

This installs all skills and keeps them updated automatically.

### Option 2: Manual (single skill)

To install just the `code-explainer` skill:

```bash
# Create the skill directory
mkdir -p ~/.claude/skills/code-explainer

# Download the skill
curl -sL \
  https://raw.githubusercontent.com/christyjacob4/claude-tricks/main/skills/code-explainer/SKILL.md \
  -o ~/.claude/skills/code-explainer/SKILL.md
```

Skills placed in `~/.claude/skills/` are available globally across all projects. No restart needed — Claude Code picks them up automatically.

## License

[MIT](LICENSE)
