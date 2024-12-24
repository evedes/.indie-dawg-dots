install_kitty() {
  log_info "** KITTY **"
  install_package kitty
  ln -s "$(pwd)/templates/kitty" "$HOME/.config/"
}

remove_kitty() {
  log_info "** KITTY **"
  uninstall_package kitty
  log_info "Removed symlink"
  rm -rf "$HOME/.config/kitty"
}
