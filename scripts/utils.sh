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
    log_info "Creating generated directory..."
    mkdir -p "./generated"
  fi

  if [ ! -d "./logs" ]; then
    log_info "Creating logs directory"
    mkdir -p "./logs"
    log_info "Creating operations.log file"
    touch "./logs/operations.log"
  fi
}

remove_temp_folders() {
  log_info "** TEMP FOLDERS **"
  if [ -d "generated" ]; then
    log_info "Removing generated directory..."
    rm -rf "generated"
    return 0
  fi
}

remove_operations_log() {
  log_info "** OPERATIONS LOG **"
  if [ -d "logs" ]; then
    log_info "Resetting logs..."
    rm -rf "logs"
    return 0
  fi
}

function install_package() {
  local package=$1
  log_info "Installing %s..." "$package"
  sudo pacman -S --noconfirm "$package" >/dev/null 2>&1 &
  log_info "Installed $package ✓"
}

function uninstall_package() {
  local package=$1
  log_info "Uninstalling %s..." "$package"
  sudo pacman -R --noconfirm "$package" >/dev/null 2>&1 &
  log_info "Uninstalled $package ✓"
}
