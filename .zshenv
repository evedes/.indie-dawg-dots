# Platform detection for environment variables
case "$(uname -s)" in
    Darwin) ENV_PLATFORM="macos" ;;
    Linux)  ENV_PLATFORM="linux" ;;
    *)      ENV_PLATFORM="unknown" ;;
esac

# Cross-platform tools
export PATH="$HOME/.cargo/bin:$PATH"

# Fnm
export PATH="$HOME/.local/share/fnm:$PATH"

# PNPM (platform-specific home)
if [[ "$ENV_PLATFORM" == "macos" ]]; then
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

# Platform-specific environment setup
if [[ "$ENV_PLATFORM" == "macos" ]]; then
    # macOS specific paths (Homebrew should come first)
    [[ -d "/opt/homebrew/bin" ]] && export PATH="/opt/homebrew/bin:$PATH"
    [[ -d "/opt/homebrew/opt/postgresql@15/bin" ]] && export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
    [[ -d "/opt/homebrew/share" ]] && export XDG_DATA_DIRS="/opt/homebrew/share${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
elif [[ "$ENV_PLATFORM" == "linux" ]]; then
    # Linux specific paths
    [[ -d "/usr/local/bin" ]] && export PATH="/usr/local/bin:$PATH"
    [[ -d "/usr/lib/postgresql/15/bin" ]] && export PATH="/usr/lib/postgresql/15/bin:$PATH"
    [[ -d "/usr/lib/postgresql/17/bin" ]] && export PATH="/usr/lib/postgresql/17/bin:$PATH"
fi

# Ruby
if [[ -d "$HOME/.rbenv/bin" ]]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
fi
