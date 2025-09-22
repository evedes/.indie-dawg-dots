#!/usr/bin/env bash

# Rofi Launcher - Unified launcher for applications and system actions
# Architecture: Modular action system with desktop entry integration
# Dependencies: rofi, hyprshot, hyprlock, hyprctl, cliphist, hyprpicker, wl-copy

set -euo pipefail

# ==============================================================================
# CONFIGURATION
# ==============================================================================

readonly SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly THEME_PATH="${HOME}/.config/rofi/hexarchy-theme.rasi"
readonly TEMP_DIR="/tmp/rofi-launcher-$$"
readonly SCREENSHOT_DIR="${HOME}/Pictures/Screenshots"

# Ensure required directories exist
mkdir -p "${SCREENSHOT_DIR}"

# Clean up temp directory on exit
trap 'rm -rf "${TEMP_DIR}"' EXIT INT TERM

# ==============================================================================
# ACTION HANDLERS
# ==============================================================================

# Main action dispatcher
handle_action() {
    local action="$1"

    case "$action" in
        # Screenshot actions
        "Screenshot: Region")
            hyprshot -m region -o "${SCREENSHOT_DIR}" -f "screenshot_$(date +%Y%m%d_%H%M%S).png"
            notify-send "Screenshot" "Region saved to ${SCREENSHOT_DIR}/"
            ;;
        "Screenshot: Window")
            hyprshot -m window -o "${SCREENSHOT_DIR}" -f "screenshot_$(date +%Y%m%d_%H%M%S).png"
            notify-send "Screenshot" "Window saved to ${SCREENSHOT_DIR}/"
            ;;
        "Screenshot: Fullscreen")
            hyprshot -m output -o "${SCREENSHOT_DIR}" -f "screenshot_$(date +%Y%m%d_%H%M%S).png"
            notify-send "Screenshot" "Fullscreen saved to ${SCREENSHOT_DIR}/"
            ;;
        "Screenshot: Region → Clipboard")
            hyprshot -m region --clipboard-only
            notify-send "Screenshot" "Region copied to clipboard"
            ;;
        "Screenshot: Window → Clipboard")
            hyprshot -m window --clipboard-only
            notify-send "Screenshot" "Window copied to clipboard"
            ;;

        # Power actions
        "Power: Lock Screen")
            hyprlock
            ;;
        "Power: Logout")
            if confirm_action "Logout"; then
                hyprctl dispatch exit
            fi
            ;;
        "Power: Suspend")
            systemctl suspend
            ;;
        "Power: Reboot")
            if confirm_action "Reboot"; then
                systemctl reboot
            fi
            ;;
        "Power: Shutdown")
            if confirm_action "Shutdown"; then
                systemctl poweroff
            fi
            ;;

        # System actions
        "System: WiFi Settings")
            nm-connection-editor &
            ;;
        "System: Bluetooth")
            blueman-manager &
            ;;
        "System: Monitor")
            gnome-system-monitor &
            ;;

        # Tools
        "Tools: Color Picker")
            hyprpicker | wl-copy
            notify-send "Color Picker" "Color copied to clipboard"
            ;;
        "Tools: Clipboard History")
            cliphist list | rofi -dmenu -theme "${THEME_PATH}" -p "Clipboard" | cliphist decode | wl-copy
            ;;

        # Rofi modes
        "Window Switcher")
            rofi -show window -theme "${THEME_PATH}"
            ;;
        "File Browser")
            rofi -show filebrowser -theme "${THEME_PATH}"
            ;;
        "Run Command")
            rofi -show run -theme "${THEME_PATH}"
            ;;
    esac
}

# ==============================================================================
# UTILITY FUNCTIONS
# ==============================================================================

# Show confirmation dialog for destructive actions
confirm_action() {
    local action="$1"
    local response

    response=$(echo -e "Yes\nNo" | rofi -dmenu -theme "${THEME_PATH}" -p "Confirm ${action}?")
    [[ "$response" == "Yes" ]]
}

# Create a desktop entry file for a custom action
create_desktop_entry() {
    local name="$1"
    local comment="$2"
    local icon="$3"
    local categories="$4"
    local keywords="$5"
    local filename="$6"

    cat > "${TEMP_DIR}/applications/${filename}.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=${name}
Comment=${comment}
Icon=${icon}
Exec=${BASH_SOURCE[0]} --execute-action "${name}"
Categories=${categories}
Keywords=${keywords}
EOF
}

# ==============================================================================
# DESKTOP ENTRY GENERATION
# ==============================================================================

