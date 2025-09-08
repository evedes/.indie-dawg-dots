#!/bin/bash

# Zellij Theme Selector with Rofi
# This script reads themes from themes.kdl and allows selection via rofi

set -euo pipefail

# Configuration paths
ZELLIJ_CONFIG="$HOME/.config/zellij/config.kdl"
THEMES_KDL="$HOME/.indie-dawg-dots/common/zellij/themes/themes.kdl"

# Check dependencies
if ! command -v rofi >/dev/null 2>&1; then
    echo "Error: rofi is not installed" >&2
    exit 1
fi

if ! command -v zellij >/dev/null 2>&1; then
    echo "Error: zellij is not installed" >&2
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
    # Parse theme names from the KDL file
    # Look for lines like "    theme_name {"
    grep -E '^\s+[a-zA-Z_][a-zA-Z0-9_]*\s*\{' "$THEMES_KDL" | \
        sed -E 's/^\s+([a-zA-Z0-9_]+)\s*\{.*/\1/' | \
        sort
}

# Get current theme from config.kdl
get_current_theme() {
    # Look for line like 'theme "theme_name"'
    grep -E '^theme\s+' "$ZELLIJ_CONFIG" | \
        sed -E 's/^theme\s+"([^"]+)".*/\1/' || echo "default"
}

# Set theme in config.kdl
set_theme() {
    local new_theme="$1"
    
    # Check if theme line exists
    if grep -q '^theme\s' "$ZELLIJ_CONFIG"; then
        # Replace existing theme line
        sed -i "s/^theme\s.*/theme \"$new_theme\"/" "$ZELLIJ_CONFIG"
    else
        # Add theme line after plugins section or at the end
        if grep -q '^}$' "$ZELLIJ_CONFIG"; then
            # Add before the last closing brace (assuming it's from plugins)
            sed -i "/^}$/i\\theme \"$new_theme\"" "$ZELLIJ_CONFIG"
        else
            # Add at the end
            echo "theme \"$new_theme\"" >> "$ZELLIJ_CONFIG"
        fi
    fi
}

# Apply theme to running zellij sessions
apply_theme_to_sessions() {
    local theme="$1"
    
    # Check if there are any running zellij sessions
    if zellij list-sessions >/dev/null 2>&1; then
        # Get all session names and apply theme to each
        zellij list-sessions 2>/dev/null | grep -E '^\s*[^-]' | while read -r session_line; do
            # Extract session name (first word)
            session_name=$(echo "$session_line" | awk '{print $1}')
            if [[ -n "$session_name" ]]; then
                echo "Applying theme '$theme' to session '$session_name'..."
                # Use zellij action to change theme in running session
                zellij --session "$session_name" action change-theme "$theme" 2>/dev/null || true
            fi
        done
    else
        echo "No running zellij sessions found. Theme will apply to new sessions."
    fi
}

# Main function
main() {
    # Get available themes
    mapfile -t themes < <(get_available_themes)
    
    if [[ ${#themes[@]} -eq 0 ]]; then
        echo "Error: No themes found in $THEMES_KDL" >&2
        exit 1
    fi
    
    # Get current theme
    current_theme=$(get_current_theme)
    
    # Create rofi menu with current theme highlighted
    theme_list=""
    for theme in "${themes[@]}"; do
        if [[ "$theme" == "$current_theme" ]]; then
            theme_list+="● $theme (current)\n"
        else
            theme_list+="  $theme\n"
        fi
    done
    
    # Show rofi menu
    selected=$(echo -e "$theme_list" | rofi -dmenu -i -p "Select Zellij Theme" -theme-str 'window {width: 400px;}' -format s)
    
    # Check if user made a selection
    if [[ -z "$selected" ]]; then
        echo "No theme selected. Exiting."
        exit 0
    fi
    
    # Extract theme name from selection (remove prefix markers)
    new_theme=$(echo "$selected" | sed -E 's/^[● ]*([a-zA-Z0-9_]+).*$/\1/')
    
    # Validate theme exists
    if [[ ! " ${themes[*]} " =~ " ${new_theme} " ]]; then
        echo "Error: Invalid theme selected: $new_theme" >&2
        exit 1
    fi
    
    # Skip if same theme
    if [[ "$new_theme" == "$current_theme" ]]; then
        echo "Theme '$new_theme' is already selected."
        exit 0
    fi
    
    # Set new theme
    echo "Setting zellij theme to: $new_theme"
    set_theme "$new_theme"
    
    # Apply to running sessions
    apply_theme_to_sessions "$new_theme"
    
    echo "Theme changed to '$new_theme'. Restart zellij or create new sessions to see the change."
}

# Show help if requested
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    cat <<EOF
Zellij Theme Selector

Usage: $0 [OPTIONS]

This script allows you to select and switch Zellij themes using rofi.
It reads available themes from your themes.kdl file and updates your
zellij config.kdl accordingly.

OPTIONS:
  -h, --help    Show this help message

REQUIREMENTS:
  - rofi (for theme selection)
  - zellij (terminal workspace manager)
  - themes.kdl file at: $THEMES_KDL
  - zellij config at: $ZELLIJ_CONFIG

The script will show the current theme marked with ● in the rofi menu
and attempt to apply the theme to any running zellij sessions.
EOF
    exit 0
fi

main "$@"