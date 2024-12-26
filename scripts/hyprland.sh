#!/usr/bin/env bash

install_hyprland() {
  log_info "** HYPRLAND **"
  install_package hyprland
  ln -s "$(pwd)/templates/hypr" "$HOME/.config/"
  log_info " - Added hyprland symlink"
}

remove_hyprland() {
  log_info "** HYPRLAND **"
  uninstall_package hyprland
  rm -rf "$HOME/.config/hypr"
  log_info " - Removed hyprland symlink"
}
