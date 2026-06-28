#!/usr/bin/env bash
set -euo pipefail

# Emit environment metadata for specs, runbooks, and agent context.
# sccv-aims: Node.js project workspace.

DATETIME_TZ=$(date '+%Y-%m-%d %H:%M:%S %Z')
FILENAME_TS=$(date '+%Y-%m-%d_%H-%M-%S')
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  REPO_ROOT=$(git rev-parse --show-toplevel)
  REPO_NAME=$(basename "$REPO_ROOT")
  GIT_BRANCH=$(git branch --show-current 2>/dev/null || git rev-parse --abbrev-ref HEAD 2>/dev/null || true)
  if git rev-parse HEAD >/dev/null 2>&1; then
    GIT_COMMIT=$(git rev-parse HEAD)
  else
    GIT_COMMIT=""
  fi
else
  REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
  REPO_NAME=$(basename "$REPO_ROOT")
  GIT_BRANCH=""
  GIT_COMMIT=""
fi

PACKAGE_MANAGER=""
if [[ -f "$REPO_ROOT/pnpm-lock.yaml" ]]; then
  PACKAGE_MANAGER="pnpm"
elif [[ -f "$REPO_ROOT/yarn.lock" ]]; then
  PACKAGE_MANAGER="yarn"
elif [[ -f "$REPO_ROOT/bun.lockb" || -f "$REPO_ROOT/bun.lock" ]]; then
  PACKAGE_MANAGER="bun"
elif [[ -f "$REPO_ROOT/package-lock.json" ]]; then
  PACKAGE_MANAGER="npm"
fi

NODE_VERSION_LINE=""
NPM_VERSION_LINE=""
PNPM_VERSION_LINE=""
YARN_VERSION_LINE=""
BUN_VERSION_LINE=""

if command -v node >/dev/null 2>&1; then
  NODE_VERSION_LINE=$(node --version 2>/dev/null || true)
fi
if command -v npm >/dev/null 2>&1; then
  NPM_VERSION_LINE=$(npm --version 2>/dev/null || true)
fi
if command -v pnpm >/dev/null 2>&1; then
  PNPM_VERSION_LINE=$(pnpm --version 2>/dev/null || true)
fi
if command -v yarn >/dev/null 2>&1; then
  YARN_VERSION_LINE=$(yarn --version 2>/dev/null || true)
fi
if command -v bun >/dev/null 2>&1; then
  BUN_VERSION_LINE=$(bun --version 2>/dev/null || true)
fi

echo "Project: sccv-aims (repo: $REPO_NAME)"
echo "Current Date/Time (TZ): $DATETIME_TZ"
echo "Timestamp For Filename: $FILENAME_TS"
if [[ -n "$GIT_COMMIT" ]]; then
  echo "Current Git Commit Hash: $GIT_COMMIT"
fi
if [[ -n "$GIT_BRANCH" ]]; then
  echo "Current Branch Name: $GIT_BRANCH"
fi
echo "Repository Root: $REPO_ROOT"
if [[ -n "$PACKAGE_MANAGER" ]]; then
  echo "Detected package manager: $PACKAGE_MANAGER"
fi
if [[ -n "$NODE_VERSION_LINE" ]]; then
  echo "Node runtime (PATH): $NODE_VERSION_LINE"
fi
if [[ -n "$NPM_VERSION_LINE" ]]; then
  echo "npm (PATH): $NPM_VERSION_LINE"
fi
if [[ -n "$PNPM_VERSION_LINE" ]]; then
  echo "pnpm (PATH): $PNPM_VERSION_LINE"
fi
if [[ -n "$YARN_VERSION_LINE" ]]; then
  echo "yarn (PATH): $YARN_VERSION_LINE"
fi
if [[ -n "$BUN_VERSION_LINE" ]]; then
  echo "bun (PATH): $BUN_VERSION_LINE"
fi
