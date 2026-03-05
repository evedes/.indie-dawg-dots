#!/bin/bash
set -euo pipefail

DOTS="$(cd "$(dirname "$0")" && pwd)"
CONFIG="$HOME/.config"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[ok]${NC} $1"; }
warn() { echo -e "${YELLOW}[skip]${NC} $1"; }

# Create a symlink if it doesn't already point to the right target.
# If a real file/dir exists at the destination, back it up first.
link() {
    local src="$1"
    local dest="$2"

    if [ -L "$dest" ]; then
        local current
        current="$(readlink -f "$dest")"
        if [ "$current" = "$(readlink -f "$src")" ]; then
            warn "$dest (already linked)"
            return
        fi
        rm "$dest"
    elif [ -e "$dest" ]; then
        mv "$dest" "$dest.bak"
        warn "$dest existed, backed up to $dest.bak"
    fi

    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
    info "$dest -> $src"
}

echo "==> Linking config directories to ~/.config"
link "$DOTS/hypr"        "$CONFIG/hypr"
link "$DOTS/ghostty"     "$CONFIG/ghostty"
link "$DOTS/mako"        "$CONFIG/mako"
link "$DOTS/cava"        "$CONFIG/cava"
link "$DOTS/nvim"        "$CONFIG/nvim"
link "$DOTS/zellij"      "$CONFIG/zellij"
link "$DOTS/quickshell"  "$CONFIG/quickshell"
link "$DOTS/starship"    "$CONFIG/starship"
link "$DOTS/fontconfig"  "$CONFIG/fontconfig"
link "$DOTS/chromium"    "$CONFIG/chromium"

echo ""
echo "==> Linking dotfiles to ~"
link "$DOTS/zsh/.zshrc"    "$HOME/.zshrc"
link "$DOTS/zsh/.zshenv"   "$HOME/.zshenv"
link "$DOTS/zsh/.alias"    "$HOME/.alias"
link "$DOTS/tmux/.tmux.conf" "$HOME/.tmux.conf"
link "$DOTS/.gitconfig"    "$HOME/.gitconfig"
link "$DOTS/.ripgreprc"    "$HOME/.ripgreprc"
link "$DOTS/.vimrc"        "$HOME/.vimrc"

echo ""
echo "==> Installing fonts"
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
if [ -d "$DOTS/fonts" ]; then
    cp -n "$DOTS/fonts/"*.ttf "$FONT_DIR/" 2>/dev/null && {
        fc-cache -f "$FONT_DIR"
        info "Fonts installed to $FONT_DIR"
    } || warn "Fonts already installed"
fi

echo ""
echo "Done."
