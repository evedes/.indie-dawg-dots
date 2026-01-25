#!/usr/bin/env bash

# Rofi Power Menu - Custom actions for Hyprland
# Simple menu for system actions and utilities

set -euo pipefail

readonly THEME_PATH="${HOME}/.config/rofi/hexarchy-theme.rasi"
readonly SCREENSHOT_DIR="${HOME}/Pictures/Screenshots"

# Ensure screenshot directory exists
mkdir -p "${SCREENSHOT_DIR}"

# Menu options
declare -a options=(
    "Restart Hyprland"
    "Exit Hyprland"
    "Screenshot Region"
    "Screenshot Window"
    "Screenshot Fullscreen"
    "Color Picker"
    "Clipboard History"
    "Lock Screen"
    "Suspend"
    "Reboot"
    "Shutdown"
)

# Show menu and get selection
show_menu() {
    printf '%s\n' "${options[@]}" | rofi \
        -dmenu \
        -theme "${THEME_PATH}" \
        -p "Power Menu" \
        -matching fuzzy \
        -lines 6 \
        -i
}

# Handle the selected action
handle_selection() {
    case "$1" in
        "Restart Hyprland")
            hyprctl reload
            notify-send "Hyprland" "Configuration reloaded"
            ;;
        "Exit Hyprland")
            if confirm_action "Exit Hyprland"; then
                hyprctl dispatch exit
            fi
            ;;
        "Screenshot Region")
            hyprshot -m region -o "${SCREENSHOT_DIR}" -f "screenshot_$(date +%Y%m%d_%H%M%S).png"
            notify-send "Screenshot" "Region saved to ${SCREENSHOT_DIR}/"
            ;;
        "Screenshot Window")
            hyprshot -m window -o "${SCREENSHOT_DIR}" -f "screenshot_$(date +%Y%m%d_%H%M%S).png"
            notify-send "Screenshot" "Window saved to ${SCREENSHOT_DIR}/"
            ;;
        "Screenshot Fullscreen")
            hyprshot -m output -o "${SCREENSHOT_DIR}" -f "screenshot_$(date +%Y%m%d_%H%M%S).png"
            notify-send "Screenshot" "Fullscreen saved to ${SCREENSHOT_DIR}/"
            ;;
        "Color Picker")
            color=$(hyprpicker)
            echo -n "$color" | wl-copy
            notify-send "Color Picker" "Color $color copied to clipboard"
            ;;
        "Clipboard History")
            cliphist list | rofi -dmenu -theme "${THEME_PATH}" -p "Clipboard" | cliphist decode | wl-copy
            ;;
        "Lock Screen")
            hyprlock
            ;;
        "Suspend")
            systemctl suspend
            ;;
        "Reboot")
            if confirm_action "Reboot"; then
                systemctl reboot
            fi
            ;;
        "Shutdown")
            if confirm_action "Shutdown"; then
                systemctl poweroff
            fi
            ;;
    esac
}

# Confirmation dialog for destructive actions
confirm_action() {
    local action="$1"
    local response

    response=$(echo -e "Yes\nNo" | rofi -dmenu -theme "${THEME_PATH}" -p "Confirm ${action}?")
    [[ "$response" == "Yes" ]]
}

# Main execution
main() {
    local selection
    selection=$(show_menu)

    if [[ -n "${selection}" ]]; then
        handle_selection "${selection}"
    fi
}

main "$@"