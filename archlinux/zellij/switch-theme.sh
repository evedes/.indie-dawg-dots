#!/bin/bash

# Zellij Theme Selector with FZF (Cross-platform)

set -euo pipefail

# Configuration paths
ZELLIJ_CONFIG="$HOME/.config/zellij/config.kdl"
THEMES_KDL="$HOME/.indie-dawg-dots/archlinux/zellij/themes/themes.kdl"

# Check dependencies
if ! command -v zellij >/dev/null 2>&1; then
    echo "Error: zellij is not installed" >&2
    exit 1
fi

if ! command -v fzf >/dev/null 2>&1; then
    echo "Error: fzf is not installed" >&2
    exit 1
fi

if [[ ! -f "$THEMES_KDL" ]]; then
    echo "Error: themes.kdl not found at $THEMES_KDL" >&2
    exit 1
fi

if [[ ! -f "$ZELLIJ_CONFIG" ]]; then
    echo "Error: zellij config.kdl not found at $ZELLIJ_CONFIG" >&2
    exit 1
fi

# Extract theme names from themes.kdl
get_available_themes() {
    grep -E '^\s+[a-zA-Z_][a-zA-Z0-9_]*\s*\{' "$THEMES_KDL" | \
        awk '{print $1}' | \
        sort
}

# Get current theme from config.kdl
get_current_theme() {
    grep -E '^theme\s+' "$ZELLIJ_CONFIG" | \
        sed -E 's/^theme\s+"([^"]+)".*/\1/' || echo "default"
}

# Set theme in config.kdl
set_theme() {
    local new_theme="$1"
    
    if grep -q '^theme ' "$ZELLIJ_CONFIG"; then
        sed -i.bak "s/^theme .*/theme \"$new_theme\"/" "$ZELLIJ_CONFIG" && rm "$ZELLIJ_CONFIG.bak"
    else
        echo "theme \"$new_theme\"" >> "$ZELLIJ_CONFIG"
    fi
}

# Apply theme to running sessions
apply_theme_to_sessions() {
    local theme="$1"
    
    if zellij list-sessions >/dev/null 2>&1; then
        zellij list-sessions 2>/dev/null | grep -E '^\s*[^-]' | while read -r session_line; do
            session_name=$(echo "$session_line" | awk '{print $1}')
            if [[ -n "$session_name" ]]; then
                echo "  → Applying to session '$session_name'"
                zellij --session "$session_name" action change-theme "$theme" 2>/dev/null || true
            fi
        done
    fi
}

# Main function
main() {
    # Get current theme
    current_theme=$(get_current_theme)
    
    # Select theme using fzf
    selected_theme=$(get_available_themes | fzf \
        --prompt="Zellij Theme (current: $current_theme) > " \
        --height=15 \
        --layout=reverse \
        --border=rounded \
        --preview-window=hidden \
        --header="Select a Zellij theme" \
        --bind="ctrl-c:abort,esc:abort")
    
    # Exit if no selection
    if [[ -z "$selected_theme" ]]; then
        echo "No theme selected."
        exit 0
    fi
    
    # Skip if same theme
    if [[ "$selected_theme" == "$current_theme" ]]; then
        echo "Theme '$selected_theme' is already selected."
        exit 0
    fi
    
    # Apply theme
    echo "Setting theme to: $selected_theme"
    set_theme "$selected_theme"
    
    echo "Applying to running sessions..."
    apply_theme_to_sessions "$selected_theme"
    
    echo "✓ Theme changed to '$selected_theme'!"
}

main "$@"
