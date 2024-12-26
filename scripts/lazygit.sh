#!/usr/bin/env bash

install_lazygit() {
  log_info "** lazygit **"
  install_package lazygit
  ln -sf "$(pwd)/templates/lazygit" "$HOME/.config/"
  log_info " - Added lazygit symlink"
}

remove_lazygit() {
  log_info "** lazygit **"
  uninstall_package lazygit
  rm -rf "$HOME/.config/lazygit"
  log_info " - Removed lazygit symlink"
}
