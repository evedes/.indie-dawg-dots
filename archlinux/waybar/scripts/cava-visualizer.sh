#!/bin/bash

# Create a named pipe for cava if it doesn't exist
PIPE="/tmp/cava_fifo"
if [ ! -p "$PIPE" ]; then
    mkfifo "$PIPE"
fi

# Kill any existing cava process
pkill -f "cava -p /tmp/cava_waybar.conf" 2>/dev/null

# Create cava config with better sensitivity and more bars
cat > /tmp/cava_waybar.conf << EOF
[general]
framerate = 60
bars = 12
bar_width = 1
bar_spacing = 0

[output]
method = raw
raw_target = /tmp/cava_fifo
data_format = ascii
ascii_max_range = 20
mono_option = average

[input]
method = pulse
source = auto

[smoothing]
integral = 77
monstercat = 1
waves = 0
gravity = 200
ignore = 0

[eq]
1 = 1
2 = 1
3 = 1
4 = 1
5 = 1
EOF

# Start cava in background
cava -p /tmp/cava_waybar.conf &>/dev/null &
sleep 0.5

# Continuously read from pipe and output JSON
while true; do
    if read -t 0.016 line < "$PIPE"; then
        # More visible bar characters with full range
        bars=""
        bar_chars=(" " "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")

        # Process the line - handle semicolon-separated values
        IFS=';' read -ra VALUES <<< "$line"

        for val in "${VALUES[@]}"; do
            # Skip empty values
            if [ -z "$val" ]; then continue; fi

            # Convert value to number and scale it
            if [[ "$val" =~ ^[0-9]+$ ]]; then
                # Remove leading zeros to avoid octal interpretation
                val=$((10#$val))
                # Scale from 0-20 to 0-8
                scaled=$(( (val * 8) / 20 ))
                if [ $scaled -gt 8 ]; then scaled=8; fi
                if [ $scaled -lt 0 ]; then scaled=0; fi
                bars="${bars}${bar_chars[$scaled]}"
            fi
        done

        # Pad or truncate to 12 bars
        while [ ${#bars} -lt 12 ]; do
            bars="${bars} "
        done
        bars="${bars:0:12}"

        # Check if any audio is playing
        if pactl list sink-inputs 2>/dev/null | grep -q "State: RUNNING"; then
            class="cava-active"
        else
            class="cava-idle"
            bars="            "
        fi

        echo "{\"text\": \"$bars\", \"class\": \"$class\", \"tooltip\": \"Audio Visualizer\"}"
    else
        # Default when no data
        echo "{\"text\": \"            \", \"class\": \"cava-idle\", \"tooltip\": \"Audio Visualizer\"}"
    fi
done