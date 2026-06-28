---
name: ralph-impl
description: "Implement highest priority small Linear ticket with worktree setup"
---

# Codex Adaptation

This skill is the Codex-native version of the former Claude `ralph_impl` command. Follow the workflow below using Codex tools and repo conventions. When the original workflow asks for Claude-only tool behavior, use the translations in `AGENTS.md`.

## PART 0 - ALWAYS RUN FIRST

0. sync the nitro-inventory-knowledge-base submodule from the parent repo: `./hack/sync_submodule_from_parent.sh`

## PART I - IF A TICKET IS MENTIONED

0c. use `linear` cli to fetch the selected item into nitro-inventory-knowledge-base with the ticket number - `./nitro-inventory-knowledge-base/shared/tickets/BAL-xxxx.md`
0d. read the ticket and all comments to understand the implementation plan and any concerns

## PART I - IF NO TICKET IS MENTIOND

0. read .codex/skills/linear/SKILL.md
0a. fetch the top 10 priority items from Linear in status **Plan in Review** using the MCP tools, noting all items in the `links` section (per `linear.md`: plan approved; implementation is next after this state)
0b. select the highest priority SMALL or XS issue from the list that is **not blocked by any unfinished issue** — check `blockedBy` relations and skip any issue where a blocker is not in a completed/done state (if no qualifying issues exist, EXIT IMMEDIATELY and inform the user)
0c. use `linear` cli to fetch the selected item into nitro-inventory-knowledge-base with the ticket number - `./nitro-inventory-knowledge-base/shared/tickets/BAL-xxxx.md`
0d. read the ticket and all comments to understand the implementation plan and any concerns

## PART II - NEXT STEPS

think deeply

1. move the item to **In Dev** using the MCP tools (see state IDs in `.codex/skills/linear/SKILL.md`)
1a. identify the linked implementation plan document from the `links` section (paths under `nitro-inventory-knowledge-base/` in this monorepo, per `linear.md`)
1b. if no plan exists, move the ticket back to **Plan in Progress** and EXIT with an explanation

think deeply about the implementation

2. **MANDATORY WORKTREE EXECUTION (NO EXCEPTIONS)**:
   Use **`staging`** as the integration branch: create feature branches **from** `staging`, and open pull requests **into** `staging` (`gh pr create --base staging`).
2a. Read `hack/create_worktree.sh`, then create the worktree using the Linear ticket key, branch name, and base branch **`staging`** (third argument): `./hack/create_worktree.sh BAL-xxxx BRANCH_NAME staging`.
2b. Verify worktree creation succeeded before doing anything else (confirm directory exists at `~/projects/boss-pos-wt/BAL-xxxx` and git context is that worktree).
2c. **FAIL-FAST RULE:** if worktree setup or verification fails, STOP immediately, report the exact failure, and do not continue implementation.
2d. Start the implementation session **inside the worktree only**.
2e. Start the implementation Codex subagent in the worktree path: `~/projects/boss-pos-wt/BAL-xxxx` with command `$implement-plan`.
2f. Complete implementation and run relevant checks/tests; proceed only when tests pass (or clearly report why they cannot run).
2g. After successful implementation, read `./.codex/skills/commit/SKILL.md` and create a commit.
2h. Read `./.codex/skills/describe-pr/SKILL.md` (including `nitro-inventory-knowledge-base/shared/pr_description.md` per that command) for the PR description template and standards. Create the PR from the worktree branch with **`staging` as the base** — e.g. `gh pr create --base staging` with title/body following the template (draft first is fine if you will refine the body using `describe_pr` workflows).
2i. Comment on the Linear ticket with the PR link.
2j. **SAFETY RULE:** never implement on the main repo checkout; all code changes must occur in the worktree.
2k. Perform a final checklist validation that steps 2a-2j were completed in order; if any step was skipped, explicitly report it.

think deeply, use Codex progress/checklist updates to track your tasks. When fetching from linear, get the top 10 items by priority but only work on ONE item - specifically the highest priority SMALL or XS sized issue.
