#!/usr/bin/env bash

install_tmux() {
  log_info "** TMUX **"
  ln -sf "$(pwd)/templates/tmux.conf" "$HOME/.tmux.conf"
  log_info " - Added .tmux.conf symlink"
  # git clone from  https://github.com/tmux-plugins/tpm
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm >/dev/null 2>&1
  log_info " - Added .tmux plugins directory"
  tmux start-server
  tmux new-session -d -s main
  "$HOME/.tmux/plugins/tpm/bin/install_plugins" >/dev/null 2>&1 &
  spinner $!
  wait $!
  tmux source-file ~/.tmux.conf
  log_info " - Installed tmux plugins"
}

uninstall_tmux() {
  log_info "** TMUX **"
  log_info " - Removed .tmux.conf symlink"
  rm -rf "$HOME/.tmux"
  log_info " - Removed .tmux plugins directory"
  tmux kill-server
}
