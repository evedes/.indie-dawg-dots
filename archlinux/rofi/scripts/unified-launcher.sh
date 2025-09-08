#!/usr/bin/env bash

# Unified launcher that shows both applications and custom actions
# Preserves application icons while adding custom actions

# Custom actions with icons (using Nerd Font icons)
custom_actions="󰹑 Screenshot: Region
󰍹 Screenshot: Window
󰍺 Screenshot: Fullscreen
󰨇 Screenshot: Region → Clipboard
󰨇 Screenshot: Window → Clipboard
󰌾 Power: Lock Screen
󰍃 Power: Logout
󰒲 Power: Suspend
󰜉 Power: Reboot
󰐥 Power: Shutdown
󰖟 System: WiFi Settings
󱎴 System: Bluetooth
󰏘 System: Monitor
󰢻 Tools: Color Picker
󰅍 Tools: Clipboard History
󱡶 Rofi: Window Switcher
󰉋 Rofi: File Browser
󰍉 Rofi: Run Command"

# Use rofi in dmenu mode to select
selection=$(echo "$custom_actions" | rofi -dmenu -theme ~/.config/rofi/arch-theme.rasi -p "Actions" -i -matching fuzzy -lines 12)

# Exit if nothing selected
[[ -z "$selection" ]] && exit 0

# Execute based on selection
case "$selection" in
    *"Screenshot: Region")
        mkdir -p ~/Pictures/Screenshots
        hyprshot -m region -o ~/Pictures/Screenshots -f "screenshot_$(date +%Y%m%d_%H%M%S).png"
        notify-send "Screenshot" "Region saved to ~/Pictures/Screenshots/" ;;
    *"Screenshot: Window")
        mkdir -p ~/Pictures/Screenshots
        hyprshot -m window -o ~/Pictures/Screenshots -f "screenshot_$(date +%Y%m%d_%H%M%S).png"
        notify-send "Screenshot" "Window saved to ~/Pictures/Screenshots/" ;;
    *"Screenshot: Fullscreen")
        mkdir -p ~/Pictures/Screenshots
        hyprshot -m output -o ~/Pictures/Screenshots -f "screenshot_$(date +%Y%m%d_%H%M%S).png"
        notify-send "Screenshot" "Fullscreen saved to ~/Pictures/Screenshots/" ;;
    *"Region → Clipboard")
        hyprshot -m region --clipboard-only
        notify-send "Screenshot" "Region copied to clipboard" ;;
    *"Window → Clipboard")
        hyprshot -m window --clipboard-only
        notify-send "Screenshot" "Window copied to clipboard" ;;
    *"Lock Screen")
        hyprlock ;;
    *"Logout")
        confirm=$(echo -e "Yes\nNo" | rofi -dmenu -theme ~/.config/rofi/arch-theme.rasi -p "Confirm Logout?")
        [[ "$confirm" == "Yes" ]] && hyprctl dispatch exit ;;
    *"Suspend")
        systemctl suspend ;;
    *"Reboot")
        confirm=$(echo -e "Yes\nNo" | rofi -dmenu -theme ~/.config/rofi/arch-theme.rasi -p "Confirm Reboot?")
        [[ "$confirm" == "Yes" ]] && systemctl reboot ;;
    *"Shutdown")
        confirm=$(echo -e "Yes\nNo" | rofi -dmenu -theme ~/.config/rofi/arch-theme.rasi -p "Confirm Shutdown?")
        [[ "$confirm" == "Yes" ]] && systemctl poweroff ;;
    *"WiFi Settings")
        nm-connection-editor & ;;
    *"Bluetooth")
        blueman-manager & ;;
    *"Monitor")
        gnome-system-monitor & ;;
    *"Color Picker")
        hyprpicker | wl-copy
        notify-send "Color Picker" "Color copied to clipboard" ;;
    *"Clipboard History")
        cliphist list | rofi -dmenu -theme ~/.config/rofi/arch-theme.rasi -p "Clipboard" | cliphist decode | wl-copy ;;
    *"Window Switcher")
        rofi -show window -theme ~/.config/rofi/arch-theme.rasi ;;
    *"File Browser")
        rofi -show filebrowser -theme ~/.config/rofi/arch-theme.rasi ;;
    *"Run Command")
        rofi -show run -theme ~/.config/rofi/arch-theme.rasi ;;
esac