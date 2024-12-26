#!/usr/bin/env bash

set_hostname() {
  log_info "** HOSTNAME **"
  if [ -z "$HOSTNAME" ]; then
    echo "Error: HOSTNAME not defined in config.sh" >&2
    exit 1
  fi

  echo "$HOSTNAME" | sudo tee /etc/hostname >/dev/null
  echo "$HOSTNAME" | sudo tee /proc/sys/kernel/hostname >/dev/null

  log_info " - Hostname has been set to $HOSTNAME successfully"
}

unset_hostname() {
  log_info "** HOSTNAME **"

  echo "" | sudo tee /etc/hostname >/dev/null
  echo "" | sudo tee /proc/sys/kernel/hostname >/dev/null

  log_info " - Hostname has been unset successfully"
}
