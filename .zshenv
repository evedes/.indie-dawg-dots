# CARGO
export PATH="$HOME/.cargo/bin:$PATH"

# PNPM
export PNPM_HOME="/Users/edo/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# FNM
eval "$(fnm env --use-on-cd)"

# RUBY
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"

# PSQL
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

# NEOVIM
export EDITOR="$(which nvim)"
export VISUAL="$EDITOR"
export NVIM_APPNAME="nvim"

# RIPGREP
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

## VIRT MANAGER
export XDG_DATA_DIRS=/opt/homebrew/share:$XDG_DATA_DIRS
