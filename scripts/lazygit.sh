#!/usr/bin/env bash

install_lazygit() {
  log_info "** LAZYGIT **"
  install_pacman_package lazygit
  ln -sf "$(pwd)/templates/lazygit" "$HOME/.config/"
  log_info " - Added lazygit symlink"
}

uninstall_lazygit() {
  log_info "** LAZYGIT **"
  uninstall_pacman_package lazygit
  rm -rf "$HOME/.config/lazygit"
  log_info " - Removed lazygit symlink"
}
