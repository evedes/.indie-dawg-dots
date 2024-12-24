get_privileges() {
  # At the start of your script
  sudo -v

  # Keep sudo timestamp fresh in the background
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &
}
