#!/usr/bin/env bash

# Web search launcher for rofi
# Opens searches in default browser

declare -A search_engines=(
    ["󰊭  Google"]="https://google.com/search?q="
    ["󰇥  DuckDuckGo"]="https://duckduckgo.com/?q="
    ["  GitHub"]="https://github.com/search?q="
    ["󰗃  YouTube"]="https://youtube.com/results?search_query="
    ["󰋗  Wikipedia"]="https://wikipedia.org/w/index.php?search="
    ["󰚩  Stack Overflow"]="https://stackoverflow.com/search?q="
    ["󱚌  Arch Wiki"]="https://wiki.archlinux.org/index.php?search="
    ["󰢚  Reddit"]="https://reddit.com/search/?q="
)

# First, select search engine
engine=$(printf '%s\n' "${!search_engines[@]}" | rofi -dmenu -theme ~/.config/rofi/arch-theme.rasi -p "Search Engine")

[[ -z "$engine" ]] && exit 0

# Then get search query
query=$(rofi -dmenu -theme ~/.config/rofi/arch-theme.rasi -p "Search Query" -lines 0)

[[ -z "$query" ]] && exit 0

# URL encode the query
encoded_query=$(echo "$query" | sed 's/ /+/g' | sed 's/&/%26/g')

# Open in default browser
xdg-open "${search_engines[$engine]}${encoded_query}" &