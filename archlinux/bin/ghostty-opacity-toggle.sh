#!/bin/bash

CONFIG_FILE="$HOME/.config/ghostty/config"
OPACITY_STORE="$HOME/.config/ghostty/.opacity-value"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file not found: $CONFIG_FILE"
    exit 1
fi

CURRENT=$(grep "^background-opacity" "$CONFIG_FILE" | head -1 | awk '{print $3}')

if [ -z "$CURRENT" ]; then
    echo "No background-opacity found in config"
    exit 1
fi

if [ "$CURRENT" = "1" ] || [ "$CURRENT" = "1.0" ] || [ "$CURRENT" = "1.00" ]; then
    # Restore saved transparent value, default to 0.80
    if [ -f "$OPACITY_STORE" ]; then
        NEW=$(cat "$OPACITY_STORE")
    else
        NEW="0.80"
    fi
else
    # Save current value and go opaque
    echo "$CURRENT" > "$OPACITY_STORE"
    NEW="1"
fi

CONTENT=$(sed "s/^background-opacity = .*/background-opacity = $NEW/" "$CONFIG_FILE")
printf '%s\n' "$CONTENT" > "$CONFIG_FILE"

# Reload Ghostty config via DBus
busctl --user call com.mitchellh.ghostty /com/mitchellh/ghostty org.gtk.Actions Activate "sava{sv}" "reload-config" 0 0 2>/dev/null
