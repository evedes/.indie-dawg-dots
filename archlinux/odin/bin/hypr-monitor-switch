#!/usr/bin/env bash
# Switch Hyprland monitor configuration using fzf

MONITORS_DIR="$HOME/.indie-dawg-dots/archlinux/hypr/monitors"
MONITORS_CONF="$HOME/.indie-dawg-dots/archlinux/hypr/monitors.conf"

# Get currently active config
current=$(grep -m1 '^source' "$MONITORS_CONF" | sed 's|.*/||')

# List available configs and pick one with fzf
selected=$(ls "$MONITORS_DIR"/*.conf | xargs -n1 basename | \
  fzf --prompt="Monitor setup: " \
      --header="Current: $current" \
      --height=~10 \
      --layout=reverse)

[ -z "$selected" ] && exit 0

# Comment all source lines, then uncomment the selected one
sed -i 's|^source = |# source = |' "$MONITORS_CONF"
sed -i "s|^# source = .*/$selected|source = ~/.indie-dawg-dots/archlinux/hypr/monitors/$selected|" "$MONITORS_CONF"

echo "Switched to: $selected"
hyprctl reload 2>/dev/null && echo "Hyprland reloaded." || echo "Run 'hyprctl reload' to apply."
