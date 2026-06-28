#!/usr/bin/env bash
#
# create_worktree.sh — add a git worktree for nitro-inventory development.
#
# Default worktree location: /Users/riche/projects/nitro-inventory-wt/<name>
# Override base: export NITRO_INVENTORY_WORKTREE_BASE=/other/path
# Legacy overrides still supported: SCCV_AIMS_WORKTREE_BASE, BALAHIBOSS_WORKTREE_BASE (deprecated)
#
# Usage (ticket-style):
#   ./hack/create_worktree.sh CRE-123 my-feature-branch [base_branch]
# Usage (simple):
#   ./hack/create_worktree.sh [worktree_name] [base_branch]
#
# If worktree_name is omitted, a random name is generated and used as the branch name.
# If base_branch is omitted, uses the current branch.
#
# After `git worktree add`, copies optional local-only files from the main checkout
# (not symlinked) when each source exists — see LOCAL_OVERRIDE_FILES below.
#
# Run from anywhere inside the repository (root is resolved via git).

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
SOURCE_ROOT=$(git -C "$SCRIPT_DIR/.." rev-parse --show-toplevel 2>/dev/null || true)
if [[ -z "$SOURCE_ROOT" ]]; then
  echo "Error: not inside a git repository (expected nitro-inventory checkout)." >&2
  exit 1
fi

cd "$SOURCE_ROOT"

generate_unique_name() {
  local adjectives=("swift" "bright" "clever" "smooth" "quick" "clean" "sharp" "neat" "cool" "fast")
  local nouns=("fix" "task" "work" "dev" "patch" "branch" "code" "build" "test" "run")
  local adj=${adjectives[$RANDOM % ${#adjectives[@]}]}
  local noun=${nouns[$RANDOM % ${#nouns[@]}]}
  local timestamp
  timestamp=$(date +%H%M)
  echo "${adj}_${noun}_${timestamp}"
}

# Positional args: ticket workflow or legacy
POSITIONAL=("$@")
WORKTREE_NAME=""
BRANCH_NAME=""
BASE_BRANCH=""

if [[ ${#POSITIONAL[@]} -ge 2 && "${POSITIONAL[0]}" =~ ^[A-Z]+-[0-9]+$ ]]; then
  WORKTREE_NAME="${POSITIONAL[0]}"
  BRANCH_NAME="${POSITIONAL[1]}"
  BASE_BRANCH="${POSITIONAL[2]:-$(git branch --show-current)}"
else
  WORKTREE_NAME="${POSITIONAL[0]:-$(generate_unique_name)}"
  BRANCH_NAME="$WORKTREE_NAME"
  BASE_BRANCH="${POSITIONAL[1]:-$(git branch --show-current)}"
fi

DEFAULT_WT_BASE="/Users/riche/projects/nitro-inventory-wt"
WORKTREES_BASE="${NITRO_INVENTORY_WORKTREE_BASE:-${SCCV_AIMS_WORKTREE_BASE:-${BALAHIBOSS_WORKTREE_BASE:-$DEFAULT_WT_BASE}}}"
WORKTREE_PATH="${WORKTREES_BASE}/${WORKTREE_NAME}"

echo "Creating worktree: ${WORKTREE_NAME}"
echo "Location: ${WORKTREE_PATH}"
echo "From base branch: ${BASE_BRANCH}"
echo "Target branch: ${BRANCH_NAME}"

if [[ ! -d "$WORKTREES_BASE" ]]; then
  echo "Creating worktrees directory: $WORKTREES_BASE"
  mkdir -p "$WORKTREES_BASE"
fi

if [[ -d "$WORKTREE_PATH" ]]; then
  echo "Error: directory already exists: $WORKTREE_PATH" >&2
  exit 1
fi

CREATED_NEW_BRANCH=false
if git show-ref --verify --quiet "refs/heads/${BRANCH_NAME}"; then
  echo "Using existing branch: ${BRANCH_NAME}"
  git worktree add "$WORKTREE_PATH" "$BRANCH_NAME"
else
  echo "Creating new branch: ${BRANCH_NAME}"
  CREATED_NEW_BRANCH=true
  git worktree add -b "$BRANCH_NAME" "$WORKTREE_PATH" "$BASE_BRANCH"
fi

# Optional tooling directory (if you keep local Claude config in main checkout only)
if [[ -d "${SOURCE_ROOT}/.claude" ]]; then
  echo "Copying .claude/"
  cp -R "${SOURCE_ROOT}/.claude" "${WORKTREE_PATH}/"
fi

# Local overrides (often gitignored); copy only when present
LOCAL_OVERRIDE_FILES=(
  ".env"
  ".env.local"
  ".env.staging"
  ".env.production"
  "apps/web/.env"
  "apps/web/.env.local"
  "apps/web/.env.staging"
  "apps/web/.env.production"
)
for rel in "${LOCAL_OVERRIDE_FILES[@]}"; do
  src="${SOURCE_ROOT}/${rel}"
  if [[ -f "$src" ]]; then
    echo "Copying ${rel}"
    mkdir -p "$(dirname "${WORKTREE_PATH}/${rel}")"
    cp "$src" "${WORKTREE_PATH}/${rel}"
  fi
done

cd "$SOURCE_ROOT"

echo ""
echo "Worktree ready."
echo "  Path:   ${WORKTREE_PATH}"
echo "  Branch: ${BRANCH_NAME}"
echo ""
echo "Work there:"
echo "  cd ${WORKTREE_PATH}"
echo ""
echo "Remove later:"
echo "  ./hack/cleanup_worktree.sh --yes --delete-branch ${WORKTREE_NAME} ${BRANCH_NAME}"
echo "  # or: git worktree remove ${WORKTREE_PATH}"
