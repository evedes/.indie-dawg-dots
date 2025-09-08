#!/bin/bash

# Get CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print int(100 - $1)}' 2>/dev/null || echo "0")
if [ -z "$CPU_USAGE" ]; then
    CPU_USAGE=$(mpstat 1 1 | awk '/Average:/ {print int(100-$NF)}' 2>/dev/null || echo "0")
fi

# Get memory info
MEM_INFO=$(free -h | awk '/^Mem:/ {print $3 " / " $2}')
MEM_PERCENT=$(free | awk '/^Mem:/ {printf "%.1f", $3/$2 * 100}')

# Get disk info
DISK_ROOT=$(df -h / | awk 'NR==2 {print $3 " / " $2 " (" $5 ")"}')
DISK_HOME=$(df -h /home | awk 'NR==2 {print $3 " / " $2 " (" $5 ")"}' 2>/dev/null || echo "N/A")

# Get CPU model
CPU_MODEL=$(lscpu | grep "Model name" | cut -d: -f2 | xargs)

# Get uptime
UPTIME=$(uptime -p | sed 's/up //')

# Get load average
LOAD=$(uptime | awk -F'load average:' '{print $2}' | xargs)

# Create tooltip text
TOOLTIP="<b>System Resources</b>\n"
TOOLTIP+="\n<b>CPU:</b> ${CPU_USAGE}%\n"
TOOLTIP+="${CPU_MODEL}\n"
TOOLTIP+="\n<b>Memory:</b> ${MEM_INFO} (${MEM_PERCENT}%)\n"
TOOLTIP+="\n<b>Disk Root:</b> ${DISK_ROOT}\n"
TOOLTIP+="<b>Disk Home:</b> ${DISK_HOME}\n"
TOOLTIP+="\n<b>Uptime:</b> ${UPTIME}\n"
TOOLTIP+="<b>Load:</b>${LOAD}"

# Output JSON
echo "{\"text\":\"󰍛 ${CPU_USAGE}%\", \"tooltip\":\"${TOOLTIP}\", \"class\":\"system-stats\"}"