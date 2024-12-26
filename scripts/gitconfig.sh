#!/usr/bin/env bash

generate_gitconfig() {
  log_info "** GIT CONFIG **"
  log_info " - Generating .gitconfig from template..."

  # Check if config.sh exists
  if [ ! -f "config.sh" ]; then
    log_error " - config.sh not found. Please create it first."
    return 1
  fi

  if [ -f "$HOME/.gitconfig" ]; then
    log_warning " - .gitconfig file already exists"
    return 1
  fi

  # Source the config file
  source "config.sh"

  # Check if template exists
  if [ ! -f "templates/gitconfig/gitconfig.template" ]; then
    log_error "templates/gitconfig/gitconfig.template not found"
    return 1
  fi

  cat "templates/gitconfig/gitconfig.template" |
    sed "s/{{GIT_NAME}}/$GIT_NAME/g" |
    sed "s/{{GIT_EMAIL}}/$GIT_EMAIL/g" |
    sed "s/{{GIT_EDITOR}}/$GIT_EDITOR/g" >"generated/gitconfig"

  ln -sf "$(pwd)/generated/gitconfig" "$HOME/.gitconfig"

  log_info " - Successfully generated .gitconfig"
}

remove_gitconfig() {
  log_info "** GIT CONFIG **"

  if [ -e "$HOME/.gitconfig" ] || [ -L "$HOME/.gitconfig" ]; then
    log_info " - Found .gitconfig in home directory"
    rm -f "$HOME/.gitconfig"
    log_info " - Removed .gitconfig from home directory"
  else
    log_info " - No .gitconfig found in home directory"
  fi

}
