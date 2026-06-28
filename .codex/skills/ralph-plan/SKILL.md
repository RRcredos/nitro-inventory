---
name: ralph-plan
description: "Create implementation plan for highest priority Linear ticket ready for spec"
---

# Codex Adaptation

This skill is the Codex-native version of the former Claude `ralph_plan` command. Follow the workflow below using Codex tools and repo conventions. When the original workflow asks for Claude-only tool behavior, use the translations in `AGENTS.md`.

## PART 0 - ALWAYS RUN FIRST

0. sync the nitro-inventory-knowledge-base submodule from the parent repo: `./hack/sync_submodule_from_parent.sh`

## PART I - IF A TICKET IS MENTIONED

0c. use `linear` cli to fetch the selected item into nitro-inventory-knowledge-base with the ticket number - `./nitro-inventory-knowledge-base/shared/tickets/NIT-xxxx.md`
0d. read the ticket and all comments to learn about past implementations and research, and any questions or concerns about them


### PART I - IF NO TICKET IS MENTIONED

0. read .codex/skills/linear/SKILL.md
0a. fetch the top 10 priority items from Linear in status **Research in Review** using the MCP tools, noting all items in the `links` section (per `linear.md`: research accepted; planning is next)
0b. select the highest priority SMALL or XS issue from the list that is **not blocked by any unfinished issue** — check `blockedBy` relations and skip any issue where a blocker is not in a completed/done state (if no qualifying issues exist, EXIT IMMEDIATELY and inform the user)
0c. use `linear` cli to fetch the selected item into nitro-inventory-knowledge-base with the ticket number - `./nitro-inventory-knowledge-base/shared/tickets/NIT-xxxx.md`
0d. read the ticket and all comments to learn about past implementations and research, and any questions or concerns about them

### PART II - NEXT STEPS

think deeply

1. move the item to **Plan in Progress** using the MCP tools
1a. read ./.codex/skills/create-plan/SKILL.md
1b. determine if the item has a linked implementation plan document based on the `links` section (GitHub links under `https://github.com/RRcredos/nitro-inventory-knowledge-base`, per `linear.md`)
1d. if the plan exists, you're done, respond with a link to the ticket
1e. if the research is insufficient or has unaswered questions, create a new plan document following the instructions in ./.codex/skills/create-plan/SKILL.md

think deeply

2. when the plan is complete, run nitro-inventory-knowledge-base sync `./hack/sync_knowledge_base.sh` and attach the doc to the ticket using the MCP tools and create a terse comment with a link to it (re-read .codex/skills/linear/SKILL.md if needed)
2a. move the item to **Plan in Review** using the MCP tools

think deeply, use Codex progress/checklist updates to track your tasks. When fetching from linear, get the top 10 items by priority but only work on ONE item - specifically the highest priority SMALL or XS sized issue.

### PART III - When you're done


Print a message for the user (replace placeholders with actual values):

```
✅ Completed implementation plan for NIT-XXXX: [ticket title]

Approach: [selected approach description]

The plan has been:

Created at nitro-inventory-knowledge-base/shared/plans/YYYY-MM-DD-NIT-XXXX-description.md
Synced via ./hack/sync_knowledge_base.sh
Attached to the Linear ticket
Ticket moved to "Plan in Review" status

Implementation phases:
- Phase 1: [phase 1 description]
- Phase 2: [phase 2 description]
- Phase 3: [phase 3 description if applicable]

View the ticket: [Linear issue URL from MCP]
```
