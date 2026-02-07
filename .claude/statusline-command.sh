#!/bin/bash

# Read JSON input
input=$(cat)

# Get current directory from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
dir_name=$(basename "$cwd")

# Start building output
output=""

# Check if we're in a git repository
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    # Get current branch name
    branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)

    # Check if repo is dirty (skip optional locks to avoid warnings)
    if git -C "$cwd" -c core.useBuiltinFSMonitor=false diff --quiet 2>/dev/null && \
       git -C "$cwd" -c core.useBuiltinFSMonitor=false diff --cached --quiet 2>/dev/null; then
        git_dirty=""
    else
        git_dirty=" ✗"
    fi

    git_branch="$branch"
    has_git=1
else
    has_git=0
fi

# Get context usage percentage
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used_pct" ]; then
    # Format to one decimal place
    used_pct=$(printf "%.1f" "$used_pct")

    # Determine color code based on usage threshold
    used_int=$(printf "%.0f" "$used_pct")
    if [ "$used_int" -lt 75 ]; then
        ctx_color="32"  # Green for < 75%
    elif [ "$used_int" -lt 95 ]; then
        ctx_color="33"  # Yellow for 75-95%
    else
        ctx_color="31"  # Red for > 95%
    fi
    has_ctx=1
else
    has_ctx=0
fi

# Build the output using printf with proper escape sequences
if [ "$has_git" -eq 1 ] && [ "$has_ctx" -eq 1 ]; then
    printf '\033[1;32m➜\033[0m  \033[36m%s\033[0m \033[1;34mgit:(\033[31m%s\033[1;34m)\033[0m%s \033[%sm%s\033[0m\n' "$dir_name" "$git_branch" "$git_dirty" "$ctx_color" "ctx:${used_pct}%"
elif [ "$has_git" -eq 1 ]; then
    printf '\033[1;32m➜\033[0m  \033[36m%s\033[0m \033[1;34mgit:(\033[31m%s\033[1;34m)\033[0m%s\n' "$dir_name" "$git_branch" "$git_dirty"
elif [ "$has_ctx" -eq 1 ]; then
    printf '\033[1;32m➜\033[0m  \033[36m%s\033[0m \033[%sm%s\033[0m\n' "$dir_name" "$ctx_color" "ctx:${used_pct}%"
else
    printf '\033[1;32m➜\033[0m  \033[36m%s\033[0m\n' "$dir_name"
fi
