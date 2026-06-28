#!/usr/bin/env bash
#
# cleanup_worktree.sh — remove a nitro-inventory git worktree under /Users/riche/projects/nitro-inventory-wt
#
# Usage: ./hack/cleanup_worktree.sh [--yes] [--delete-branch] [worktree_name] [branch_name]
#
# Options:
#   --yes           Skip the branch-deletion prompt (branch is kept unless --delete-branch)
#   --delete-branch Delete the branch after removing the worktree
#
# If worktree_name is omitted, lists worktrees whose paths are under the worktree base.
# If branch_name is omitted, defaults to worktree_name (same convention as create_worktree.sh).
#
# Override worktree directory: export NITRO_INVENTORY_WORKTREE_BASE=/other/path
# Legacy overrides still supported: SCCV_AIMS_WORKTREE_BASE, BALAHIBOSS_WORKTREE_BASE (deprecated)
#
# Run from anywhere (repository root is resolved from this script’s location).

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
SOURCE_ROOT=$(git -C "$SCRIPT_DIR/.." rev-parse --show-toplevel 2>/dev/null || true)
if [[ -z "$SOURCE_ROOT" ]]; then
  echo "Error: not inside a git repository (expected nitro-inventory checkout)." >&2
  exit 1
fi

DEFAULT_WT_BASE="/Users/riche/projects/nitro-inventory-wt"
WORKTREES_BASE="${NITRO_INVENTORY_WORKTREE_BASE:-${SCCV_AIMS_WORKTREE_BASE:-${BALAHIBOSS_WORKTREE_BASE:-$DEFAULT_WT_BASE}}}"

AUTO_CONFIRM=false
DELETE_BRANCH=false

cd "$SOURCE_ROOT"

list_worktrees() {
  echo "Worktrees under ${WORKTREES_BASE}:"
  local lines
  lines=$(git worktree list | grep -F "$WORKTREES_BASE" || true)
  if [[ -z "$lines" ]]; then
    echo "(none)"
    return 1
  fi
  printf '%s\n' "$lines"
}

cleanup_worktree() {
  local worktree_name="$1"
  local branch_name="$2"
  local worktree_path="${WORKTREES_BASE}/${worktree_name}"

  if ! git worktree list | grep -qF "$worktree_path"; then
    echo "Error: no worktree registered at: $worktree_path" >&2
    echo ""
    list_worktrees || true
    exit 1
  fi

  echo "Removing worktree: $worktree_path"

  if git worktree remove --force "$worktree_path"; then
    echo "Worktree removed."
  else
    echo "Error: git worktree remove failed." >&2
    echo "Try manually:"
    echo "  rm -rf $worktree_path"
    echo "  git worktree prune"
    exit 1
  fi

  echo ""
  if [[ "$DELETE_BRANCH" == true ]]; then
    if git branch -D "$branch_name" 2>/dev/null; then
      echo "Branch deleted: $branch_name"
    else
      echo "Note: branch not deleted (missing, not fully merged, or checked out elsewhere): $branch_name"
    fi
  elif [[ "$AUTO_CONFIRM" == true ]]; then
    echo "Branch kept: $branch_name (pass --delete-branch to remove it)"
  else
    read -r -p "Delete branch '$branch_name'? (y/N) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      if git branch -D "$branch_name" 2>/dev/null; then
        echo "Branch deleted: $branch_name"
      else
        echo "Note: branch not deleted: $branch_name"
      fi
    else
      echo "Branch kept: $branch_name"
    fi
  fi

  echo "Pruning worktree references..."
  git worktree prune

  echo ""
  echo "Cleanup complete."
}

ARGS=()
while [[ $# -gt 0 ]]; do
  case $1 in
  --yes)
    AUTO_CONFIRM=true
    shift
    ;;
  --delete-branch)
    DELETE_BRANCH=true
    shift
    ;;
  --help | -h)
    echo "Usage: $0 [--yes] [--delete-branch] [worktree_name] [branch_name]"
    echo ""
    echo "Options:"
    echo "  --yes           Skip branch-deletion prompt (keeps branch unless --delete-branch)"
    echo "  --delete-branch Remove the branch after removing the worktree"
    echo "  --help, -h      Show this help"
    echo ""
    echo "Worktrees live under: ${WORKTREES_BASE}/<name>"
    echo "Override with: NITRO_INVENTORY_WORKTREE_BASE=/path (or deprecated SCCV_AIMS_WORKTREE_BASE=/path or BALAHIBOSS_WORKTREE_BASE=/path)"
    echo ""
    echo "Examples:"
    echo "  $0                                    # List worktrees under the base path"
    echo "  $0 CRE-123                            # Remove worktree CRE-123 (branch prompt)"
    echo "  $0 --yes CRE-123                      # Remove worktree; keep branch"
    echo "  $0 --yes --delete-branch CRE-123      # Remove worktree and delete branch CRE-123"
    echo "  $0 CRE-123 my-feature                 # Remove worktree; branch name my-feature"
    exit 0
    ;;
  -*)
    echo "Unknown option: $1" >&2
    exit 1
    ;;
  *)
    ARGS+=("$1")
    shift
    ;;
  esac
done

if [[ ${#ARGS[@]} -eq 0 ]]; then
  list_worktrees || true
  echo ""
  echo "Usage: $0 [--yes] [--delete-branch] [worktree_name] [branch_name]"
  echo "Example: $0 --yes --delete-branch CRE-123 my-feature-branch"
  exit 0
fi

WORKTREE_NAME="${ARGS[0]}"
BRANCH_NAME="${ARGS[1]:-$WORKTREE_NAME}"
cleanup_worktree "$WORKTREE_NAME" "$BRANCH_NAME"
