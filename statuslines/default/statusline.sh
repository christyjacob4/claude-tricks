#!/bin/sh
# Claude Code status line script
# Shows: directory | git branch | model | context bar | cost

input=$(cat)

# --- ANSI color codes ---
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
CYAN="\033[36m"
GREEN="\033[32m"
MAGENTA="\033[35m"
YELLOW="\033[33m"
RED="\033[31m"
WHITE="\033[37m"
CLAUDE_ORANGE="\033[38;2;231;130;56m"
SEP="${DIM}|${RESET}"

# --- Working directory (strip home prefix, keep last 4 segments) ---
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // ""')
home="$HOME"
case "$cwd" in
  "$home"/*)
    short_dir="${cwd#$home/}"
    ;;
  "$home")
    short_dir="~"
    ;;
  *)
    short_dir="$cwd"
    ;;
esac
# Trim to last 4 path segments
seg_count=$(echo "$short_dir" | tr '/' '\n' | wc -l | tr -d ' ')
if [ "$seg_count" -gt 4 ]; then
  short_dir=$(echo "$short_dir" | rev | cut -d'/' -f1-4 | rev)
fi

# --- Git info ---
git_branch=""
worktree_flag=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null \
               || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)

  repo_root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)
  if [ -n "$repo_root" ] && [ -f "$repo_root/.git" ]; then
    worktree_flag="[worktree]"
  fi
fi

# --- Context window usage + block bar ---
BAR_WIDTH=20
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
ctx_used=$(echo "$input" | jq -r '
  if .context_window.current_usage != null then
    ((.context_window.current_usage.input_tokens // 0)
     + (.context_window.current_usage.cache_creation_input_tokens // 0)
     + (.context_window.current_usage.cache_read_input_tokens // 0))
  else
    0
  end')

if [ -n "$used_pct" ]; then
  used_pct_int=$(printf "%.0f" "$used_pct")
  filled=$(( used_pct_int * BAR_WIDTH / 100 ))

  # Format token counts compactly
  token_label=$(awk -v u="$ctx_used" -v t="$ctx_size" 'BEGIN {
    if (t >= 1000000)      { tf = sprintf("%.1fM", t/1000000) }
    else if (t >= 1000)    { tf = sprintf("%dk",   int(t/1000)) }
    else                   { tf = t }
    if (u >= 1000000)      { uf = sprintf("%.1fM", u/1000000) }
    else if (u >= 1000)    { uf = sprintf("%.1fk", u/1000) }
    else                   { uf = u }
    printf "%s/%s", uf, tf
  }')

  # Pick bar color based on usage
  if [ "$used_pct_int" -ge 80 ]; then
    bar_color="$RED"
  elif [ "$used_pct_int" -ge 50 ]; then
    bar_color="$YELLOW"
  else
    bar_color="$GREEN"
  fi

  # Build block bar
  bar=""
  i=1
  while [ $i -le $BAR_WIDTH ]; do
    if [ $i -le $filled ]; then
      bar="${bar}${bar_color}▌${RESET}"
    else
      bar="${bar}${DIM}▌${RESET}"
    fi
    i=$(( i + 1 ))
  done
  bar="${bar} ${token_label}"
else
  bar="${DIM}▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌▌${RESET} --/--"
fi

# --- Model name ---
model=$(echo "$input" | jq -r '.model.display_name // .model.id // "unknown"')

# --- Session cost ---
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
cost_fmt=$(awk -v c="$cost" 'BEGIN { printf "%.2f", c }')
cost_str="${YELLOW}\$${cost_fmt}${RESET}"

# --- Assemble line 1: directory and git info ---
if [ -n "$worktree_flag" ]; then
  line1="${BOLD}${MAGENTA}(worktree)${RESET} ${CYAN}${short_dir}${RESET}"
else
  line1="${CYAN}${short_dir}${RESET}"
fi

if [ -n "$git_branch" ]; then
  line1="${line1} ${SEP} ${GREEN}${git_branch}${RESET}"
fi

# --- Assemble line 2: model, context bar, cost ---
line2="${BOLD}${CLAUDE_ORANGE}${model}${RESET} ${SEP} ${bar} ${SEP} ${cost_str}"

printf '%b\n%b\n' "$line1" "$line2"
