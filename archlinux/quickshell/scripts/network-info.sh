#!/bin/bash

fmt_speed() {
    local b=$1
    if [ "$b" -ge 1048576 ]; then
        awk "BEGIN{printf \"%.1fMB/s\", $b/1048576}"
    elif [ "$b" -ge 1024 ]; then
        awk "BEGIN{printf \"%.1fKB/s\", $b/1024}"
    else
        echo "${b}B/s"
    fi
}

devices=$(ip -o link show | awk -F': ' '{print $2}' | grep -v '^lo$')

declare -A rx1 tx1
for dev in $devices; do
    rx1[$dev]=$(cat /sys/class/net/$dev/statistics/rx_bytes 2>/dev/null || echo 0)
    tx1[$dev]=$(cat /sys/class/net/$dev/statistics/tx_bytes 2>/dev/null || echo 0)
done

sleep 1

for dev in $devices; do
    rx2=$(cat /sys/class/net/$dev/statistics/rx_bytes 2>/dev/null || echo 0)
    tx2=$(cat /sys/class/net/$dev/statistics/tx_bytes 2>/dev/null || echo 0)
    state=$(ip -o link show "$dev" | grep -oP '(?<=state )\S+')
    addr=$(ip -4 -o addr show dev "$dev" 2>/dev/null | awk '{print $4}' | head -1)
    rx_speed=$(( rx2 - ${rx1[$dev]} ))
    tx_speed=$(( tx2 - ${tx1[$dev]} ))

    if [ -n "$addr" ]; then
        if ping -I "$dev" -c 1 -W 1 8.8.8.8 >/dev/null 2>&1; then p="OK"; else p="NOK"; fi
    else
        p="--"
    fi

    dl=$(fmt_speed $rx_speed)
    ul=$(fmt_speed $tx_speed)
    echo "$dev|$addr|$p|$state|$dl|$ul"
done
