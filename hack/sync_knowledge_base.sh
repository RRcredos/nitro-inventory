#!/usr/bin/env bash
set -euo pipefail

# Sync the nitro-inventory-knowledge-base directory inside this repository.
# Legacy env KNOWLEDGE_BASE_* and MEMORY_BANK_* still work if NITRO_INVENTORY_KNOWLEDGE_BASE_* is unset.

SYNC_COMMIT_MESSAGE="chore: nitro-inventory-knowledge-base sync"
NITRO_INVENTORY_KNOWLEDGE_BASE_PATH="${NITRO_INVENTORY_KNOWLEDGE_BASE_PATH:-${KNOWLEDGE_BASE_PATH:-${MEMORY_BANK_PATH:-nitro-inventory-knowledge-base}}}"
NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_NAME="${NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_NAME:-${KNOWLEDGE_BASE_REMOTE_NAME:-${MEMORY_BANK_REMOTE_NAME:-origin}}}"
NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_BRANCH="${NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_BRANCH:-${KNOWLEDGE_BASE_REMOTE_BRANCH:-${MEMORY_BANK_REMOTE_BRANCH:-staging}}}"

usage() {
  cat <<EOF
Usage:
  ./hack/sync_knowledge_base.sh [sync]
  ./hack/sync_knowledge_base.sh publish
  ./hack/sync_knowledge_base.sh refresh

Commands:
  sync     Pull latest ${NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_BRANCH} in this repo, commit local
           nitro-inventory-knowledge-base changes (if any), then push. Default command.
  publish  Push current repository HEAD to remote without creating a new commit.
  refresh  Pull latest ${NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_BRANCH} (fails if there are local changes
           under nitro-inventory-knowledge-base).

Environment overrides (KNOWLEDGE_BASE_* and MEMORY_BANK_* accepted as legacy aliases):
  NITRO_INVENTORY_KNOWLEDGE_BASE_PATH          Default: nitro-inventory-knowledge-base
  NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_NAME   Default: origin
  NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_BRANCH Default: staging
EOF
}

assert_git_worktree() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "[nitro-inventory-knowledge-base-sync] Error: must be run from inside a git worktree." >&2
    exit 1
  fi
}

assert_knowledge_base_path() {
  if [[ ! -d "${NITRO_INVENTORY_KNOWLEDGE_BASE_PATH}" ]]; then
    echo "[nitro-inventory-knowledge-base-sync] Error: '${NITRO_INVENTORY_KNOWLEDGE_BASE_PATH}' directory does not exist." >&2
    exit 1
  fi
}

has_knowledge_base_changes() {
  if ! git diff --quiet -- "${NITRO_INVENTORY_KNOWLEDGE_BASE_PATH}"; then
    return 0
  fi
  if ! git diff --cached --quiet -- "${NITRO_INVENTORY_KNOWLEDGE_BASE_PATH}"; then
    return 0
  fi
  if [[ -n "$(git ls-files --others --exclude-standard -- "${NITRO_INVENTORY_KNOWLEDGE_BASE_PATH}")" ]]; then
    return 0
  fi
  return 1
}

run_sync() {
  assert_git_worktree
  local repo_root
  repo_root="$(git rev-parse --show-toplevel)"
  cd "${repo_root}"
  assert_knowledge_base_path

  echo "[nitro-inventory-knowledge-base-sync] Pulling ${NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_NAME}/${NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_BRANCH} in repo root..."
  git fetch "${NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_NAME}" "${NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_BRANCH}"
  git checkout "${NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_BRANCH}"
  git pull --rebase --autostash "${NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_NAME}" "${NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_BRANCH}"

  if has_knowledge_base_changes; then
    echo "[nitro-inventory-knowledge-base-sync] Staging nitro-inventory-knowledge-base changes..."
    git add -A -- "${NITRO_INVENTORY_KNOWLEDGE_BASE_PATH}"
    if ! git diff --cached --quiet -- "${NITRO_INVENTORY_KNOWLEDGE_BASE_PATH}"; then
      git commit -m "${SYNC_COMMIT_MESSAGE}"
      echo "[nitro-inventory-knowledge-base-sync] Created nitro-inventory-knowledge-base commit."
    else
      echo "[nitro-inventory-knowledge-base-sync] No staged changes after add."
    fi
  else
    echo "[nitro-inventory-knowledge-base-sync] No local changes in nitro-inventory-knowledge-base."
  fi

  echo "[nitro-inventory-knowledge-base-sync] Pushing HEAD to ${NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_NAME}/${NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_BRANCH}..."
  git push "${NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_NAME}" "HEAD:${NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_BRANCH}"
  echo "[nitro-inventory-knowledge-base-sync] Sync completed."
}

run_publish() {
  assert_git_worktree
  local repo_root
  repo_root="$(git rev-parse --show-toplevel)"
  cd "${repo_root}"
  assert_knowledge_base_path

  echo "[nitro-inventory-knowledge-base-sync] Publishing HEAD to ${NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_NAME}/${NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_BRANCH}..."
  git push "${NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_NAME}" "HEAD:${NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_BRANCH}"
  echo "[nitro-inventory-knowledge-base-sync] Publish completed."
}

run_refresh() {
  assert_git_worktree
  local repo_root
  repo_root="$(git rev-parse --show-toplevel)"
  cd "${repo_root}"
  assert_knowledge_base_path

  if has_knowledge_base_changes; then
    echo "[nitro-inventory-knowledge-base-sync] Error: local changes in '${NITRO_INVENTORY_KNOWLEDGE_BASE_PATH}'. Commit or stash before refresh." >&2
    exit 1
  fi

  echo "[nitro-inventory-knowledge-base-sync] Refreshing from ${NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_NAME}/${NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_BRANCH}..."
  git fetch "${NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_NAME}" "${NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_BRANCH}"
  git checkout "${NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_BRANCH}"
  git pull --ff-only "${NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_NAME}" "${NITRO_INVENTORY_KNOWLEDGE_BASE_REMOTE_BRANCH}"
  echo "[nitro-inventory-knowledge-base-sync] Refresh completed."
}

main() {
  local command="${1:-sync}"
  case "${command}" in
  sync)
    run_sync
    ;;
  publish)
    run_publish
    ;;
  refresh)
    run_refresh
    ;;
  -h | --help | help)
    usage
    ;;
  *)
    echo "[nitro-inventory-knowledge-base-sync] Error: unknown command '${command}'." >&2
    usage >&2
    exit 1
    ;;
  esac
}

main "$@"
