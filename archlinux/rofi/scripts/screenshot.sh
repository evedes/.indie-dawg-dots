#!/usr/bin/env bash

# Screenshot menu for rofi using hyprshot
# Requires: hyprshot, rofi, wl-copy (for clipboard)

# Define screenshot options
declare -A options=(
    ["󰹑  Region"]="region"
    ["󰍹  Window"]="window"
    ["󰍺  Fullscreen"]="fullscreen"
    ["󰹑  Region → Clipboard"]="region-clip"
    ["󰍹  Window → Clipboard"]="window-clip"
    ["󰍺  Fullscreen → Clipboard"]="fullscreen-clip"
)

# Create menu
chosen=$(printf '%s\n' "${!options[@]}" | rofi -dmenu -theme ~/.config/rofi/arch-theme.rasi -p "Screenshot")

# Exit if nothing chosen
[[ -z "$chosen" ]] && exit 0

# Get the action
action="${options[$chosen]}"

# Screenshot directory
SCREENSHOT_DIR="$HOME/Downloads"
mkdir -p "$SCREENSHOT_DIR"

FILENAME="screenshot_$(date +%Y%m%d_%H%M%S).png"
FILEPATH="$SCREENSHOT_DIR/$FILENAME"

# Execute based on selection
case "$action" in
    "region")
        hyprshot -m region -o "$SCREENSHOT_DIR" -f "$FILENAME"
        notify-send "Screenshot" "Region saved to $FILENAME" -i "$FILEPATH"
        ;;
    "window")
        hyprshot -m window -o "$SCREENSHOT_DIR" -f "$FILENAME"
        notify-send "Screenshot" "Window saved to $FILENAME" -i "$FILEPATH"
        ;;
    "fullscreen")
        hyprshot -m output -o "$SCREENSHOT_DIR" -f "$FILENAME"
        notify-send "Screenshot" "Screen saved to $FILENAME" -i "$FILEPATH"
        ;;
    "region-clip")
        hyprshot -m region --clipboard-only
        notify-send "Screenshot" "Region copied to clipboard"
        ;;
    "window-clip")
        hyprshot -m window --clipboard-only
        notify-send "Screenshot" "Window copied to clipboard"
        ;;
    "fullscreen-clip")
        hyprshot -m output --clipboard-only
        notify-send "Screenshot" "Screen copied to clipboard"
        ;;
esac
