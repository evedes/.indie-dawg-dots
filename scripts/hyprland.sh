#!/usr/bin/env bash

install_hyprland() {
  log_info "** HYPRLAND **"
  install_pacman_package hyprland
  rm -rf "$HOME/.config/hypr"
  ln -sf "$(pwd)/templates/hypr" "$HOME/.config/"
  log_info " - Added hyprland symlink"
}

uninstall_hyprland() {
  log_info "** HYPRLAND **"
  uninstall_pacman_package hyprland
  rm -rf "$HOME/.config/hypr"
  log_info " - Removed hyprland symlink"
}
