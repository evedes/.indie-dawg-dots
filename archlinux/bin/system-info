#!/bin/bash

# CPU info
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
cpu_temp=$(sensors | grep 'Package id 0:' | awk '{print $4}' | sed 's/+//g' 2>/dev/null || echo "N/A")
load=$(uptime | awk -F'load average: ' '{print $2}')

# Memory info
mem_info=$(free -h | grep "^Mem")
mem_used=$(echo $mem_info | awk '{print $3}')
mem_total=$(echo $mem_info | awk '{print $2}')
mem_percent=$(free | grep "^Mem" | awk '{printf "%.1f", $3/$2 * 100}')

# Disk info
disk_root=$(df -h / | tail -1 | awk '{print $3"/"$2" ("$5")"}')
disk_home=$(df -h /home | tail -1 | awk '{print $3"/"$2" ("$5")"}')

# Format as JSON for waybar
echo "{\"text\":\"󰍛\", \"tooltip\":\"System Information\n\nCPU: ${cpu_usage}% | Temp: ${cpu_temp}\nLoad: ${load}\n\nMemory: ${mem_used}/${mem_total} (${mem_percent}%)\n\nDisk /: ${disk_root}\nDisk /home: ${disk_home}\"}"
