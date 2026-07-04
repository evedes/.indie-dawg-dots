---
name: update-docs
description: Update this repository's CLAUDE.md (and README if it documents structure) to reflect recent code changes, after implementing a feature or fix. Diff-driven and surgical — only touches what actually changed. Works in any repo.
disable-model-invocation: true
allowed-tools: Read, Edit, Write, Grep, Glob, Bash, Agent
---

# Update docs

Update the documentation file(s) in the current repository so they accurately reflect recent changes. Surgical, not a rewrite.

## Steps

1. **See what changed**: run `git diff HEAD~1` (or the current staged/unstaged diff if there's no recent commit) to understand the actual delta.
2. **Find the docs**: read the nearest `CLAUDE.md`, the root `CLAUDE.md`, and `README.md` if one documents structure/commands. In a monorepo, check per-package CLAUDE.md files too.
3. **Compare doc vs. reality** and update only sections the diff invalidated:
   - Directory structure / file listings
   - Commands, scripts, and how to run/build/test
   - Architecture and data-flow descriptions
   - Feature descriptions, keybindings, config/env references
   - Version/dependency mentions (read the real manifest — `package.json`, `Cargo.toml`, `pyproject.toml`, etc.)
4. **Add a new section only if a wholly new feature was introduced.**
5. **Remove references to things that no longer exist.**
6. **Do NOT add a "Recent Updates" / changelog entry** — keep docs declarative and current-state, not chronological.

## Rules

- Only update what actually changed — don't rewrite the whole file.
- Match the existing style, structure, and altitude of each doc (a concise CLAUDE.md stays concise; a comprehensive README stays comprehensive).
- Be precise with file paths and references.
- Respect each project's own documentation philosophy if its CLAUDE.md states one (e.g. "CLAUDE.md ≤100 lines, detail lives in README").
- If nothing in the docs needs updating, say so and stop — don't manufacture edits.
