#!/usr/bin/env bash

# Unified action launcher for rofi with fuzzy search
# All actions in one searchable menu

declare -A actions=(
    # Screenshots
    ["Screenshot: Region"]="hyprshot -m region -o ~/Pictures/Screenshots -f screenshot_$(date +%Y%m%d_%H%M%S).png"
    ["Screenshot: Window"]="hyprshot -m window -o ~/Pictures/Screenshots -f screenshot_$(date +%Y%m%d_%H%M%S).png"
    ["Screenshot: Fullscreen"]="hyprshot -m output -o ~/Pictures/Screenshots -f screenshot_$(date +%Y%m%d_%H%M%S).png"
    ["Screenshot: Region to Clipboard"]="hyprshot -m region --clipboard-only"
    ["Screenshot: Window to Clipboard"]="hyprshot -m window --clipboard-only"
    ["Screenshot: Fullscreen to Clipboard"]="hyprshot -m output --clipboard-only"
    
    # Power actions
    ["Power: Lock Screen"]="hyprlock"
    ["Power: Logout"]="hyprctl dispatch exit"
    ["Power: Suspend"]="systemctl suspend"
    ["Power: Reboot"]="systemctl reboot"
    ["Power: Shutdown"]="systemctl poweroff"
    
    # Applications
    ["App: Firefox"]="firefox"
    ["App: VS Code"]="code"
    ["App: Terminal"]="ghostty"
    ["App: File Manager"]="nautilus"
    ["App: Calculator"]="gnome-calculator"
    ["App: Spotify"]="spotify"
    ["App: Discord"]="discord"
    ["App: System Monitor"]="gnome-system-monitor"
    
    # System tools
    ["System: WiFi Settings"]="nm-connection-editor"
    ["System: Bluetooth Manager"]="blueman-manager"
    ["System: Color Picker"]="hyprpicker | wl-copy"
    ["System: Clipboard History"]="cliphist list | rofi -dmenu -theme ~/.config/rofi/arch-theme.rasi | cliphist decode | wl-copy"
    
    # Rofi modes
    ["Rofi: Window Switcher"]="rofi -show window -theme ~/.config/rofi/arch-theme.rasi"
    ["Rofi: File Browser"]="rofi -show filebrowser -theme ~/.config/rofi/arch-theme.rasi"
    ["Rofi: Run Command"]="rofi -show run -theme ~/.config/rofi/arch-theme.rasi"
    ["Rofi: Applications"]="rofi -show drun -theme ~/.config/rofi/arch-theme.rasi"
    
    # Quick searches
    ["Search: Google"]="xdg-open 'https://google.com'"
    ["Search: GitHub"]="xdg-open 'https://github.com'"
    ["Search: YouTube"]="xdg-open 'https://youtube.com'"
    ["Search: Arch Wiki"]="xdg-open 'https://wiki.archlinux.org'"
)

# Sort actions alphabetically and show in rofi with fuzzy matching
chosen=$(printf '%s\n' "${!actions[@]}" | sort | rofi -dmenu -theme ~/.config/rofi/arch-theme.rasi -p "Actions" -i -matching fuzzy)

[[ -z "$chosen" ]] && exit 0

# Handle confirmation for destructive actions
if [[ "$chosen" =~ (Reboot|Shutdown|Logout) ]]; then
    confirm=$(echo -e "Yes\nNo" | rofi -dmenu -theme ~/.config/rofi/arch-theme.rasi -p "Confirm $chosen?")
    [[ "$confirm" != "Yes" ]] && exit 0
fi

# Execute the chosen action
eval "${actions[$chosen]}" &

# Show notification for screenshot actions
if [[ "$chosen" =~ ^Screenshot ]]; then
    if [[ "$chosen" =~ Clipboard ]]; then
        notify-send "Screenshot" "Copied to clipboard"
    else
        notify-send "Screenshot" "Saved to ~/Pictures/Screenshots/"
    fi
fi