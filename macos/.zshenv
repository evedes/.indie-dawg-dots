# macOS Environment Variables

# Homebrew (must come first)
export PATH="/opt/homebrew/bin:$PATH"
export XDG_DATA_DIRS="/opt/homebrew/share${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"

# Tools
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.claude/local:$PATH"

# PNPM
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# PostgreSQL
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Editor
export EDITOR="nvim"
export VISUAL="$EDITOR"
export NVIM_APPNAME="nvim"

# Ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# Starship
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
