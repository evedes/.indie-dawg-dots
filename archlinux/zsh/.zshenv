# Arch Linux Environment Variables
export ZSH_PLATFORM="linux"

# Tools
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# PNPM
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Editor
export EDITOR="nvim"
export VISUAL="$EDITOR"
export NVIM_APPNAME="nvim"

# Ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# Starship
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
