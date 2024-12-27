#!/usr/bin/env bash

install_waybar() {
  log_info "** WAYBAR **"
  install_pacman_package waybar
  ln -sf "$(pwd)/templates/waybar" "$HOME/.config/"
  log_info " - Added waybar symlink"
}

uninstall_waybar() {
  log_info "** WAYBAR **"
  uninstall_pacman_package waybar
  rm -rf "$HOME/.config/waybar"
  log_info " - Removed waybar symlink"
}
