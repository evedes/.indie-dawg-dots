#!/usr/bin/env bash

# WiFi manager for rofi
# Requires: nmcli (NetworkManager)

# Get list of available WiFi networks
get_networks() {
    nmcli -f SSID,SECURITY,BARS device wifi list | tail -n +2 | \
        sed 's/  */ /g' | \
        awk '{
            bars = $NF
            security = $(NF-1)
            ssid = $1
            for(i=2; i<NF-1; i++) ssid = ssid " " $i
            
            # Convert bars to icon
            if (bars ~ /▂___/) icon = "󰤟"
            else if (bars ~ /▂▄__/) icon = "󰤢"
            else if (bars ~ /▂▄▆_/) icon = "󰤥"
            else icon = "󰤨"
            
            # Add lock icon for secured networks
            if (security != "--") lock = "󰌾"
            else lock = ""
            
            printf "%s %s %s %s\n", icon, lock, ssid, security
        }'
}

# Show current connection
current=$(nmcli -t -f NAME connection show --active | head -n1)
if [[ -n "$current" ]]; then
    options="󰖪  Disconnect from $current"
else
    options="󰤮  No active connection"
fi

# Add available networks
options="$options
$(get_networks)"

# Add manual connection option
options="$options
󰜉  Refresh
󰖟  Network Settings"

# Show menu
chosen=$(echo "$options" | rofi -dmenu -theme ~/.config/rofi/arch-theme.rasi -p "WiFi")

# Process selection
case "$chosen" in
    *"Disconnect"*)
        nmcli connection down "$current"
        notify-send "WiFi" "Disconnected from $current"
        ;;
    *"Refresh"*)
        nmcli device wifi rescan
        exec "$0"
        ;;
    *"Network Settings"*)
        nm-connection-editor &
        ;;
    "")
        exit 0
        ;;
    *)
        # Extract SSID from selection
        ssid=$(echo "$chosen" | sed 's/^[^ ]* *[^ ]* *//' | sed 's/ *[^ ]*$//')
        
        # Check if already have a connection for this SSID
        if nmcli connection show "$ssid" &>/dev/null; then
            nmcli connection up "$ssid"
        else
            # Need password for new network
            if echo "$chosen" | grep -q "󰌾"; then
                password=$(rofi -dmenu -password -theme ~/.config/rofi/arch-theme.rasi -p "Password for $ssid")
                [[ -z "$password" ]] && exit 0
                nmcli device wifi connect "$ssid" password "$password"
            else
                nmcli device wifi connect "$ssid"
            fi
        fi
        
        if [[ $? -eq 0 ]]; then
            notify-send "WiFi" "Connected to $ssid"
        else
            notify-send "WiFi" "Failed to connect to $ssid" -u critical
        fi
        ;;
esac