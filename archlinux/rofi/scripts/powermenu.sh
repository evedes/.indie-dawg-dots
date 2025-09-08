#!/usr/bin/env bash

# Power menu for rofi
# Icons require a Nerd Font

declare -A options=(
    ["󰌾  Lock"]="hyprlock"
    ["󰍃  Logout"]="hyprctl dispatch exit"
    ["󰒲  Suspend"]="systemctl suspend"
    ["󰜉  Reboot"]="systemctl reboot"
    ["󰐥  Shutdown"]="systemctl poweroff"
)

chosen=$(printf '%s\n' "${!options[@]}" | rofi -dmenu -theme ~/.config/rofi/arch-theme.rasi -p "Power")

[[ -z "$chosen" ]] && exit 0

# Confirmation for destructive actions
if [[ "$chosen" =~ (Reboot|Shutdown|Logout) ]]; then
    confirm=$(echo -e "Yes\nNo" | rofi -dmenu -theme ~/.config/rofi/arch-theme.rasi -p "Confirm $chosen?")
    [[ "$confirm" != "Yes" ]] && exit 0
fi

# Execute command
eval "${options[$chosen]}"