#!/usr/bin/env bash

install_kitty() {
  log_info "** KITTY **"
  install_package kitty
  ln -sf "$(pwd)/templates/kitty" "$HOME/.config/"
  log_info " - Added kitty symlink"
}

remove_kitty() {
  log_info "** KITTY **"
  uninstall_package kitty
  rm -rf "$HOME/.config/kitty"
  log_info " - Removed kitty symlink"
}
