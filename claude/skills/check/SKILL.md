---
name: check
description: Run the project's full quality gate (types → lint → format), auto-detecting the stack. Fix errors at each step before proceeding.
allowed-tools: Bash, Read, Edit, Glob, Grep
---

# Quality gate

Run this repository's complete quality checks in order, fixing errors at each step before moving on. **Detect the stack first**, then prefer the project's own scripts over generic tool invocations.

## Detect the stack

Look for these markers in the repo (nearest first, then root) and pick the matching lane. In a monorepo, run per-package where scripts live.

- **Node / TS** — `package.json`: use the package manager from `packageManager`/lockfile (`pnpm` if `pnpm-lock.yaml`, else `yarn`/`npm`). Run the scripts that exist:
  1. `<pm> run typecheck` (or `type-check` / `tsc --noEmit`)
  2. `<pm> run lint` (add `--fix` for auto-fixable issues)
  3. `<pm> run format` (or `prettier --write .`)
- **Rust** — `Cargo.toml`:
  1. `cargo fmt --all -- --check` (run `cargo fmt --all` to fix)
  2. `cargo clippy --all-targets -- -D warnings`
  3. `cargo check --all-targets`
- **Python** — `pyproject.toml` / `requirements.txt`:
  1. `ruff check .` (or `flake8`) — `ruff check . --fix` to fix
  2. `ruff format .` (or `black .`)
  3. `mypy .` (only if mypy is configured)
- **Go** — `go.mod`: `gofmt -l .` → `go vet ./...` → `go build ./...`

If the project pins exact commands (its CLAUDE.md, a `Makefile`/`justfile` target like `check`/`lint`, or `settings.local.json`), **use those verbatim** instead of the generic guesses above.

## Rules

- Run in order: **types → lint → format**. Skip a lane only if the project genuinely has no such tool (e.g. no test/type setup) — say so.
- Fix errors at each step before proceeding. Use auto-fix where safe; fix the rest by hand.
- NEVER skip a failing step to make the gate "pass."
- Report a per-step summary at the end (✅/❌ for each lane) and state clearly whether the code is ready to commit.

## Outcome

All applicable checks green, code formatted, ready for `/commit`.
