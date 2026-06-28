---
name: worktree-create
description: "Create worktree and launch implementation session for a plan"
---

# Codex Adaptation

This skill is the Codex-native version of the former Claude `worktree_create` command. Follow the workflow below using Codex tools and repo conventions. When the original workflow asks for Claude-only tool behavior, use the translations in `AGENTS.md`.

2. set up worktree for implementation:
2a. read `hack/create_worktree.sh` and create a new worktree with the Linear branch name: `./hack/create_worktree.sh CRE-XXXX BRANCH_NAME`

3. determine required data:

branch name
path to plan file (use relative path only)
launch prompt
command to run

**IMPORTANT PATH USAGE:**
- The `nitro-inventory-knowledge-base/` directory is the nested docs checkout in this monorepo (see `./hack/sync_knowledge_base.sh`); treat paths consistently in main repo and worktrees.
- Always use ONLY the relative path starting with `nitro-inventory-knowledge-base/shared/...` without any directory prefix
- Example: `nitro-inventory-knowledge-base/shared/plans/fix-mcp-keepalive-proper.md` (not the full absolute path)
- This keeps plan references stable when opening the same paths from the worktree checkout

3a. confirm with the user by sending a message to the Human

```
based on the input, I plan to create a worktree with the following details:

worktree path: ~/projects/nitro-inventory-wt/CRE-XXXX
branch name: BRANCH_NAME
path to plan file: $FILEPATH
launch prompt:

    $implement-plan at $FILEPATH and when you are done implementing and all tests pass, read ./.codex/skills/commit/SKILL.md and create a commit, then read ./.codex/skills/describe-pr/SKILL.md and create a PR, then add a comment to the Linear ticket with the PR link

command to run:

    start a Codex subagent --workspace ~/projects/nitro-inventory-wt/CRE-XXXX "$implement-plan at $FILEPATH and when you are done implementing and all tests pass, read ./.codex/skills/commit/SKILL.md and create a commit, then read ./.codex/skills/describe-pr/SKILL.md and create a PR, then add a comment to the Linear ticket with the PR link"
```

incorporate any user feedback then:

4. launch implementation session: `start a Codex subagent --workspace ~/projects/nitro-inventory-wt/CRE-XXXX "<prompt from step 3a above>"`
