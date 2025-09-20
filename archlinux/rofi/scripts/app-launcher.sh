#!/usr/bin/env bash

# Simple application launcher with 2 column layout
rofi -show drun \
    -theme ~/.config/rofi/black-theme.rasi \
    -matching fuzzy \
    -show-icons \
    -display-drun "Apps" \
    -columns 2