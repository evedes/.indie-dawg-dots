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
        "🎯 Action: Screenshot Region")
            hyprshot -m region -o "${SCREENSHOT_DIR}" -f "screenshot_$(date +%Y%m%d_%H%M%S).png"
            notify-send "Screenshot" "Region saved to ${SCREENSHOT_DIR}/"
            ;;
        "🎯 Action: Screenshot Window")
            hyprshot -m window -o "${SCREENSHOT_DIR}" -f "screenshot_$(date +%Y%m%d_%H%M%S).png"
            notify-send "Screenshot" "Window saved to ${SCREENSHOT_DIR}/"
            ;;
        "🎯 Action: Screenshot Fullscreen")
            hyprshot -m output -o "${SCREENSHOT_DIR}" -f "screenshot_$(date +%Y%m%d_%H%M%S).png"
            notify-send "Screenshot" "Fullscreen saved to ${SCREENSHOT_DIR}/"
            ;;
        "🎯 Action: Screenshot Region → Clipboard")
            hyprshot -m region --clipboard-only
            notify-send "Screenshot" "Region copied to clipboard"
            ;;
        "🎯 Action: Screenshot Window → Clipboard")
            hyprshot -m window --clipboard-only
            notify-send "Screenshot" "Window copied to clipboard"
            ;;

        # Power actions
        "🎯 Action: Lock Screen")
            hyprlock
            ;;
        "🎯 Action: Logout")
            if confirm_action "Logout"; then
                hyprctl dispatch exit
            fi
            ;;
        "🎯 Action: Suspend")
            systemctl suspend
            ;;
        "🎯 Action: Reboot")
            if confirm_action "Reboot"; then
                systemctl reboot
            fi
            ;;
        "🎯 Action: Shutdown")
            if confirm_action "Shutdown"; then
                systemctl poweroff
            fi
            ;;

        # System actions
        "🎯 Action: WiFi Settings")
            nm-connection-editor &
            ;;
        "🎯 Action: Bluetooth Settings")
            blueman-manager &
            ;;
        "🎯 Action: System Monitor")
            gnome-system-monitor &
            ;;

        # Tools
        "🎯 Action: Color Picker")
            hyprpicker | wl-copy
            notify-send "Color Picker" "Color copied to clipboard"
            ;;
        "🎯 Action: Clipboard History")
            cliphist list | rofi -dmenu -theme "${THEME_PATH}" -p "Clipboard" | cliphist decode | wl-copy
            ;;

        # Rofi modes
        "🎯 Action: Window Switcher")
            rofi -show window -theme "${THEME_PATH}"
            ;;
        "🎯 Action: File Browser")
            rofi -show filebrowser -theme "${THEME_PATH}"
            ;;
        "🎯 Action: Run Command")
            rofi -show run -theme "${THEME_PATH}"
            ;;

        # Quick Links - Add your favorite sites here
        "🎯 Action: Open GitHub")
            xdg-open "https://github.com" &
            ;;
        "🎯 Action: Open YouTube")
            xdg-open "https://youtube.com" &
            ;;
        "🎯 Action: Open ChatGPT")
            xdg-open "https://chat.openai.com" &
            ;;
        "🎯 Action: Open Gmail")
            xdg-open "https://gmail.com" &
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
        "🎯 Action: Screenshot Region" \
        "Take a screenshot of a selected region" \
        "applets-screenshooter" \
        "Utility;Screenshot;" \
        "screenshot;region;capture;" \
        "launcher-screenshot-region"

    create_desktop_entry \
        "🎯 Action: Screenshot Window" \
        "Take a screenshot of a window" \
        "applets-screenshooter" \
        "Utility;Screenshot;" \
        "screenshot;window;capture;" \
        "launcher-screenshot-window"

    create_desktop_entry \
        "🎯 Action: Screenshot Fullscreen" \
        "Take a fullscreen screenshot" \
        "applets-screenshooter" \
        "Utility;Screenshot;" \
        "screenshot;fullscreen;screen;capture;" \
        "launcher-screenshot-fullscreen"

    create_desktop_entry \
        "🎯 Action: Screenshot Region → Clipboard" \
        "Screenshot region to clipboard" \
        "edit-copy" \
        "Utility;Screenshot;" \
        "screenshot;clipboard;region;" \
        "launcher-screenshot-region-clip"

    create_desktop_entry \
        "🎯 Action: Screenshot Window → Clipboard" \
        "Screenshot window to clipboard" \
        "edit-copy" \
        "Utility;Screenshot;" \
        "screenshot;clipboard;window;" \
        "launcher-screenshot-window-clip"

    # Power entries
    create_desktop_entry \
        "🎯 Action: Lock Screen" \
        "Lock the screen" \
        "system-lock-screen" \
        "System;" \
        "lock;screen;security;" \
        "launcher-lock"

    create_desktop_entry \
        "🎯 Action: Logout" \
        "End the current session" \
        "system-log-out" \
        "System;" \
        "logout;exit;quit;" \
        "launcher-logout"

    create_desktop_entry \
        "🎯 Action: Suspend" \
        "Suspend the system" \
        "system-suspend" \
        "System;" \
        "suspend;sleep;" \
        "launcher-suspend"

    create_desktop_entry \
        "🎯 Action: Reboot" \
        "Restart the system" \
        "system-reboot" \
        "System;" \
        "reboot;restart;" \
        "launcher-reboot"

    create_desktop_entry \
        "🎯 Action: Shutdown" \
        "Power off the system" \
        "system-shutdown" \
        "System;" \
        "shutdown;poweroff;" \
        "launcher-shutdown"

    # System entries
    create_desktop_entry \
        "🎯 Action: WiFi Settings" \
        "Configure WiFi connections" \
        "network-wireless" \
        "Settings;Network;" \
        "wifi;network;wireless;internet;" \
        "launcher-wifi"

    create_desktop_entry \
        "🎯 Action: Bluetooth Settings" \
        "Manage Bluetooth devices" \
        "bluetooth" \
        "Settings;Hardware;" \
        "bluetooth;devices;" \
        "launcher-bluetooth"

    create_desktop_entry \
        "🎯 Action: System Monitor" \
        "System resource monitor" \
        "utilities-system-monitor" \
        "System;Monitor;" \
        "monitor;system;resources;cpu;memory;" \
        "launcher-monitor"

    # Tools entries
    create_desktop_entry \
        "🎯 Action: Color Picker" \
        "Pick colors from the screen" \
        "color-picker" \
        "Graphics;Utility;" \
        "color;picker;eyedropper;" \
        "launcher-colorpicker"

    create_desktop_entry \
        "🎯 Action: Clipboard History" \
        "View clipboard history" \
        "edit-paste" \
        "Utility;" \
        "clipboard;history;paste;" \
        "launcher-clipboard"

    # Rofi mode entries
    create_desktop_entry \
        "🎯 Action: Window Switcher" \
        "Switch between open windows" \
        "preferences-system-windows" \
        "System;" \
        "window;switch;alt-tab;" \
        "launcher-window-switcher"

    create_desktop_entry \
        "🎯 Action: File Browser" \
        "Browse files with Rofi" \
        "system-file-manager" \
        "System;FileTools;" \
        "files;browse;explorer;" \
        "launcher-filebrowser"

    create_desktop_entry \
        "🎯 Action: Run Command" \
        "Run a custom command" \
        "system-run" \
        "System;" \
        "run;command;execute;terminal;" \
        "launcher-run"

    # Quick Links entries
    create_desktop_entry \
        "🎯 Action: Open GitHub" \
        "Open GitHub in browser" \
        "github" \
        "Network;WebBrowser;" \
        "github;git;code;repository;" \
        "launcher-github"

    create_desktop_entry \
        "🎯 Action: Open YouTube" \
        "Open YouTube in browser" \
        "youtube" \
        "Network;WebBrowser;" \
        "youtube;video;streaming;" \
        "launcher-youtube"

    create_desktop_entry \
        "🎯 Action: Open ChatGPT" \
        "Open ChatGPT in browser" \
        "applications-internet" \
        "Network;WebBrowser;" \
        "chatgpt;ai;chat;gpt;" \
        "launcher-chatgpt"

    create_desktop_entry \
        "🎯 Action: Open Gmail" \
        "Open Gmail in browser" \
        "gmail" \
        "Network;Email;" \
        "gmail;email;mail;google;" \
        "launcher-gmail"
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

    # Launch Rofi - Apps only (simplified)
    export XDG_DATA_DIRS="${TEMP_DIR}:${XDG_DATA_DIRS:-/usr/share:/usr/local/share}"

    rofi \
        -modi "drun" \
        -show drun \
        -theme "${THEME_PATH}" \
        -matching fuzzy \
        -show-icons \
        -display-drun "Apps" \
        -drun-display-format "{name}" \
        -sort true \
        -lines 6 \
        -drun-use-desktop-cache false \
        -drun-reload-desktop-cache true
}

# ==============================================================================
# SCRIPT ENTRY POINT
# ==============================================================================

main "$@"