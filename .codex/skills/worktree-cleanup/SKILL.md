---
name: worktree-cleanup
description: "Context-aware worktree cleanup for completed Linear tasks"
---

# Codex Adaptation

This skill is the Codex-native version of the former Claude `worktree_cleanup` command. Follow the workflow below using Codex tools and repo conventions. When the original workflow asks for Claude-only tool behavior, use the translations in `AGENTS.md`.

# Worktree Cleanup

Context-aware cleanup: focus on discussed ticket or check all worktrees.

## Discovery Logic

**If ticket discussed in context** (e.g., CRE-123):
- Only check that specific ticket's worktree in `~/projects/nitro-inventory-wt/`
- Skip if worktree directory doesn't exist

**If no ticket in context**:
- Scan `~/projects/nitro-inventory-wt/` directory for worktree folders
- Extract task IDs from directory names

## Process

1. **Discover**: Scan `~/projects/nitro-inventory-wt/` for worktree directories (context-aware)
2. **Check**: Query Linear MCP `get_issue`, verify status is **Done** (per `.codex/skills/linear/SKILL.md`)
3. **Cleanup**: Run `./hack/cleanup_worktree.sh --yes --delete-branch <TASK_ID>` for completed tasks
4. **Verify**: Run `git fetch origin --prune` to clean remote references

## Usage

> "Run the worktree cleanup command"

## Safety

- Only cleans tasks marked **Done** in Linear
- Uses existing proven cleanup script
- Handles already-deleted branches gracefully
