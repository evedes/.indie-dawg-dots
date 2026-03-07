#!/bin/bash

# RAM
free -m | awk '/Mem:/{printf "RAM|%d|%d|%.0f\n", $3, $2, $3/$2*100}'

# Disk (root partition)
df -h / | awk 'NR==2{gsub(/%/,"",$5); printf "DISK|%s|%s|%s\n", $3, $2, $5}'

# GPU (Intel)
gpu_name=$(lspci | grep -i vga | sed 's/.*: //' | cut -c1-30)
cur_freq=$(cat /sys/class/drm/card1/gt_cur_freq_mhz 2>/dev/null)
max_freq=$(cat /sys/class/drm/card1/gt_max_freq_mhz 2>/dev/null)
if [ -n "$cur_freq" ] && [ -n "$max_freq" ] && [ "$max_freq" -gt 0 ]; then
    gpu_pct=$(( cur_freq * 100 / max_freq ))
    echo "GPU|${gpu_name}|${cur_freq}|${max_freq}|${gpu_pct}"
else
    echo "GPU|${gpu_name:-Unknown}|0|0|0"
fi
