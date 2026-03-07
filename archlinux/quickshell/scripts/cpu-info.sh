#!/bin/bash

# Snapshot per-core stats
declare -A idle1 total1
while read -r line; do
    parts=($line)
    name=${parts[0]}
    [[ $name == cpu[0-9]* ]] || continue
    user=${parts[1]}; nice=${parts[2]}; sys=${parts[3]}; idle=${parts[4]}
    iow=${parts[5]}; irq=${parts[6]}; sirq=${parts[7]}; steal=${parts[8]}
    idle1[$name]=$((idle + iow))
    total1[$name]=$((user + nice + sys + idle + iow + irq + sirq + steal))
done < /proc/stat

sleep 1

# Second snapshot + output per-core usage
while read -r line; do
    parts=($line)
    name=${parts[0]}
    [[ $name == cpu[0-9]* ]] || continue
    user=${parts[1]}; nice=${parts[2]}; sys=${parts[3]}; idle=${parts[4]}
    iow=${parts[5]}; irq=${parts[6]}; sirq=${parts[7]}; steal=${parts[8]}
    ti=$((idle + iow))
    tt=$((user + nice + sys + idle + iow + irq + sirq + steal))
    dt=$((tt - ${total1[$name]}))
    di=$((ti - ${idle1[$name]}))
    if [ $dt -gt 0 ]; then
        pct=$(( (dt - di) * 100 / dt ))
    else
        pct=0
    fi
    core_num=${name#cpu}
    echo "CORE|$core_num|$pct"
done < /proc/stat

# Load averages
read -r l1 l5 l15 _ < /proc/loadavg
echo "LOAD|$l1|$l5|$l15"

# CPU temp (x86_pkg_temp or first available)
temp=""
for z in /sys/class/thermal/thermal_zone*; do
    t=$(cat "$z/type" 2>/dev/null)
    if [ "$t" = "x86_pkg_temp" ] || [ "$t" = "coretemp" ]; then
        raw=$(cat "$z/temp" 2>/dev/null)
        temp=$((raw / 1000))
        break
    fi
done
if [ -z "$temp" ]; then
    raw=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null)
    [ -n "$raw" ] && temp=$((raw / 1000))
fi
echo "TEMP|${temp:-?}"

# Uptime
awk '{d=int($1/86400); h=int(($1%86400)/3600); m=int(($1%3600)/60); printf "UPTIME|%dd %dh %dm\n", d, h, m}' /proc/uptime

# Top 5 processes
ps -eo pcpu,comm --no-headers --sort=-pcpu | head -5 | awk '{printf "PROC|%s|%.0f\n", $2, $1}'
