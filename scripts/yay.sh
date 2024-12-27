#!/bin/bash

install_yay() {
  log_info "** YAY **"
  git clone https://aur.archlinux.org/yay.git >/dev/null 2>&1 &
  spinner $!
  wait $!
  cd yay
  log_info " - Installing yay..."
  makepkg -si | sudo --stdin pacman -U --noconfirm *.pkg.tar.zst >/dev/null 2>&1 &
  spinner $!
  wait $!
  cd ..
  rm -rf yay
  log_info " - Yay has been successfully installed!"
}

uninstall_yay() {
  log_info "** YAY **"
  log_info " - Uninstalling yay..."
  sudo pacman -Rns --noconfirm yay >/dev/null 2>&1 &
  spinner $!
  wait $!
  rm -rf ~/.cache/yay
  log_info " - Yay has been successfully uninstalled!"
}
