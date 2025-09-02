#!/usr/bin/env bash

# Zellij theme switcher
# Usage: ./switch-theme.sh [theme_name]

CONFIG_FILE="$HOME/.config/zellij/config.kdl"
INDIE_CONFIG="$HOME/.indie-dawg-dots/common/zellij/config.kdl"

# List of available themes
declare -a THEMES=(
    "kanagawa_wave"
    "kanagawa_dragon"
    "kanagawa_lotus"
    "rose_pine_main"
    "rose_pine_moon"
    "rose_pine_dawn"
    "catppuccin_latte"
    "catppuccin_frappe"
    "catppuccin_macchiato"
    "catppuccin_mocha"
    "tokyonight_storm"
    "tokyonight_night"
    "tokyonight_moon"
    "tokyonight_day"
)

# Function to display available themes
show_themes() {
    echo "Available Zellij themes:"
    echo ""
    echo "Kanagawa:"
    echo "  - kanagawa_wave"
    echo "  - kanagawa_dragon"
    echo "  - kanagawa_lotus"
    echo ""
    echo "Rose Pine:"
    echo "  - rose_pine_main"
    echo "  - rose_pine_moon"
    echo "  - rose_pine_dawn"
    echo ""
    echo "Catppuccin:"
    echo "  - catppuccin_latte (light)"
    echo "  - catppuccin_frappe"
    echo "  - catppuccin_macchiato"
    echo "  - catppuccin_mocha"
    echo ""
    echo "Tokyo Night:"
    echo "  - tokyonight_storm"
    echo "  - tokyonight_night"
    echo "  - tokyonight_moon"
    echo "  - tokyonight_day (light)"
}

# Function to get current theme
get_current_theme() {
    grep '^theme ' "$CONFIG_FILE" | sed 's/theme "\(.*\)"/\1/'
}

# Function to switch theme
switch_theme() {
    local theme=$1
    
    # Check if theme exists
    if [[ ! " ${THEMES[@]} " =~ " ${theme} " ]]; then
        echo "Error: Theme '$theme' not found."
        echo ""
        show_themes
        return 1
    fi
    
    # Update both config files
    for config in "$CONFIG_FILE" "$INDIE_CONFIG"; do
        if [[ -f "$config" ]]; then
            sed -i "s/^theme \".*\"/theme \"$theme\"/" "$config"
        fi
    done
    
    echo "Switched to theme: $theme"
    echo "Note: Reload Zellij or start a new session to see the changes."
}

# Interactive theme selector using fzf if available
interactive_select() {
    if command -v fzf >/dev/null 2>&1; then
        local current_theme=$(get_current_theme)
        local selected=$(printf '%s\n' "${THEMES[@]}" | fzf \
            --prompt="Select Zellij theme (current: $current_theme): " \
            --height=15 \
            --layout=reverse \
            --border \
            --preview-window=hidden)
        
        if [[ -n "$selected" ]]; then
            switch_theme "$selected"
        fi
    else
        echo "Current theme: $(get_current_theme)"
        echo ""
        show_themes
        echo ""
        echo -n "Enter theme name: "
        read theme
        if [[ -n "$theme" ]]; then
            switch_theme "$theme"
        fi
    fi
}

# Main logic
if [[ $# -eq 0 ]]; then
    interactive_select
elif [[ "$1" == "list" || "$1" == "-l" || "$1" == "--list" ]]; then
    show_themes
elif [[ "$1" == "current" || "$1" == "-c" || "$1" == "--current" ]]; then
    echo "Current theme: $(get_current_theme)"
elif [[ "$1" == "help" || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Zellij Theme Switcher"
    echo ""
    echo "Usage:"
    echo "  $0              - Interactive theme selection"
    echo "  $0 <theme>      - Switch to specified theme"
    echo "  $0 list         - List available themes"
    echo "  $0 current      - Show current theme"
    echo "  $0 help         - Show this help message"
    echo ""
    show_themes
else
    switch_theme "$1"
fi