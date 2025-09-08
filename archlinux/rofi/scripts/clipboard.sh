#!/usr/bin/env bash

# Clipboard manager for rofi
# Requires: cliphist (for Wayland) or clipmenu (for X11)

# Check if running on Wayland or X11
if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
    # Use cliphist for Wayland
    if command -v cliphist &> /dev/null; then
        cliphist list | rofi -dmenu -theme ~/.config/rofi/arch-theme.rasi -p "Clipboard" | cliphist decode | wl-copy
    else
        notify-send "Clipboard Manager" "cliphist not installed. Install with: yay -S cliphist"
    fi
else
    # Use clipmenu for X11
    if command -v clipmenu &> /dev/null; then
        clipmenu -i -theme ~/.config/rofi/arch-theme.rasi -p "Clipboard"
    else
        notify-send "Clipboard Manager" "clipmenu not installed"
    fi
fi