#!/bin/sh
# Install the claude-tricks status line for Claude Code
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST="$HOME/.claude/statusline.sh"
SETTINGS="$HOME/.claude/settings.json"

# Copy the status line script
cp "$SCRIPT_DIR/statusline.sh" "$DEST"
chmod +x "$DEST"
echo "Copied statusline.sh to $DEST"

# Update settings.json
if [ -f "$SETTINGS" ]; then
  if command -v jq > /dev/null 2>&1; then
    tmp=$(mktemp)
    jq '.statusLine = {"type": "command", "command": "bash ~/.claude/statusline.sh"}' "$SETTINGS" > "$tmp" && mv "$tmp" "$SETTINGS"
    echo "Updated $SETTINGS with statusLine config"
  else
    echo "jq not found — please add this to $SETTINGS manually:"
    echo '  "statusLine": { "type": "command", "command": "bash ~/.claude/statusline.sh" }'
  fi
else
  mkdir -p "$(dirname "$SETTINGS")"
  printf '{\n  "statusLine": {\n    "type": "command",\n    "command": "bash ~/.claude/statusline.sh"\n  }\n}\n' > "$SETTINGS"
  echo "Created $SETTINGS with statusLine config"
fi

echo "Done! Restart Claude Code to see the new status line."
