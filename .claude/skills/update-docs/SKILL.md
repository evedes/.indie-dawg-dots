---
name: update-docs
description: Update CLAUDE.md files to reflect recent changes after implementing a feature
disable-model-invocation: true
allowed-tools: Read, Edit, Write, Grep, Glob, Bash, Agent
---

Update the CLAUDE.md file(s) in this repository to accurately reflect recent changes.

## Steps

1. Run `git diff HEAD~1` (or the current unstaged/staged diff if no recent commit) to understand what changed
2. Read the relevant CLAUDE.md file(s) — check both the nearest CLAUDE.md and the root CLAUDE.md
3. Compare the documentation against the actual current state of the code
4. Update any sections that are now outdated or inaccurate:
   - Directory structure / file listings
   - Plugin lists and counts
   - Keybindings
   - Architecture descriptions
   - Feature descriptions
   - Command references
5. Add new sections only if a wholly new feature was introduced
6. Remove references to things that no longer exist
7. Do NOT add a "Recent Updates" changelog entry — keep docs declarative, not chronological

## Rules

- Only update what actually changed — don't rewrite the entire file
- Keep the existing style and structure of the CLAUDE.md
- Be precise with file paths and line number references
- If nothing in CLAUDE.md needs updating, say so and stop
