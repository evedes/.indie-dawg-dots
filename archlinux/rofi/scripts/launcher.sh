#!/usr/bin/env bash

# Advanced unified launcher with categories and dynamic app detection
# Combines built-in actions with installed applications

# Built-in custom actions
declare -A custom_actions=(
    ["󰹑 Screenshot Region"]="hyprshot -m region -o ~/Downloads/Screenshots -f screenshot_$(date +%Y%m%d_%H%M%S).png"
    ["󰍹 Screenshot Window"]="hyprshot -m window -o ~/Downloads/Screenshots -f screenshot_$(date +%Y%m%d_%H%M%S).png"
    ["󰍺 Screenshot Fullscreen"]="hyprshot -m output -o ~/Downloads/Screenshots -f screenshot_$(date +%Y%m%d_%H%M%S).png"
    ["󰨇 Screenshot Region → Clipboard"]="hyprshot -m region --clipboard-only"
    ["󰨇 Screenshot Window → Clipboard"]="hyprshot -m window --clipboard-only"
    ["󰌾 Lock Screen"]="hyprlock"
    ["󰍃 Logout"]="hyprctl dispatch exit"
    ["󰒲 Suspend"]="systemctl suspend"
    ["󰜉 Reboot"]="systemctl reboot"
    ["󰐥 Shutdown"]="systemctl poweroff"
    ["󰖟 WiFi Settings"]="nm-connection-editor"
    ["󱎴 Bluetooth"]="blueman-manager"
    ["󰏘 System Monitor"]="gnome-system-monitor"
    ["󰢻 Color Picker"]="hyprpicker | wl-copy"
    ["󰅍 Clipboard History"]="cliphist list | rofi -dmenu -theme ~/.config/rofi/arch-theme.rasi | cliphist decode | wl-copy"
    ["󱡶 Window Switcher"]="rofi -show window -theme ~/.config/rofi/arch-theme.rasi"
    ["󰉋 File Browser"]="rofi -show filebrowser -theme ~/.config/rofi/arch-theme.rasi"
    ["󰍉 Run Command"]="rofi -show run -theme ~/.config/rofi/arch-theme.rasi"
)

# Get all available desktop applications
get_applications() {
    # Get app names from .desktop files
    for desktop in /usr/share/applications/*.desktop ~/.local/share/applications/*.desktop; do
        [[ -f "$desktop" ]] || continue
        
        # Extract name and exec command
        name=$(grep -m1 "^Name=" "$desktop" 2>/dev/null | cut -d= -f2)
        exec=$(grep -m1 "^Exec=" "$desktop" 2>/dev/null | cut -d= -f2 | sed 's/%[fFuU]//g')
        
        # Skip if no name or exec
        [[ -z "$name" || -z "$exec" ]] && continue
        
        # Add app icon prefix
        echo "󱓞 $name|$exec"
    done | sort -u
}

# Combine custom actions and applications
options=""

# Add custom actions
for action in "${!custom_actions[@]}"; do
    options="$options$action\n"
done

# Add separator
options="${options}──────────────────\n"

# Add applications
while IFS='|' read -r name cmd; do
    [[ -n "$name" ]] && options="$options$name\n"
done < <(get_applications)

# Show rofi with fuzzy matching
chosen=$(echo -e "$options" | rofi -dmenu -theme ~/.config/rofi/arch-theme.rasi -p "Launch" -i -matching fuzzy -no-custom)

[[ -z "$chosen" ]] && exit 0

# Skip separator
[[ "$chosen" == "──────────────────" ]] && exit 0

# Check if it's a custom action
if [[ -n "${custom_actions[$chosen]}" ]]; then
    # Handle confirmation for destructive actions
    if [[ "$chosen" =~ (Reboot|Shutdown|Logout) ]]; then
        confirm=$(echo -e "Yes\nNo" | rofi -dmenu -theme ~/.config/rofi/arch-theme.rasi -p "Confirm $chosen?")
        [[ "$confirm" != "Yes" ]] && exit 0
    fi
    
    # Execute custom action
    eval "${custom_actions[$chosen]}" &
    
    # Notify for screenshots
    if [[ "$chosen" =~ Screenshot ]]; then
        if [[ "$chosen" =~ Clipboard ]]; then
            notify-send "Screenshot" "Copied to clipboard"
        else
            notify-send "Screenshot" "Saved to ~/Downloads/Screenshots/"
        fi
    fi
else
    # It's an application - find and execute it
    app_name="${chosen#* }"  # Remove icon prefix
    
    # Find the desktop file and execute
    for desktop in /usr/share/applications/*.desktop ~/.local/share/applications/*.desktop; do
        [[ -f "$desktop" ]] || continue
        
        if grep -q "^Name=$app_name$" "$desktop" 2>/dev/null; then
            exec_cmd=$(grep -m1 "^Exec=" "$desktop" | cut -d= -f2 | sed 's/%[fFuU]//g')
            [[ -n "$exec_cmd" ]] && eval "$exec_cmd" &
            break
        fi
    done
fi
