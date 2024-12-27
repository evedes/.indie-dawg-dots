#!/usr/bin/env bash

install_kitty() {
  log_info "** KITTY **"
  install_pacman_package kitty
  ln -sf "$(pwd)/templates/kitty" "$HOME/.config/"
  log_info " - Added kitty symlink"
}

uninstall_kitty() {
  log_info "** KITTY **"
  uninstall_pacman_package kitty
  rm -rf "$HOME/.config/kitty"
  log_info " - Removed kitty symlink"
}
