#!/usr/bin/env bash
# Claude Code status line — inspired by Powerlevel10k p10k segments:
#   left:  dir, vcs
#   right: context, model, context-window usage

input=$(cat)

# --- data extraction ---
cwd=$(echo "$input"        | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input"      | jq -r '.model.display_name // ""')
used_pct=$(echo "$input"   | jq -r '.context_window.used_percentage // empty')
session=$(echo "$input"    | jq -r '.session_name // ""')

# --- dir: shorten home to ~ ---
short_dir="${cwd/#$HOME/\~}"

# --- vcs: git branch (skip lock to avoid hanging) ---
git_branch=""
if git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git_branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
               || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
fi

# --- context window bar ---
ctx_info=""
if [ -n "$used_pct" ]; then
  remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
  ctx_info=" | ctx ${remaining}% left"
fi

# --- session label ---
session_label=""
if [ -n "$session" ]; then
  session_label=" | ${session}"
fi

# --- assemble ---
left="${short_dir}"
if [ -n "$git_branch" ]; then
  left="${left}  ${git_branch}"
fi

right="${model}${ctx_info}${session_label}"

printf "%s | %s" "$left" "$right"
