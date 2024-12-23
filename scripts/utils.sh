#!/usr/bin/env bash

declare -r red='\033[0;31m'
declare -r green='\033[0;32m'
declare -r yellow='\033[0;33m'
declare -r nocolor='\033[0m'

log_warning() {
  printf "${yellow}[warning] > ${nocolor} $1\n" >&2
}

log_error() {
  printf "${red}[error]   > ${nocolor} $1\n" >&2

}
log_info() {
  printf "${green}[info]    > ${nocolor} $1\n" >&2
}
