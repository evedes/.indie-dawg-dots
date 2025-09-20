#!/usr/bin/env bash

# Toggle between applications (with icons) and actions menu
# Uses a state file to remember last mode

STATE_FILE="/tmp/rofi-launcher-state"

# Kill any existing rofi instance first
if pgrep -x rofi > /dev/null; then
    killall rofi
    # Small delay to ensure rofi is closed
    sleep 0.1
fi

# Read current state
if [[ -f "$STATE_FILE" ]]; then
    STATE=$(cat "$STATE_FILE")
else
    STATE="apps"
fi

# Toggle and launch
if [[ "$STATE" == "apps" ]]; then
    # Show actions next time
    echo "actions" > "$STATE_FILE"
    
    # Launch applications with icons
    rofi -show drun \
        -theme ~/.config/rofi/arch-theme.rasi \
        -matching fuzzy \
        -show-icons \
        -display-drun "Apps" \
        -p "Apps (Next: Actions)"
else
    # Show apps next time  
    echo "apps" > "$STATE_FILE"
    
    # Launch actions menu
    ~/.config/rofi/scripts/unified-launcher.sh
fi