---
name: new-note
description: Use when the user wants to create, add, capture, or write down a new knowledge note — from ANY project or directory, not only inside the vault. Triggers on "add a note", "new note about X", "capture this", "I want to remember Y", "write a note on Z". The note always lands in the Multiverse vault at ~/Nextcloud/Multiverse with correct frontmatter, body skeleton, and a mandatory inbound link from a hub or MOC.
---

# New Multiverse note (global)

Create a note in the Multiverse vault at **`~/Nextcloud/Multiverse`** following the vault's own standards. This skill works from any working directory — knowledge notes always live in the vault, never in the current project repo (per the global CLAUDE.md routing rule).

A note is "done" only when it is **findable**: correct frontmatter plus at least one inbound link from a hub or MOC.

> Source of truth for conventions is `~/Nextcloud/Multiverse/multiverse-system.md`. If anything here conflicts with that note, follow the vault note and update this skill.

Links are **standard markdown**, never wikilinks. The vault is flat — every note lives at the repo root — so a link's relative path is just the target filename: `[Display Text](<target-filename>.md)`. Images use `![](assets/<file>)` with spaces URL-encoded as `%20`.

## Steps

1. **Slugify the title**: lowercase, kebab-case, no punctuation ("LTV and CAC" → `ltv-and-cac`).
2. **Check the slug is unique**: `ls ~/Nextcloud/Multiverse/<slug>.md`. A clash is a real collision — pick a more specific slug.
3. **Write the file at the vault root**: `~/Nextcloud/Multiverse/<slug>.md` (plain slug, no prefix, never in a subfolder). Legacy folders (`dailies/`, `templates/`) are not for new notes.
4. **Add frontmatter** (get the time with `TZ=Europe/Lisbon date +"%Y-%m-%d %H:%M"`):
   ```yaml
   ---
   id: <slug>
   created: <YYYY-MM-DD HH:MM>
   updated: <YYYY-MM-DD HH:MM>
   aliases:
     - <Human Title>
     - <lowercase variant if useful>
   tags:
     - <domain-tag>
   ---
   ```
   - `id` equals the slug. `created`/`updated` are Lisbon-time and equal for a new note. On any later edit, bump `updated` only.
   - `aliases` should include the human title. `tags` are kebab-case — reuse existing vocabulary (`ai`, `software-engineering`, `psychology`, `pkm`, `startups`, `infrastructure`, `well-being`, etc.); don't invent a tag for a one-off.
5. **Write the body**:
   - `# Human Title` as the H1, one framing sentence, then `##` sections if the idea has structure (a single paragraph is a valid stub).
   - Internal references are markdown links. End with a `## Related` line linking adjacent notes and the relevant MOC.
   - Do not expand a stub into an essay; do not invent content the user didn't provide.
6. **Link from a hub or MOC (mandatory).** Pick the best-fit MOC, open it, add `[<Human Title>](<slug>.md)` under the most appropriate `##` section. If two fit equally, ask — do not link from "everywhere just in case."
7. **Propose atomic-peer backlinks (bounded, ask-first).** `grep -lE "<key-terms>" ~/Nextcloud/Multiverse/*.md` on 2–3 distinctive terms. A candidate qualifies only if it **already discusses the same topic** (not just shares a tag). Surface **at most 3** with one-line justifications and ask which to link. If none clear the bar, skip entirely — zero earned backlinks beats decorative ones.
8. **Verify**: read back the MOC entry to confirm the note resolves from at least one canonical hub or MOC.

## Canonical hubs

- `main.md` — MAIN entry point · `projects.md` — active work · `resources.md` — domain MOCs · `archive.md` — inactive

## Domain MOCs (verify against the vault before use — they drift)

`ai.md`, `software-engineering.md`, `startups.md`, `writing-content-creation.md`, `psychology-wellbeing.md`, `infrastructure-systems.md`. If none fit, check operating notes (`everything-plan.md`, `get-things-done.md`, etc.) or resolve the real filename with `ls ~/Nextcloud/Multiverse/ | grep`.

## Common mistakes to avoid

- No subfolders — vault is flat. No `-MOC` filename suffix. Lowercase kebab-case filenames only.
- No wikilinks (`[[...]]`) — always `[text](file.md)`. No date/timestamp filename prefix (creation time lives in frontmatter).
- Never write the note into the current project repo — it always goes to `~/Nextcloud/Multiverse`.
