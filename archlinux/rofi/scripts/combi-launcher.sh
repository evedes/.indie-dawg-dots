#!/usr/bin/env bash

# Combined launcher using rofi's combi mode
# Shows both applications (with icons) and custom actions

# Create a custom modi script for our actions
cat > /tmp/rofi-actions.sh << 'EOF'
#!/usr/bin/env bash

if [[ "$1" == "" ]]; then
    # List all custom actions
    echo "󰹑 Screenshot Region"
    echo "󰍹 Screenshot Window"
    echo "󰍺 Screenshot Fullscreen"
    echo "󰨇 Screenshot Region → Clipboard"
    echo "󰨇 Screenshot Window → Clipboard"
    echo "󰌾 Lock Screen"
    echo "󰍃 Logout"
    echo "󰒲 Suspend"
    echo "󰜉 Reboot"
    echo "󰐥 Shutdown"
    echo "󰖟 WiFi Settings"
    echo "󱎴 Bluetooth"
    echo "󰏘 System Monitor"
    echo "󰢻 Color Picker"
    echo "󰅍 Clipboard History"
    echo "󱡶 Window Switcher"
    echo "󰉋 File Browser"
    echo "󰍉 Run Command"
else
    # Execute the selected action
    case "$1" in
        *"Screenshot Region")
            hyprshot -m region -o ~/Pictures/Screenshots -f screenshot_$(date +%Y%m%d_%H%M%S).png
            notify-send "Screenshot" "Region saved to ~/Pictures/Screenshots/"
            ;;
        *"Screenshot Window")
            hyprshot -m window -o ~/Pictures/Screenshots -f screenshot_$(date +%Y%m%d_%H%M%S).png
            notify-send "Screenshot" "Window saved to ~/Pictures/Screenshots/"
            ;;
        *"Screenshot Fullscreen")
            hyprshot -m output -o ~/Pictures/Screenshots -f screenshot_$(date +%Y%m%d_%H%M%S).png
            notify-send "Screenshot" "Fullscreen saved to ~/Pictures/Screenshots/"
            ;;
        *"Screenshot Region → Clipboard")
            hyprshot -m region --clipboard-only
            notify-send "Screenshot" "Region copied to clipboard"
            ;;
        *"Screenshot Window → Clipboard")
            hyprshot -m window --clipboard-only
            notify-send "Screenshot" "Window copied to clipboard"
            ;;
        *"Lock Screen")
            hyprlock
            ;;
        *"Logout")
            confirm=$(echo -e "Yes\nNo" | rofi -dmenu -theme ~/.config/rofi/arch-theme.rasi -p "Confirm Logout?")
            [[ "$confirm" == "Yes" ]] && hyprctl dispatch exit
            ;;
        *"Suspend")
            systemctl suspend
            ;;
        *"Reboot")
            confirm=$(echo -e "Yes\nNo" | rofi -dmenu -theme ~/.config/rofi/arch-theme.rasi -p "Confirm Reboot?")
            [[ "$confirm" == "Yes" ]] && systemctl reboot
            ;;
        *"Shutdown")
            confirm=$(echo -e "Yes\nNo" | rofi -dmenu -theme ~/.config/rofi/arch-theme.rasi -p "Confirm Shutdown?")
            [[ "$confirm" == "Yes" ]] && systemctl poweroff
            ;;
        *"WiFi Settings")
            nm-connection-editor &
            ;;
        *"Bluetooth")
            blueman-manager &
            ;;
        *"System Monitor")
            gnome-system-monitor &
            ;;
        *"Color Picker")
            hyprpicker | wl-copy
            notify-send "Color Picker" "Color copied to clipboard"
            ;;
        *"Clipboard History")
            cliphist list | rofi -dmenu -theme ~/.config/rofi/arch-theme.rasi | cliphist decode | wl-copy
            ;;
        *"Window Switcher")
            rofi -show window -theme ~/.config/rofi/arch-theme.rasi
            ;;
        *"File Browser")
            rofi -show filebrowser -theme ~/.config/rofi/arch-theme.rasi
            ;;
        *"Run Command")
            rofi -show run -theme ~/.config/rofi/arch-theme.rasi
            ;;
    esac
fi
EOF

chmod +x /tmp/rofi-actions.sh

# Launch rofi in combi mode with both drun (for apps with icons) and our custom actions
rofi -show combi -combi-modi "drun,actions:/tmp/rofi-actions.sh" -modi combi -theme ~/.config/rofi/arch-theme.rasi -matching fuzzy -show-icons