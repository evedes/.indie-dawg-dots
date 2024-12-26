#!/usr/bin/env bash

install_waybar() {
  log_info "** WAYBAR **"
  install_package waybar
  ln -sf "$(pwd)/templates/waybar" "$HOME/.config/"
  log_info " - Added waybar symlink"
}

remove_waybar() {
  log_info "** WAYBAR **"
  uninstall_package waybar
  rm -rf "$HOME/.config/waybar"
  log_info " - Removed waybar symlink"
}
