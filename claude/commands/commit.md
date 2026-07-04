---
description: Validate, then create a git commit (never push). Runs the quality gate, stages the specific changed files, and writes a conventional commit following the project's own convention.
allowed-tools: Bash, Read, Edit, Glob, Grep, SlashCommand
---

# Commit changes

Create a clean, validated git commit for the current work. **Never push** — committing is the whole job; pushing is a separate, explicitly-requested step.

## Workflow

1. **Validate**: run `/check` first. Fix everything before continuing. Do not commit over a red gate.
2. **Update docs if warranted**: if the change altered structure, commands, or documented behavior, run `/update-docs` (skip for trivial changes).
3. **Review the delta**:
   - `git status` and `git diff` (and `git diff --staged` if anything is already staged) to see exactly what changed.
   - `git log --oneline -5` to match the repo's existing commit style.
4. **Stage precisely**: `git add <specific files>` — the files this change actually touched. **Do not `git add -A`/`git add .`** unless every change belongs to this one logical commit.
5. **Commit** with a message that:
   - Follows the project's stated convention if its CLAUDE.md defines one (message shape, required footer, ticket reference, etc.).
   - Otherwise uses **Conventional Commits**: `type(scope): summary` (`feat`/`fix`/`refactor`/`docs`/`chore`/…), imperative mood, concise subject, a body only if it adds real context.
   - If the work maps to a ticket (Linear ID, a `TICKETS*.md` entry, etc.), reference it in the subject and mark it done in its tracker/file per that project's rule.
   - Write multi-line messages with a HEREDOC so formatting survives.

## Rules

- **NEVER push.** Stop after the commit and report it; pushing requires a separate explicit instruction.
- One logical change per commit — split unrelated work.
- Never commit with a failing quality gate or unresolved conflicts.
- Don't invent a footer/co-author line the project doesn't already use; follow the repo's convention.

## Outcome

Quality gate green, docs current if needed, changed files staged, one well-formed commit created and reported — not pushed.
