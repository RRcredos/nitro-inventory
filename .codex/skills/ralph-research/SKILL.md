---
name: ralph-research
description: "Research highest priority Linear ticket needing investigation"
---

# Codex Adaptation

This skill is the Codex-native version of the former Claude `ralph_research` command. Follow the workflow below using Codex tools and repo conventions. When the original workflow asks for Claude-only tool behavior, use the translations in `AGENTS.md`.

## PART 0 - ALWAYS RUN FIRST

0. sync the nitro-inventory-knowledge-base submodule from the parent repo: `./hack/sync_submodule_from_parent.sh`

## PART I - IF A LINEAR TICKET IS MENTIONED

0c. use `linear` cli to fetch the selected item into nitro-inventory-knowledge-base with the ticket number - `./nitro-inventory-knowledge-base/shared/tickets/BAL-xxxx.md`
0d. read the ticket and all comments to understand what research is needed and any previous attempts

## PART I - IF NO TICKET IS MENTIONED

0. read .codex/skills/linear/SKILL.md
0a. fetch the top 10 priority items from Linear in status **Backlog** (or **Todo** if your team queues research there) using the MCP tools, noting all items in the `links` section — prefer tickets that clearly need investigation before planning
0b. select the highest priority SMALL or XS issue from the list that is **not blocked by any unfinished issue** — check `blockedBy` relations and skip any issue where a blocker is not in a completed/done state (if no qualifying issues exist, EXIT IMMEDIATELY and inform the user)
0c. use `linear` cli to fetch the selected item into nitro-inventory-knowledge-base with the ticket number - `./nitro-inventory-knowledge-base/shared/tickets/BAL-xxxx.md`
0d. read the ticket and all comments to understand what research is needed and any previous attempts

## PART II - NEXT STEPS

think deeply

1. move the item to **Research in Progress** using the MCP tools
1a. read any linked documents in the `links` section to understand context (including `nitro-inventory-knowledge-base/` docs in this repo, per `linear.md`)
1b. if insufficient information to conduct research, add a comment asking for clarification and move back to **Backlog**

think deeply about the research needs

2. conduct the research:
2a. read .codex/skills/research-codebase/SKILL.md for guidance on effective codebase research
2b. if the linear comments suggest web research is needed, use web search to research external solutions, APIs, or best practices
2c. search the codebase for relevant implementations and patterns
2d. examine existing similar features or related code
2e. identify technical constraints and opportunities
2f. Be unbiased - don't think too much about an ideal implementation plan, just document all related files and how the systems work today
2g. document findings in a new nitro-inventory-knowledge-base document: `nitro-inventory-knowledge-base/shared/research/YYYY-MM-DD-BAL-XXXX-description.md`
   - Format: `YYYY-MM-DD-BAL-XXXX-description.md` where:
   - YYYY-MM-DD is today's date
   - BAL-XXXX is the ticket number (omit if no ticket)
   - description is a brief kebab-case description of the research topic
   - Examples:
   - With ticket: `2026-01-08-BAL-1478-parent-child-tracking.md`
   - Without ticket: `2026-01-08-error-handling-patterns.md`

think deeply about the findings

3. synthesize research into actionable insights:
3a. summarize key findings and technical decisions
3b. identify potential implementation approaches
3c. note any risks or concerns discovered
3d. Run nitro-inventory-knowledge-base sync: `./hack/sync_knowledge_base.sh`

4. update the ticket:
4a. attach the research document to the ticket using the MCP tools with proper link formatting (GitHub URLs under `nitro-inventory-knowledge-base/`, per `linear.md`)
4b. add a comment summarizing the research outcomes
4c. move the item to **Research in Review** using the MCP tools
4d. assign the item to the current authenticated user using the MCP tools

think deeply, use Codex progress/checklist updates to track your tasks. When fetching from linear, get the top 10 items by priority but only work on ONE item - specifically the highest priority issue.

## PART III - When you're done

Print a message for the user (replace placeholders with actual values):

```
✅ Completed research for BAL-XXXX: [ticket title]

Research topic: [research topic description]

The research has been:

created at nitro-inventory-knowledge-base/shared/research/YYYY-MM-DD-BAL-XXXX-description.md
Synced via ./hack/sync_knowledge_base.sh
Attached to the Linear ticket
Ticket moved to "Research in Review" status

Key findings:
- [Major finding 1]
- [Major finding 2]
- [Major finding 3]

View the ticket: [Linear issue URL from MCP]
```