# Initialize all custom action desktop entries
init_desktop_entries() {
    mkdir -p "${TEMP_DIR}/applications"

    # Screenshot entries
    create_desktop_entry \
        "Screenshot: Region" \
        "Take a screenshot of a selected region" \
        "applets-screenshooter" \
        "Utility;Screenshot;" \
        "screenshot;region;capture;" \
        "launcher-screenshot-region"

    create_desktop_entry \
        "Screenshot: Window" \
        "Take a screenshot of a window" \
        "applets-screenshooter" \
        "Utility;Screenshot;" \
        "screenshot;window;capture;" \
        "launcher-screenshot-window"

    create_desktop_entry \
        "Screenshot: Fullscreen" \
        "Take a fullscreen screenshot" \
        "applets-screenshooter" \
        "Utility;Screenshot;" \
        "screenshot;fullscreen;screen;capture;" \
        "launcher-screenshot-fullscreen"

    create_desktop_entry \
        "Screenshot: Region → Clipboard" \
        "Screenshot region to clipboard" \
        "edit-copy" \
        "Utility;Screenshot;" \
        "screenshot;clipboard;region;" \
        "launcher-screenshot-region-clip"

    create_desktop_entry \
        "Screenshot: Window → Clipboard" \
        "Screenshot window to clipboard" \
        "edit-copy" \
        "Utility;Screenshot;" \
        "screenshot;clipboard;window;" \
        "launcher-screenshot-window-clip"

    # Power entries
    create_desktop_entry \
        "Power: Lock Screen" \
        "Lock the screen" \
        "system-lock-screen" \
        "System;" \
        "lock;screen;security;" \
        "launcher-lock"

    create_desktop_entry \
        "Power: Logout" \
        "End the current session" \
        "system-log-out" \
        "System;" \
        "logout;exit;quit;" \
        "launcher-logout"

    create_desktop_entry \
        "Power: Suspend" \
        "Suspend the system" \
        "system-suspend" \
        "System;" \
        "suspend;sleep;" \
        "launcher-suspend"

    create_desktop_entry \
        "Power: Reboot" \
        "Restart the system" \
        "system-reboot" \
        "System;" \
        "reboot;restart;" \
        "launcher-reboot"

    create_desktop_entry \
        "Power: Shutdown" \
        "Power off the system" \
        "system-shutdown" \
        "System;" \
        "shutdown;poweroff;" \
        "launcher-shutdown"

    # System entries
    create_desktop_entry \
        "System: WiFi Settings" \
        "Configure WiFi connections" \
        "network-wireless" \
        "Settings;Network;" \
        "wifi;network;wireless;internet;" \
        "launcher-wifi"

    create_desktop_entry \
        "System: Bluetooth" \
        "Manage Bluetooth devices" \
        "bluetooth" \
        "Settings;Hardware;" \
        "bluetooth;devices;" \
        "launcher-bluetooth"

    create_desktop_entry \
        "System: Monitor" \
        "System resource monitor" \
        "utilities-system-monitor" \
        "System;Monitor;" \
        "monitor;system;resources;cpu;memory;" \
        "launcher-monitor"

    # Tools entries
    create_desktop_entry \
        "Tools: Color Picker" \
        "Pick colors from the screen" \
        "color-picker" \
        "Graphics;Utility;" \
        "color;picker;eyedropper;" \
        "launcher-colorpicker"

    create_desktop_entry \
        "Tools: Clipboard History" \
        "View clipboard history" \
        "edit-paste" \
        "Utility;" \
        "clipboard;history;paste;" \
        "launcher-clipboard"

    # Rofi mode entries
    create_desktop_entry \
        "Window Switcher" \
        "Switch between open windows" \
        "preferences-system-windows" \
        "System;" \
        "window;switch;alt-tab;" \
        "launcher-window-switcher"

    create_desktop_entry \
        "File Browser" \
        "Browse files with Rofi" \
        "system-file-manager" \
        "System;FileTools;" \
        "files;browse;explorer;" \
        "launcher-filebrowser"

    create_desktop_entry \
        "Run Command" \
        "Run a custom command" \
        "system-run" \
        "System;" \
        "run;command;execute;terminal;" \
        "launcher-run"
}

# ==============================================================================
# MAIN EXECUTION
# ==============================================================================

main() {
    # Handle action execution
    if [[ "${1:-}" == "--execute-action" ]]; then
        handle_action "$2"
        exit 0
    fi

    # Initialize desktop entries
    init_desktop_entries

    # Launch Rofi with custom actions merged with applications
    export XDG_DATA_DIRS="${TEMP_DIR}:${XDG_DATA_DIRS:-/usr/share:/usr/local/share}"

    rofi \
        -modi "drun" \
        -show drun \
        -theme "${THEME_PATH}" \
        -matching fuzzy \
        -show-icons \
        -drun-display-format "{name}" \
        -sort true \
        -drun-use-desktop-cache false \
        -drun-reload-desktop-cache true
}

# ==============================================================================
# SCRIPT ENTRY POINT
# ==============================================================================

main "$@"