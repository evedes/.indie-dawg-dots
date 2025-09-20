#!/usr/bin/env bash

# HexArchy Multi-Mode Launcher with mode switching support

# First, check if we're being called to execute an action
if [[ "$1" == "--execute-action" ]]; then
    action="$2"
    case "$action" in
        "Screenshot: Region")
            mkdir -p ~/Pictures/Screenshots
            hyprshot -m region -o ~/Pictures/Screenshots -f "screenshot_$(date +%Y%m%d_%H%M%S).png"
            notify-send "Screenshot" "Region saved to ~/Pictures/Screenshots/"
            ;;
        "Screenshot: Window")
            mkdir -p ~/Pictures/Screenshots
            hyprshot -m window -o ~/Pictures/Screenshots -f "screenshot_$(date +%Y%m%d_%H%M%S).png"
            notify-send "Screenshot" "Window saved to ~/Pictures/Screenshots/"
            ;;
        "Screenshot: Fullscreen")
            mkdir -p ~/Pictures/Screenshots
            hyprshot -m output -o ~/Pictures/Screenshots -f "screenshot_$(date +%Y%m%d_%H%M%S).png"
            notify-send "Screenshot" "Fullscreen saved to ~/Pictures/Screenshots/"
            ;;
        "Screenshot: Region → Clipboard")
            hyprshot -m region --clipboard-only
            notify-send "Screenshot" "Region copied to clipboard"
            ;;
        "Screenshot: Window → Clipboard")
            hyprshot -m window --clipboard-only
            notify-send "Screenshot" "Window copied to clipboard"
            ;;
        "Power: Lock Screen")
            hyprlock
            ;;
        "Power: Logout")
            confirm=$(echo -e "Yes\nNo" | rofi -dmenu -theme ~/.config/rofi/hexarchy-theme.rasi -p "Confirm Logout?")
            [[ "$confirm" == "Yes" ]] && hyprctl dispatch exit
            ;;
        "Power: Suspend")
            systemctl suspend
            ;;
        "Power: Reboot")
            confirm=$(echo -e "Yes\nNo" | rofi -dmenu -theme ~/.config/rofi/hexarchy-theme.rasi -p "Confirm Reboot?")
            [[ "$confirm" == "Yes" ]] && systemctl reboot
            ;;
        "Power: Shutdown")
            confirm=$(echo -e "Yes\nNo" | rofi -dmenu -theme ~/.config/rofi/hexarchy-theme.rasi -p "Confirm Shutdown?")
            [[ "$confirm" == "Yes" ]] && systemctl poweroff
            ;;
        "System: WiFi Settings")
            nm-connection-editor &
            ;;
        "System: Bluetooth")
            blueman-manager &
            ;;
        "System: Monitor")
            gnome-system-monitor &
            ;;
        "Tools: Color Picker")
            hyprpicker | wl-copy
            notify-send "Color Picker" "Color copied to clipboard"
            ;;
        "Tools: Clipboard History")
            cliphist list | rofi -dmenu -theme ~/.config/rofi/hexarchy-theme.rasi -p "Clipboard" | cliphist decode | wl-copy
            ;;
        "Window Switcher")
            rofi -show window -theme ~/.config/rofi/hexarchy-theme.rasi
            ;;
        "File Browser")
            rofi -show filebrowser -theme ~/.config/rofi/hexarchy-theme.rasi
            ;;
        "Run Command")
            rofi -show run -theme ~/.config/rofi/hexarchy-theme.rasi
            ;;
    esac
    exit 0
fi

# Create desktop entries for actions in a temp directory
TEMP_DIR="/tmp/rofi-hexarchy-$$"
mkdir -p "$TEMP_DIR/applications"

# Create .desktop files for each action
cat > "$TEMP_DIR/applications/hexarchy-screenshot-region.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Screenshot: Region
Comment=Take a screenshot of a selected region
Icon=applets-screenshooter
Exec=$0 --execute-action "Screenshot: Region"
Categories=Utility;Screenshot;
Keywords=screenshot;region;capture;
EOF

cat > "$TEMP_DIR/applications/hexarchy-screenshot-window.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Screenshot: Window
Comment=Take a screenshot of a window
Icon=applets-screenshooter
Exec=$0 --execute-action "Screenshot: Window"
Categories=Utility;Screenshot;
Keywords=screenshot;window;capture;
EOF

cat > "$TEMP_DIR/applications/hexarchy-screenshot-fullscreen.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Screenshot: Fullscreen
Comment=Take a fullscreen screenshot
Icon=applets-screenshooter
Exec=$0 --execute-action "Screenshot: Fullscreen"
Categories=Utility;Screenshot;
Keywords=screenshot;fullscreen;screen;capture;
EOF

