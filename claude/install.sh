#!/usr/bin/env bash
#
# Install global Claude Code config from this dotfiles repo into ~/.claude.
#
# Symlinks only the user-authored config (CLAUDE.md, settings.json, skills/).
# It never touches machine-local state or secrets — credentials
# (~/.claude/.credentials.json) and ~/.claude.json are created locally when you
# run `claude` and authenticate, and must NOT be copied between machines.
#
# Idempotent: safe to re-run. Existing non-symlink files are backed up first.
#
# Usage:
#   git clone https://github.com/evedes/indie-dawg-dots.git ~/.indie-dawg-dots
#   ~/.indie-dawg-dots/claude/install.sh
#
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${CLAUDE_HOME:-$HOME/.claude}"

echo "→ Linking Claude config"
echo "  from: $SRC"
echo "  into: $DEST"
mkdir -p "$DEST"

link() {
  local name="$1"
  local src="$SRC/$name" dst="$DEST/$name"

  if [ ! -e "$src" ]; then
    echo "  ! skip $name (not present in repo)"
    return
  fi

  # Already the correct link → nothing to do.
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "  = $name (already linked)"
    return
  fi

  # A real file/dir is in the way → back it up so nothing is lost.
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    local backup="$dst.bak.$(date +%Y%m%d%H%M%S)"
    mv "$dst" "$backup"
    echo "  · backed up existing $name → $(basename "$backup")"
  fi

  ln -sfn "$src" "$dst"
  echo "  ✓ $name"
}

link CLAUDE.md
link settings.json
link skills

echo "✓ Claude config linked."

# ---- Post-install checks (warnings only, never fatal) ----
missing=0

if ! command -v claude >/dev/null 2>&1; then
  echo "⚠  'claude' not on PATH — install Claude Code first (native installer or: npm i -g @anthropic-ai/claude-code)."
  missing=1
fi

if [ ! -f "$DEST/.credentials.json" ]; then
  echo "⚠  No $DEST/.credentials.json — run 'claude' once and authenticate to create it."
  missing=1
fi

if [ ! -d "$HOME/Nextcloud/Multiverse" ]; then
  echo "⚠  ~/Nextcloud/Multiverse not found — the /new-note skill has nowhere to write until the vault is available on this machine."
  missing=1
fi

[ "$missing" -eq 0 ] && echo "✓ All prerequisites present — you're ready to go."

exit 0
