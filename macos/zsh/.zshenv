# macOS Environment Variables
export ZSH_PLATFORM="macos"

# Homebrew (must come first)
[[ -d "/opt/homebrew/bin" ]] && export PATH="/opt/homebrew/bin:$PATH"
[[ -d "/opt/homebrew/share" ]] && export XDG_DATA_DIRS="/opt/homebrew/share${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"

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

# MacTeX
[[ -d "/Library/TeX/texbin" ]] && export PATH="/Library/TeX/texbin:$PATH"

# Editor
export EDITOR="nvim"
export VISUAL="$EDITOR"
export NVIM_APPNAME="nvim"

# Ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# Starship
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"
