#!/bin/bash

echo "Installing mako notification daemon..."
sudo pacman -S mako

echo "Starting mako..."
killall mako 2>/dev/null
mako &

sleep 1

echo "Testing notifications..."
notify-send "Test Notification" "Notifications are working!" -u normal
sleep 2
notify-send "Screenshot Test" "This is how screenshots will appear" -u normal -i camera-photo
sleep 2
notify-send "Critical Alert" "This is a high priority notification" -u critical

echo ""
echo "✅ Notification system setup complete!"
echo "Mako will now start automatically when you log in to Hyprland."