#!/usr/bin/env bash

# Smart launcher that intelligently switches between modes
# First shows applications with icons, typing certain keywords switches to actions

# If argument is provided, show actions
if [[ "$1" == "actions" ]]; then
    ~/.config/rofi/scripts/unified-launcher.sh
    exit 0
fi

# Check if rofi is already running
if pgrep -x rofi > /dev/null; then
    killall rofi
    exit 0
fi

# Show drun with icons, but with a custom prompt
rofi -show drun \
    -theme ~/.config/rofi/arch-theme.rasi \
    -matching fuzzy \
    -show-icons \
    -icon-theme "Papirus" \
    -p "Apps" \
    -mesg "Tip: Press Alt+Tab for actions menu" \
    -kb-custom-1 "Alt+Tab" \
    -kb-accept-entry "Return" \
    -kb-cancel "Escape,Alt+Tab"

# Check exit code - 10 means custom keybinding was pressed
if [[ $? -eq 10 ]]; then
    # Switch to actions menu
    ~/.config/rofi/scripts/unified-launcher.sh
fi