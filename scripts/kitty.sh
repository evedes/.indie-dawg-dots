install_kitty() {
  log_info "** KITTY **"
  install_package kitty
  ln -s "templates/kitty" "$HOME/.config/kitty"
}

remove_kitty() {
  log_info "** KITTY **"
  uninstall_package kitty
  rm -rf "$HOME/.config/kitty"
}
