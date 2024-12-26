#!/usr/bin/env bash

detect_os() {
  log_section_separator
  log_info "** OS Detection **"
  log_info " - Detecting operating system"
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
    log_error " - Unsupported operating system"
    exit 1
    ;;
  esac

  log_info " - Detected operating system: ${os}"
  local os
  printf "%s" "$os"
}
