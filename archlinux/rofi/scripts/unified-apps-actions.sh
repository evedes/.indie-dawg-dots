#!/usr/bin/env bash

# Create a custom modi script for actions
cat << 'EOF' > /tmp/rofi-actions-modi.sh
#!/usr/bin/env bash

if [ "$1" = "" ]; then
    # List all actions with icons
    echo "󰹑 Screenshot: Region"
    echo "󰍹 Screenshot: Window"
    echo "󰍺 Screenshot: Fullscreen"
    echo "󰨇 Screenshot: Region → Clipboard"
    echo "󰨇 Screenshot: Window → Clipboard"
    echo "󰌾 Power: Lock Screen"
    echo "󰍃 Power: Logout"
    echo "󰒲 Power: Suspend"
    echo "󰜉 Power: Reboot"
    echo "󰐥 Power: Shutdown"
    echo "󰖟 System: WiFi Settings"
    echo "󱎴 System: Bluetooth"
    echo "󰏘 System: Monitor"
    echo "󰢻 Tools: Color Picker"
    echo "󰅍 Tools: Clipboard History"
    echo "󱡶 Rofi: Window Switcher"
    echo "󰉋 Rofi: File Browser"
    echo "󰍉 Rofi: Run Command"
else
    # Handle selection
    selection="$1"
    case "$selection" in
        *"Screenshot: Region")
            coproc (mkdir -p ~/Pictures/Screenshots && \
                   hyprshot -m region -o ~/Pictures/Screenshots -f "screenshot_$(date +%Y%m%d_%H%M%S).png" && \
                   notify-send "Screenshot" "Region saved to ~/Pictures/Screenshots/")
            ;;
        *"Screenshot: Window")
            coproc (mkdir -p ~/Pictures/Screenshots && \
                   hyprshot -m window -o ~/Pictures/Screenshots -f "screenshot_$(date +%Y%m%d_%H%M%S).png" && \
                   notify-send "Screenshot" "Window saved to ~/Pictures/Screenshots/")
            ;;
        *"Screenshot: Fullscreen")
            coproc (mkdir -p ~/Pictures/Screenshots && \
                   hyprshot -m output -o ~/Pictures/Screenshots -f "screenshot_$(date +%Y%m%d_%H%M%S).png" && \
                   notify-send "Screenshot" "Fullscreen saved to ~/Pictures/Screenshots/")
            ;;
        *"Region → Clipboard")
            coproc (hyprshot -m region --clipboard-only && \
                   notify-send "Screenshot" "Region copied to clipboard")
            ;;
        *"Window → Clipboard")
            coproc (hyprshot -m window --clipboard-only && \
                   notify-send "Screenshot" "Window copied to clipboard")
            ;;
        *"Lock Screen")
            coproc hyprlock
            ;;
        *"Logout")
            # Return a special marker that will trigger confirmation
            echo "CONFIRM:logout"
            ;;
        *"Suspend")
            coproc systemctl suspend
            ;;
        *"Reboot")
            echo "CONFIRM:reboot"
            ;;
        *"Shutdown")
            echo "CONFIRM:shutdown"
            ;;
        *"WiFi Settings")
            coproc nm-connection-editor
            ;;
        *"Bluetooth")
            coproc blueman-manager
            ;;
        *"Monitor")
            coproc gnome-system-monitor
            ;;
        *"Color Picker")
            coproc (hyprpicker | wl-copy && \
                   notify-send "Color Picker" "Color copied to clipboard")
            ;;
        *"Clipboard History")
            coproc (cliphist list | rofi -dmenu -theme ~/.config/rofi/black-theme.rasi -p "Clipboard" | cliphist decode | wl-copy)
            ;;
        *"Window Switcher")
            coproc rofi -show window -theme ~/.config/rofi/black-theme.rasi
            ;;
        *"File Browser")
            coproc rofi -show filebrowser -theme ~/.config/rofi/black-theme.rasi
            ;;
        *"Run Command")
            coproc rofi -show run -theme ~/.config/rofi/black-theme.rasi
            ;;
    esac
fi
EOF

chmod +x /tmp/rofi-actions-modi.sh

# Launch rofi with combined modes - applications (drun) and custom actions (script)
result=$(rofi \
    -modi "drun,actions:/tmp/rofi-actions-modi.sh" \
    -show drun \
    -combi-modi "drun,actions" \
    -theme ~/.config/rofi/black-theme.rasi \
    -matching fuzzy \
    -show-icons \
    -display-drun "Launcher" \
    -display-actions "Actions" \
    -display-combi "All" \
    -kb-mode-complete "" \
    -kb-accept-alt "Shift+Return")

# Handle confirmations if needed
if [[ "$result" == "CONFIRM:"* ]]; then
    action="${result#CONFIRM:}"
    confirm=$(echo -e "Yes\nNo" | rofi -dmenu -theme ~/.config/rofi/black-theme.rasi -p "Confirm ${action^}?")
    if [[ "$confirm" == "Yes" ]]; then
        case "$action" in
            "logout")
                hyprctl dispatch exit ;;
            "reboot")
                systemctl reboot ;;
            "shutdown")
                systemctl poweroff ;;
        esac
    fi
fi

# Clean up
rm -f /tmp/rofi-actions-modi.sh