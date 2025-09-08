#!/usr/bin/env bash

# Quick launch menu with custom commands
# Add your frequently used apps and commands here

declare -A apps=(
    ["󰈹  Firefox"]="firefox"
    ["󰨞  VS Code"]="code"
    ["󰊯  Terminal"]="ghostty"
    ["󰉋  Files"]="nautilus"
    ["󰓓  Calculator"]="gnome-calculator"
    ["󰝚  Music"]="spotify"
    ["󰭹  Discord"]="discord"
    ["󰇮  Email"]="thunderbird"
    ["󰖟  WiFi Settings"]="nm-connection-editor"
    ["󱎴  Bluetooth"]="blueman-manager"
    ["󰏘  System Monitor"]="gnome-system-monitor"
    ["󰢻  Color Picker"]="hyprpicker | wl-copy"
)

chosen=$(printf '%s\n' "${!apps[@]}" | sort | rofi -dmenu -theme ~/.config/rofi/arch-theme.rasi -p "Launch")

[[ -z "$chosen" ]] && exit 0

# Launch the application
eval "${apps[$chosen]}" &