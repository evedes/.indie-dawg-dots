# Command existence cache for performance
typeset -gA _cmd_cache
has_cmd() {
    [[ -n "${_cmd_cache[$1]}" ]] && return ${_cmd_cache[$1]}
    command -v "$1" &>/dev/null
    _cmd_cache[$1]=$?
    return ${_cmd_cache[$1]}
}

# Zinit (brew install zinit)
if [[ -r "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/zinit/zinit.zsh" ]]; then
    source "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/zinit/zinit.zsh"
    zinit light zsh-users/zsh-autosuggestions
    zinit light zdharma-continuum/fast-syntax-highlighting
    zinit ice wait lucid atload"zicompinit; zicdreplay"
    zinit light zsh-users/zsh-completions
else
    autoload -Uz compinit && compinit
fi

# Aliases
source "$HOME/.indie-dawg-dots/macos/zsh/.alias"
[[ -r "$HOME/.secret/.alias" ]] && source "$HOME/.secret/.alias"

# History
HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt inc_append_history     # write each command immediately, not on exit
setopt share_history          # share history across tmux/zellij panes
setopt extended_history       # record timestamps
setopt hist_expire_dups_first
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_verify

# Emacs mode
bindkey -e

# FZF
has_cmd fzf && source <(fzf --zsh)

# Starship
has_cmd starship && eval "$(starship init zsh)"

# Mise
has_cmd mise && eval "$(mise activate zsh)"
