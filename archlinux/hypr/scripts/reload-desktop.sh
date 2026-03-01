#!/bin/bash
killall quickshell 2>/dev/null
killall swww-dameon 2>/dev/null
killall mako 2>/dev/null

sleep 0.2
swww-dameon &
mako &
quickshell &
