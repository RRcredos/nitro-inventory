---
name: linear
description: "Manage Linear tickets - create, update, comment, and follow workflow patterns"
---

# Codex Adaptation

This skill is the Codex-native version of the former Claude `linear` command. Follow the workflow below using Codex tools and repo conventions. When the original workflow asks for Claude-only tool behavior, use the translations in `AGENTS.md`.

# Linear - Ticket Management

You are tasked with managing Linear tickets, including creating tickets from documents under `nitro-inventory-knowledge-base/` in this repository (not a separate docs repo), updating existing tickets, and following the team's specific workflow patterns.

## Initial Setup

First, verify that Linear MCP tools are available by checking if any `mcp__linear__` tools exist. If not, respond:
```
I need access to Linear tools to help with ticket management. Please run the `/mcp` command to enable the Linear MCP server, then try again.
```

If tools are available, respond based on the user's request:

### For general requests:
```
I can help you with Linear tickets. What would you like to do?
1. Create a new ticket from a `nitro-inventory-knowledge-base/` document
2. Add a comment to a ticket (I'll use our conversation context)
3. Search for tickets
4. Update ticket status or details
```

### For specific create requests:
```
I'll help you create a Linear ticket from your `nitro-inventory-knowledge-base/` document. Please provide:
1. The path to the document under `nitro-inventory-knowledge-base/` (or topic to search for)
2. Any specific focus or angle for the ticket (optional)
```

Then wait for the user's input.

## Team Workflow & Status Progression

The team follows this workflow end to end:

1. **Backlog** → New or parked work; not actively being researched or built yet
2. **Research in Progress** → Active research or investigation
3. **Research in Review** → Research findings under review
4. **Plan in Progress** → Actively writing the implementation plan
5. **Plan in Review** → Plan is written and under discussion
6. **In Dev** → Active implementation
7. **Code Review** → PR in review
8. **Done** → Completed

**Key principle**: Review and alignment happen at the plan stage (not only at PR) to move faster and avoid rework.

## Important Conventions

### URL Mapping for `nitro-inventory-knowledge-base/` documents
Docs live under `nitro-inventory-knowledge-base/` in this checkout and are published from the knowledge-base repository. When referencing those files in Linear, always provide GitHub links using the `links` parameter.

