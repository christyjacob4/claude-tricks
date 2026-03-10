#!/bin/bash
set -e

REPO="christyjacob4/claude-tricks"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$REPO/$BRANCH"
SKILLS_DIR="$HOME/.claude/skills"

# Get list of available skills
SKILLS=(code-explainer)

install_skill() {
  local skill="$1"
  mkdir -p "$SKILLS_DIR/$skill"
  curl -sL "$BASE_URL/skills/$skill/SKILL.md" -o "$SKILLS_DIR/$skill/SKILL.md"
  echo "Installed: $skill"
}

if [ "$1" = "--all" ] || [ -z "$1" ]; then
  for skill in "${SKILLS[@]}"; do
    install_skill "$skill"
  done
  echo "Done. Installed ${#SKILLS[@]} skill(s) to $SKILLS_DIR"
else
  install_skill "$1"
fi
