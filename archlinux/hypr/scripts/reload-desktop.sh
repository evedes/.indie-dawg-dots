#!/bin/bash
# Restart Waybar with the current Hyprland instance signature

killall waybar 2>/dev/null
killall hyprpaper 2>/dev/null

sleep 0.2
# hyprpaper &
waybar &
