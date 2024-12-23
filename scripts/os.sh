#!/usr/bin/env bash

source "./utils.sh"

detect_os() {
  local os
  case "$(uname -s)" in
  Linux*)
    if [ -f "/etc/arch-release" ]; then
      os="arch"
    else
      os="linux"
    fi
    ;;
  Darwin*)
    os="macos"
    ;;
  *)
    log_error "Unsupported operating system"
    exit 1
    ;;
  esac

  log_info "Detected operating system: ${yellow}${os}"
  printf "%s" "$os"
}
