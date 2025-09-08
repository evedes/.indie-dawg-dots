#!/usr/bin/env bash

# Master menu that launches other rofi scripts

declare -A menus=(
    ["󱗆  Applications"]="rofi -show drun -theme ~/.config/rofi/arch-theme.rasi"
    ["󰍉  Run Command"]="rofi -show run -theme ~/.config/rofi/arch-theme.rasi"
    ["󰹑  Screenshot"]="~/.config/rofi/scripts/screenshot.sh"
    ["󰐥  Power Menu"]="~/.config/rofi/scripts/powermenu.sh"
    ["󰆍  Quick Launch"]="~/.config/rofi/scripts/quicklaunch.sh"
    ["󰅍  Clipboard"]="~/.config/rofi/scripts/clipboard.sh"
    ["󰊭  Web Search"]="~/.config/rofi/scripts/web-search.sh"
    ["󰖟  WiFi"]="~/.config/rofi/scripts/wifi.sh"
    ["󱡶  Window Switcher"]="rofi -show window -theme ~/.config/rofi/arch-theme.rasi"
    ["󰉋  File Browser"]="rofi -show filebrowser -theme ~/.config/rofi/arch-theme.rasi"
)

chosen=$(printf '%s\n' "${!menus[@]}" | sort | rofi -dmenu -theme ~/.config/rofi/arch-theme.rasi -p "Menu")

[[ -z "$chosen" ]] && exit 0

# Execute the chosen menu
eval "${menus[$chosen]}"