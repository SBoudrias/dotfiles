#!/bin/bash

# Session Start Install Hook
# Triggered on SessionStart (startup only). Detects if the session is running
# inside a linked git worktree and runs the appropriate package manager.

# Detect linked worktree: git-dir differs from git-common-dir only in worktrees
GIT_DIR=$(git rev-parse --git-dir 2>/dev/null)
GIT_COMMON_DIR=$(git rev-parse --git-common-dir 2>/dev/null)

if [ -z "$GIT_DIR" ] || [ "$GIT_DIR" = "$GIT_COMMON_DIR" ]; then
  exit 0  # Not a linked worktree
fi

if [ -f "yarn.lock" ]; then
  echo "session-start-install: yarn.lock found, running yarn..." >&2
  yarn < /dev/null
fi

if [ -f "package-lock.json" ]; then
  echo "session-start-install: package-lock.json found, running npm install..." >&2
  npm install < /dev/null
fi
