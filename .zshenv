# Platform detection for environment variables
export ZSH_PLATFORM="$(uname -s | tr '[:upper:]' '[:lower:]')"
case "$ZSH_PLATFORM" in
    darwin) export ZSH_PLATFORM="macos" ;;
    linux)  export ZSH_PLATFORM="linux" ;;
    *)      export ZSH_PLATFORM="unknown" ;;
esac

# Cross-platform tools
export PATH="$HOME/.cargo/bin:$PATH"

# local binaries
export PATH="$HOME/.local/bin:$PATH"

# PNPM (platform-specific home)
if [[ "$ZSH_PLATFORM" == "macos" ]]; then
    export PNPM_HOME="$HOME/Library/pnpm"
else
    export PNPM_HOME="$HOME/.local/share/pnpm"
fi
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# NEOVIM
export EDITOR="nvim"
export VISUAL="$EDITOR"
export NVIM_APPNAME="nvim"

# RIPGREP
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# STARSHIP
export STARSHIP_CONFIG="$HOME/.indie-dawg-dots/.config/starship/starship.toml"

# Platform-specific environment setup
if [[ "$ZSH_PLATFORM" == "macos" ]]; then
    # macOS specific paths (Homebrew should come first)
    [[ -d "/opt/homebrew/bin" ]] && export PATH="/opt/homebrew/bin:$PATH"
    [[ -d "/opt/homebrew/share" ]] && export XDG_DATA_DIRS="/opt/homebrew/share${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
elif [[ "$ZSH_PLATFORM" == "linux" ]]; then
    # Linux specific paths
    [[ -d "/usr/local/bin" ]] && export PATH="/usr/local/bin:$PATH"
fi

# PSQL
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
