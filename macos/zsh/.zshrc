# Command existence cache for performance
typeset -gA _cmd_cache
has_cmd() {
    [[ -n "${_cmd_cache[$1]}" ]] && return ${_cmd_cache[$1]}
    command -v "$1" &>/dev/null
    _cmd_cache[$1]=$?
    return ${_cmd_cache[$1]}
}

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Zinit
source "/opt/homebrew/opt/zinit/zinit.zsh"
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit ice wait lucid atload"zicompinit; zicdreplay"
zinit light zsh-users/zsh-completions

# Aliases
source $HOME/.indie-dawg-dots/macos/zsh/.alias
source $HOME/.secret/.alias

# History
HISTFILE=$HOME/.zsh_history
HISTSIZE=5000
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt hist_expire_dups_first
setopt hist_ignore_space
setopt hist_ignore_dups
setopt hist_verify

# Emacs mode
bindkey -e

# FZF
has_cmd fzf && source <(fzf --zsh)

# Starship
has_cmd starship && eval "$(starship init zsh)"

# Mise
has_cmd mise && eval "$(mise activate zsh)"

# Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# bun completions
[ -s "/Users/edo/.bun/_bun" ] && source "/Users/edo/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
