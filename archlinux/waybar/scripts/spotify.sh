#!/bin/bash

# Get player status
player_status=$(playerctl -p spotify status 2>/dev/null)

if [ "$player_status" = "Playing" ] || [ "$player_status" = "Paused" ]; then
    # Get metadata
    artist=$(playerctl -p spotify metadata artist 2>/dev/null | sed 's/"/\\"/g')
    title=$(playerctl -p spotify metadata title 2>/dev/null | sed 's/"/\\"/g')
    album=$(playerctl -p spotify metadata album 2>/dev/null | sed 's/"/\\"/g')
    
    # Truncate long text
    max_len=30
    if [ ${#title} -gt $max_len ]; then
        title="${title:0:$max_len}..."
    fi
    if [ ${#artist} -gt $max_len ]; then
        artist="${artist:0:$max_len}..."
    fi
    
    # Get playback position and duration
    position=$(playerctl -p spotify position 2>/dev/null | cut -d'.' -f1)
    duration=$(playerctl -p spotify metadata mpris:length 2>/dev/null)
    
    if [ -n "$duration" ]; then
        duration=$((duration / 1000000))
    fi
    
    # Format time
    format_time() {
        local seconds=$1
        printf "%d:%02d" $((seconds / 60)) $((seconds % 60))
    }
    
    if [ -n "$position" ] && [ -n "$duration" ]; then
        pos_formatted=$(format_time "$position")
        dur_formatted=$(format_time "$duration")
        time_info=" [$pos_formatted/$dur_formatted]"
    else
        time_info=""
    fi
    
    # Icons based on status
    if [ "$player_status" = "Playing" ]; then
        status_icon=""
        playing="true"
    else
        status_icon=""
        playing="false"
    fi
    
    # Only show when playing (not when paused)
    if [ "$player_status" = "Playing" ]; then
        # Output JSON
        echo "{\"text\": \"$status_icon $artist - $title$time_info\", \"tooltip\": \"$title\\nby $artist\\n$album\", \"class\": \"spotify-$player_status\", \"alt\": \"$player_status\", \"playing\": $playing}"
    else
        # Return empty JSON to hide the module when paused or stopped
        echo ""
    fi
else
    # Return empty to hide the module when spotify is not running
    echo ""
fi