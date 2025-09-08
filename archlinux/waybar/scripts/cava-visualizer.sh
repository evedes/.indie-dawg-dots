#!/bin/bash

# Create a named pipe for cava if it doesn't exist
PIPE="/tmp/cava_fifo"
if [ ! -p "$PIPE" ]; then
    mkfifo "$PIPE"
fi

# Check if cava is running, if not start it
if ! pgrep -x cava > /dev/null; then
    # Create minimal cava config for raw output
    cat > /tmp/cava_waybar.conf << EOF
[general]
framerate = 30
bars = 8

[output]
method = raw
raw_target = /tmp/cava_fifo
data_format = ascii
ascii_max_range = 7

[input]
method = pulse
source = auto

[smoothing]
integral = 70
monstercat = 1
waves = 0
gravity = 100
EOF
    
    # Start cava in background
    cava -p /tmp/cava_waybar.conf &>/dev/null &
    sleep 0.5
fi

# Read from pipe with timeout
if read -t 0.1 line < "$PIPE"; then
    # Convert numbers to bar characters
    bars=""
    bar_chars=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")
    
    # Process each character
    for (( i=0; i<${#line}; i++ )); do
        char="${line:$i:1}"
        if [[ "$char" =~ [0-7] ]]; then
            bars="${bars}${bar_chars[$char]}"
        fi
    done
    
    # Check if spotify is playing
    spotify_status=$(playerctl -p spotify status 2>/dev/null)
    if [ "$spotify_status" = "Playing" ]; then
        class="cava-active"
    else
        class="cava-idle"
        bars="▁▁▁▁▁▁▁▁"
    fi
    
    echo "{\"text\": \"$bars\", \"class\": \"$class\", \"tooltip\": \"Audio Visualizer\"}"
else
    # Default when no data
    echo "{\"text\": \"▁▁▁▁▁▁▁▁\", \"class\": \"cava-idle\", \"tooltip\": \"Audio Visualizer\"}"
fi