cat > "$TEMP_DIR/applications/hexarchy-screenshot-region-clip.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Screenshot: Region → Clipboard
Comment=Screenshot region to clipboard
Icon=edit-copy
Exec=$0 --execute-action "Screenshot: Region → Clipboard"
Categories=Utility;Screenshot;
Keywords=screenshot;clipboard;region;
EOF

cat > "$TEMP_DIR/applications/hexarchy-screenshot-window-clip.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Screenshot: Window → Clipboard
Comment=Screenshot window to clipboard
Icon=edit-copy
Exec=$0 --execute-action "Screenshot: Window → Clipboard"
Categories=Utility;Screenshot;
Keywords=screenshot;clipboard;window;
EOF

cat > "$TEMP_DIR/applications/hexarchy-lock.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Power: Lock Screen
Comment=Lock the screen
Icon=system-lock-screen
Exec=$0 --execute-action "Power: Lock Screen"
Categories=System;
Keywords=lock;screen;security;
EOF

cat > "$TEMP_DIR/applications/hexarchy-logout.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Power: Logout
Comment=End the current session
Icon=system-log-out
Exec=$0 --execute-action "Power: Logout"
Categories=System;
Keywords=logout;exit;quit;
EOF

cat > "$TEMP_DIR/applications/hexarchy-suspend.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Power: Suspend
Comment=Suspend the system
Icon=system-suspend
Exec=$0 --execute-action "Power: Suspend"
Categories=System;
Keywords=suspend;sleep;
EOF

cat > "$TEMP_DIR/applications/hexarchy-reboot.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Power: Reboot
Comment=Restart the system
Icon=system-reboot
Exec=$0 --execute-action "Power: Reboot"
Categories=System;
Keywords=reboot;restart;
EOF

cat > "$TEMP_DIR/applications/hexarchy-shutdown.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Power: Shutdown
Comment=Power off the system
Icon=system-shutdown
Exec=$0 --execute-action "Power: Shutdown"
Categories=System;
Keywords=shutdown;poweroff;
EOF

cat > "$TEMP_DIR/applications/hexarchy-wifi.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=System: WiFi Settings
Comment=Configure WiFi connections
Icon=network-wireless
Exec=$0 --execute-action "System: WiFi Settings"
Categories=Settings;Network;
Keywords=wifi;network;wireless;internet;
EOF

cat > "$TEMP_DIR/applications/hexarchy-bluetooth.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=System: Bluetooth
Comment=Manage Bluetooth devices
Icon=bluetooth
Exec=$0 --execute-action "System: Bluetooth"
Categories=Settings;Hardware;
Keywords=bluetooth;devices;
EOF

cat > "$TEMP_DIR/applications/hexarchy-monitor.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=System: Monitor
Comment=System resource monitor
Icon=utilities-system-monitor
Exec=$0 --execute-action "System: Monitor"
Categories=System;Monitor;
Keywords=monitor;system;resources;cpu;memory;
EOF

cat > "$TEMP_DIR/applications/hexarchy-colorpicker.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Tools: Color Picker
Comment=Pick colors from the screen
Icon=color-picker
Exec=$0 --execute-action "Tools: Color Picker"
Categories=Graphics;Utility;
Keywords=color;picker;eyedropper;
EOF

cat > "$TEMP_DIR/applications/hexarchy-clipboard.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Tools: Clipboard History
Comment=View clipboard history
Icon=edit-paste
Exec=$0 --execute-action "Tools: Clipboard History"
Categories=Utility;
Keywords=clipboard;history;paste;
EOF

cat > "$TEMP_DIR/applications/hexarchy-window-switcher.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Window Switcher
Comment=Switch between open windows
Icon=preferences-system-windows
Exec=$0 --execute-action "Window Switcher"
Categories=System;
Keywords=window;switch;alt-tab;
EOF

cat > "$TEMP_DIR/applications/hexarchy-filebrowser.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=File Browser
Comment=Browse files with Rofi
Icon=system-file-manager
Exec=$0 --execute-action "File Browser"
Categories=System;FileTools;
Keywords=files;browse;explorer;
EOF

cat > "$TEMP_DIR/applications/hexarchy-run.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Run Command
Comment=Run a custom command
Icon=system-run
Exec=$0 --execute-action "Run Command"
Categories=System;
Keywords=run;command;execute;terminal;
EOF

# Launch rofi with just apps (including our custom actions)
# Prepend our temp dir to XDG_DATA_DIRS to add actions to existing apps
export XDG_DATA_DIRS="$TEMP_DIR:${XDG_DATA_DIRS:-/usr/share:/usr/local/share}"

rofi \
    -modi "drun" \
    -show drun \
    -theme ~/.config/rofi/hexarchy-theme.rasi \
    -matching fuzzy \
    -show-icons \
    -drun-display-format "{name}" \
    -sort true \
    -drun-use-desktop-cache false \
    -drun-reload-desktop-cache true

# Cleanup
rm -rf "$TEMP_DIR"