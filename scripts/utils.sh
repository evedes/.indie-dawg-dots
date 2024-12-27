#!/usr/bin/env bash

declare -r red='\033[0;31m'
declare -r green='\033[0;32m'
declare -r yellow='\033[0;33m'
declare -r nocolor='\033[0m'

declare -r LOG_FILE="logs/operations.log"
declare -r timestamp=$(date '+%Y-%m-%d %H:%M:%S')

log_warning() {
  printf "${yellow}[warning] > ${nocolor} $1\n" >&2
  printf "${timestamp} [warning] > $1\n" >>"${LOG_FILE}"
}

log_error() {
  printf "${red}[error]   > ${nocolor} $1\n" >&2
  printf "${timestamp} [error]   > $1\n" >>"${LOG_FILE}"

}

log_info() {
  printf "${green}[info]    > ${nocolor} $1\n" >&2
  printf "${timestamp} [info]    > $1\n" >>"${LOG_FILE}"
}

log_section_separator() {
  log_info "--------------------------------------------------------------------"
}

log_operation_separator() {
  log_info "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}

create_temp_folders() {
  log_info "** TEMP FOLDERS **"

  if [ ! -d "./generated" ]; then
    log_info " - Creating generated directory..."
    mkdir -p "./generated"
  fi

  if [ ! -d "./logs" ]; then
    log_info " - Creating logs directory"
    mkdir -p "./logs"
    log_info " - Creating operations.log file"
    touch "./logs/operations.log"
  fi
}

remove_temp_folders() {
  log_info "** TEMP FOLDERS **"
  if [ -d "generated" ]; then
    log_info " - Removing generated directory..."
    rm -rf "generated"
    return 0
  fi
  if [ -d "logs" ]; then
    log_info " - Removing logs directory..."
    rm -rf "logs"
    return 0
  fi
}

remove_operations_log() {
  log_info "** OPERATIONS LOG **"
  if [ -d "logs" ]; then
    log_info " - Resetting logs..."
    rm -rf "logs"
    return 0
  fi
}

function install_pacman_package() {
  local package=$1
  local exit_code

  log_info " - Installing $package"

  if ! sudo pacman -S --noconfirm "$package" >/dev/null 2>&1; then
    exit_code=$?
    log_error " - Failed to install $package (exit code: $exit_code)"
    return $exit_code
  fi

  log_info " - Installed $package"
  return 0
}
function uninstall_pacman_package() {
  local package=$1
  local max_attempts=3
  local attempt=1

  while [ $attempt -le $max_attempts ]; do
    log_info " - Uninstalling $package (attempt $attempt/$max_attempts)"

    if sudo pacman -Rns --noconfirm "$package" >/dev/null 2>&1; then
      log_info " - Uninstalled $package"
      return 0
    fi

    exit_code=$?
    log_warn "Attempt $attempt failed (exit code: $exit_code)"
    ((attempt++))

    [ $attempt -le $max_attempts ] && sleep 3
  done

  log_error " - Failed to uninstall $package after $max_attempts attempts"
  return $exit_code
}

spinner() {
  local pid=$1
  local delay=0.15
  local dots=1
  while ps -p $pid >/dev/null; do
    printf "\r%s" " - Installing... ${dots:+${dots/#/.}}"
    if [ $dots -lt 3 ]; then
      ((dots++))
    else
      dots=1
    fi
    sleep $delay
  done
  printf "\r%*s\r\033[A" "$(tput cols)" "" # Clear the line and move cursor up
}
