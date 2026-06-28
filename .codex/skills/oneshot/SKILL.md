---
name: oneshot
description: "Research ticket and launch planning session"
---

# Codex Adaptation

This skill is the Codex-native version of the former Claude `oneshot` command. Follow the workflow below using Codex tools and repo conventions. When the original workflow asks for Claude-only tool behavior, use the translations in `AGENTS.md`.

1. Follow `.codex/skills/ralph-research/SKILL.md` for the given ticket number
2. Spawn a subagent to follow `.codex/skills/ralph-plan/SKILL.md` for the same ticket number. Wait for sub agent to complete.