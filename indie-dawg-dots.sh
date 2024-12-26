#!/usr/bin/env bash

source "scripts/utils.sh"
source "scripts/os.sh"
source "scripts/gitconfig.sh"
source "scripts/kitty.sh"
source "scripts/tmux.sh"
source "scripts/privileges.sh"
source "scripts/arch_system.sh"

install_dotfiles() {
  clear

  # TEMP FOLDERS
  create_temp_folders

  # PRIVILEGES
  log_info "Getting root privileges.."
  get_privileges

  clear

  log_info "The Indie Dawg Dotfiles - Install Script"
  log_section_separator
  # GIT
  generate_gitconfig

  # OS SPECIFIC
  #
  local os=$(detect_os)
  case "$os" in
  arch)
    log_info "** ARCH SPECIFIC CONFIG **"
    log_section_separator

    # SYSTEM
    log_info "** SYSTEM **"
    log_section_separator
    set_hostname

    log_section_separator

    # PACKAGES
    install_kitty
    install_tmux
    log_section_separator
    ;;
  macos)
    log_info "** MACOS SPECIFIC CONIG **"
    ;;
  esac
}

uninstall_dotfiles() {
  clear

  # TEMP FOLDERS
  remove_temp_folders

  # PRIVILEGES
  log_info "Getting root privileges.."
  get_privileges

  clear

  log_info "The Indie Dawg Dotfiles - Uninstall Script"
  log_section_separator

  # GIT
  remove_gitconfig # GIT

  # OS SPECIFIC
  #
  local os=$(detect_os)
  case "$os" in
  arch)
    log_info "** ARCH SPECIFIC CONFIG **"
    log_section_separator

    # SYSTEM
    log_info "** SYSTEM **"
    log_section_separator

    unset_hostname

    log_section_separator

    # PACKAGES
    remove_tmux
    remove_kitty
    log_section_separator
    ;;
  macos)
    log_info "** MACOS SPECIFIC CONIG **"
    ;;
  esac
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
      log_info " - Finished uninstalling dotfiles"
      log_operation_separator
      # INSTALL
      install_dotfiles
      log_info " - Finished installing dotfiles"
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
