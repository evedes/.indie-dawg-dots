
# macOS Environment Variables
export ZSH_PLATFORM="macos"

# Keep PATH entries unique (nested shells, e.g. inside tmux, re-source this file)
typeset -U path PATH

# Homebrew (must come first) — sets PATH, MANPATH, INFOPATH and HOMEBREW_* once
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
[[ -d "/opt/homebrew/share" ]] && export XDG_DATA_DIRS="/opt/homebrew/share${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"

# Tools (claude, uv tools, cursor-agent, …)
export PATH="$HOME/.local/bin:$PATH"

# PNPM
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# PostgreSQL
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Editor
export EDITOR="nvim"
export VISUAL="$EDITOR"

# Ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# Starship
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
