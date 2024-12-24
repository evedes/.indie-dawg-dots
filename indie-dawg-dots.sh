#!/usr/bin/env bash

source "scripts/utils.sh"
source "scripts/os.sh"
source "scripts/gitconfig.sh"

install_dotfiles() {
  clear
  log_info "The Indie Dawg Dotfiles - Install Script"
  log_section_separator

  # TEMP FOLDERS
  create_temp_folders
  # GIT
  generate_gitconfig

  # OS SPECIFIC
  #
  local os=$(detect_os)
  case "$os" in
  arch)
    log_section_separator
    log_info "** ARCH SPECIFIC CONFIG **"

    ;;
  macos)
    log_info "** MACOS SPECIFIC CONIG **"
    ;;
  esac
}

uninstall_dotfiles() {
  clear
  log_info "The Indie Dawg Dotfiles - Uninstall Script"
  log_section_separator

  # TEMP FOLDERS
  remove_temp_folders
  # GIT
  remove_gitconfig # GIT
  #
  # OS SPECIFIC
}

main() {
  if [ "$#" -gt 0 ]; then
    case "$1" in
    "--help" | "-h")
      echo "Usage: $0 [option]"
      echo "Options:"
      echo "  install     Install dotfiles into user's home directory"
      echo "  uninstall   Remove dotfiles from user's home directory"
      echo "  reinstall   Reinstall dotfiles from user's home directory"
      echo "  logs        Tail logs"
      echo "  resetlogs   Reset logs directory"
      echo "  --help, -h  Show this help message"
      exit 0
      ;;
    "install")
      install_dotfiles
      ;;
    "uninstall")
      uninstall_dotfiles
      ;;
    "reinstall")
      # UNINSTALL
      uninstall_dotfiles
      log_info "Finished Uninstalling dotfiles"
      log_operation_separator
      # INSTALL
      install_dotfiles
      log_info "Finished Installing dotfiles"
      log_operation_separator
      ;;
    "logs")
      tail -f "logs/operations.log"
      ;;
    "resetlogs")
      remove_operations_log
      ;;
    *)
      log_error "Unknown option: $1"
      echo "Use --help to see available options"
      exit 1
      ;;
    esac
  else
    log_error "No option provided"
    echo "Use --help to see available options"
    exit 1
  fi
}

main "$@"