Repository: [https://github.com/RRcredos/nitro-inventory-knowledge-base](https://github.com/RRcredos/nitro-inventory-knowledge-base). Build blob URLs from this repo:

- Pattern: `https://github.com/RRcredos/nitro-inventory-knowledge-base/blob/main/<file.md>` (use `main` unless the default branch differs)
- Example: `nitro-inventory-knowledge-base/specs.md` → `https://github.com/RRcredos/nitro-inventory-knowledge-base/blob/main/specs.md`

### Default Values
- **Status**: Always create new tickets in "Backlog" status
- **Project**: For new tickets, default to "Nitro Inventory" (ID: 	
0254dd23-47f2-4542-905f-a6cc6ec487fe) unless told otherwise
- **Priority**: Default to Medium (3) for most tasks, use best judgment or ask user
   - Urgent (1): Critical blockers, security issues
   - High (2): Important features with deadlines, major bugs
   - Medium (3): Standard implementation tasks (default)
   - Low (4): Nice-to-haves, minor improvements
- **Links**: Use the `links` parameter to attach URLs (not just markdown links in description)

### Automatic Label Assignment
Automatically apply labels based on the ticket content:
- **backend**: For tickets about `backend/`
- **mobile**: For tickets about `mobile/`,
- **web**: For tickets about `apps/web/`

Note: meta is mutually exclusive with backend/frontend. Tickets can have both backend and frontend, but not meta with either.

## Action-Specific Instructions

### 1. Creating Tickets from `nitro-inventory-knowledge-base/`

#### Steps to follow after receiving the request:

1. **Locate and read the document:**
   - If given a path, read the document directly
   - If given a topic/keyword, search the `nitro-inventory-knowledge-base/` directory using search to find relevant documents
   - If multiple matches found, show list and ask user to select
   - Create a Codex progress/checklist updates list to track: Read document → Analyze content → Draft ticket → Get user input → Create ticket

2. **Analyze the document content:**
   - Identify the core problem or feature being discussed
   - Extract key implementation details or technical decisions
   - Note any specific code files or areas mentioned
   - Look for action items or next steps
   - Identify what stage the idea is at (early ideation vs ready to implement)
   - Take time to ultrathink about distilling the essence of this document into a clear problem statement and solution approach

3. **Check for related context (if mentioned in doc):**
   - If the document references specific code files, read relevant sections
   - If it mentions other `nitro-inventory-knowledge-base/` documents, quickly check them
   - Look for any existing Linear tickets mentioned

4. **Get Linear workspace context:**
   - List teams: `mcp__linear__list_teams`
   - If multiple teams, ask user to select one
   - List projects for selected team: `mcp__linear__list_projects`

5. **Draft the ticket summary:**
   Present a draft to the user:
   ```
   ## Draft Linear Ticket

   **Title**: [Clear, action-oriented title]

   **Description**:
   [2-3 sentence summary of the problem/goal]

   ## Key Details
   - [Bullet points of important details from the source doc]
   - [Technical decisions or constraints]
   - [Any specific requirements]

   ## Implementation Notes (if applicable)
   [Any specific technical approach or steps outlined]

   ## References
   - Source: `nitro-inventory-knowledge-base/[path/to/document.md]` → `https://github.com/RRcredos/nitro-inventory-knowledge-base/blob/main/[path/to/document.md]`
   - Related code: [any file:line references]
   - Parent ticket: [if applicable]

   ---
   Based on the document, this seems to be at the stage of: [ideation/planning/ready to implement]
   ```

6. **Interactive refinement:**
   Ask the user:
   - Does this summary capture the ticket accurately?
   - Which project should this go in? [show list]
   - What priority? (Default: Medium/3)
   - Any additional context to add?
   - Should we include more/less implementation detail?
   - Do you want to assign it to yourself?

   Note: Ticket will be created in "Triage" status by default.

7. **Create the Linear ticket:**
   ```
   mcp__linear__create_issue with:
   - title: [refined title]
   - description: [final description in markdown]
   - teamId: [selected team]
   - projectId: [use default project from above unless user specifies]
   - priority: [selected priority number, default 3]
   - stateId: [Backlog status ID]
   - assigneeId: [if requested]
   - labelIds: [apply automatic label assignment from above]
   - links: [{url: "GitHub URL", title: "Document Title"}]
   ```

8. **Post-creation actions:**
   - Show the created ticket URL
   - Ask if user wants to:
   - Add a comment with additional implementation details
   - Create sub-tasks for specific action items
   - Update the original `nitro-inventory-knowledge-base/` document with the ticket reference
   - If yes to updating that doc:
     ```
     Add at the top of the document:
     ---
     linear_ticket: [URL]
     created: [date]
     ---
     ```

## Example transformations:

### From verbose `nitro-inventory-knowledge-base/` notes:
```
"I've been thinking about how our resumed sessions don't inherit permissions properly.
This is causing issues where users have to re-specify everything. We should probably
store all the config in the database and then pull it when resuming. Maybe we need
new columns for permission_prompt_tool and allowed_tools..."
```

### To concise ticket:
```
Title: Fix resumed sessions to inherit all configuration from parent

Description:

## Problem to solve
Currently, resumed sessions only inherit Model and WorkingDir from parent sessions,
causing all other configuration to be lost. Users must re-specify permissions and
settings when resuming.

## Solution
Store all session configuration in the database and automatically inherit it when
resuming sessions, with support for explicit overrides.
```

### 2. Adding Comments and Links to Existing Tickets

When user wants to add a comment to a ticket:

1. **Determine which ticket:**
   - Use context from the current conversation to identify the relevant ticket
   - If uncertain, use `mcp__linear__get_issue` to show ticket details and confirm with user
   - Look for ticket references in recent work discussed

2. **Format comments for clarity:**
   - Attempt to keep comments concise (~10 lines) unless more detail is needed
   - Focus on the key insight or most useful information for a human reader
   - Not just what was done, but what matters about it
   - Include relevant file references with backticks and GitHub links

3. **File reference formatting:**
   - Wrap paths in backticks: `nitro-inventory-knowledge-base/specs.md`
   - Add GitHub link after: `([View](url))`
   - Do this for both `nitro-inventory-knowledge-base/` and application code files mentioned

4. **Comment structure example:**
   ```markdown
   Implemented retry logic in webhook handler to address rate limit issues.

   Key insight: The 429 responses were clustered during batch operations,
   so exponential backoff alone wasn't sufficient - added request queuing.

   Files updated:
   - `hld/webhooks/handler.go` ([GitHub](link))
   - `nitro-inventory-knowledge-base/table.md` ([GitHub](link))
   ```

5. **Handle links properly:**
   - If adding a link with a comment: Update the issue with the link AND mention it in the comment
   - If only adding a link: Still create a comment noting what link was added for posterity
   - Always add links to the issue itself using the `links` parameter

6. **For comments with links:**
   ```
   # First, update the issue with the link
   mcp__linear__update_issue with:
   - id: [ticket ID]
   - links: [existing links + new link with proper title]

   # Then, create the comment mentioning the link
   mcp__linear__create_comment with:
   - issueId: [ticket ID]
   - body: [formatted comment with key insights and file references]
   ```

7. **For links only:**
   ```
   # Update the issue with the link
   mcp__linear__update_issue with:
   - id: [ticket ID]
   - links: [existing links + new link with proper title]

   # Add a brief comment for posterity
   mcp__linear__create_comment with:
   - issueId: [ticket ID]
   - body: "Added link: `path/to/document.md` ([View](url))"
   ```

### 3. Searching for Tickets

When user wants to find tickets:

1. **Gather search criteria:**
   - Query text
   - Team/Project filters
   - Status filters
   - Date ranges (createdAt, updatedAt)

2. **Execute search:**
   ```
   mcp__linear__list_issues with:
   - query: [search text]
   - teamId: [if specified]
   - projectId: [if specified]
   - stateId: [if filtering by status]
   - limit: 20
   ```

3. **Present results:**
   - Show ticket ID, title, status, assignee
   - Group by project if multiple projects
   - Include direct links to Linear

### 4. Updating Ticket Status

When moving tickets through the workflow:

1. **Get current status:**
   - Fetch ticket details
   - Show current status in workflow

2. **Suggest next status:**
   - Backlog → Research in Progress (starting research)
   - Research in Progress → Research in Review (research ready for review)
   - Research in Review → Plan in Progress (research accepted; start plan)
   - Plan in Progress → Plan in Review (plan drafted)
   - Plan in Review → In Dev (plan approved; implementation starts)
   - In Dev → Code Review (PR opened)
   - Code Review → Done (merged/shipped as defined by the team)

3. **Update with context:**
   ```
   mcp__linear__update_issue with:
   - id: [ticket ID]
   - stateId: [new status ID]
   ```

   Consider adding a comment explaining the status change.

## Important Notes

- Tag users in descriptions and comments using `@[name](ID)` format, e.g., `@[riche](dfe089d9-653f-4939-9fb4-bfb31e648268)`
- Keep tickets concise but complete - aim for scannable content
- All tickets should include a clear "problem to solve" - if the user asks for a ticket and only gives implementation details, you MUST ask "To write a good ticket, please explain the problem you're trying to solve from a user perspective"
- Focus on the "what" and "why", include "how" only if well-defined
- Always preserve links to source material using the `links` parameter
- Don't create tickets from early-stage brainstorming unless requested
- Use proper Linear markdown formatting
- Include code references as: `path/to/file.ext:linenum`
- Ask for clarification rather than guessing project/status
- Remember that Linear descriptions support full markdown including code blocks
- Always use the `links` parameter for external URLs (not just markdown links)
- remember - you must get a "Problem to solve"!

## Comment Quality Guidelines

When creating comments, focus on extracting the **most valuable information** for a human reader:

- **Key insights over summaries**: What's the "aha" moment or critical understanding?
- **Decisions and tradeoffs**: What approach was chosen and what it enables/prevents
- **Blockers resolved**: What was preventing progress and how it was addressed
- **State changes**: What's different now and what it means for next steps
- **Surprises or discoveries**: Unexpected findings that affect the work

Avoid:
- Mechanical lists of changes without context
- Restating what's obvious from code diffs
- Generic summaries that don't add value

Remember: The goal is to help a future reader (including yourself) quickly understand what matters about this update.

## Commonly Used IDs

### Projects
- No active Nitro Inventory project is currently returned by Linear MCP.

### Teams

#### Nitro Inventory
- **Team ID**: `0254dd23-47f2-4542-905f-a6cc6ec487fe`

### Label IDs
- **Bug**: `f47e2e51-7a5b-4fad-a58d-383273c89f22`
- **Backend**: `1fcafa9a-3f73-4f74-8c47-7184e9503f8a`
- **Web**: `58efc855-7180-467f-8232-dd76e7dbb231`
- **Mobile**: `71ba43a0-d4bb-460d-bb8a-9302c21efb14`
- **Feature**: `d2884572-aa67-4bac-9964-47916b9a41a1`
- **Improvement**: `6cc1fa81-b8e7-42d0-b414-bc2daba86887`

### Workflow State IDs — Nitro Inventory

Primary workflow (in order):

- **Backlog**: `88702012-306d-4124-8574-26e3349c1d40` (type: backlog)
- **Triage**: `f9bea8f5-d2aa-4ca0-bee1-2c944baf3d97` (type: triage)
- **Research In Progress**: `b1319988-1f90-4926-a128-87337537ecff` (type: started)
- **Research In Review**: `96f92bd1-bb5b-4732-b200-e5f03710a14a` (type: started)
- **Plan In Progress**: `2918547f-f118-47fb-a0b3-8baa3d174241` (type: started)
- **Plan In Review**: `603a4ec5-06f8-419e-b428-27f95089e740` (type: started)
- **In Dev**: `4e2634f1-c080-4b08-b3a8-f876c131b520` (type: started)
- **Code Review**: `d68e65a0-54fc-402a-93f5-25f4309255a3` (type: started)
- **Done**: `a86e7903-2594-49a1-a8e5-7db30c882058` (type: completed)

Other states:
- **Todo**: `8ba558a3-11fd-4eb2-bddd-02461fcf0069` (type: unstarted)
- **Duplicate**: `8a305ca9-5000-4364-b318-a82ad2684376` (type: duplicate)
- **Canceled**: `3a5b1978-aa39-4b6a-b3a1-8042c04abeac` (type: canceled)


## Linear User IDs

- riche (Richmond Baltazar): dfe089d9-653f-4939-9fb4-bfb31e648268
