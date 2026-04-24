# Command existence cache for performance
typeset -gA _cmd_cache
has_cmd() {
    [[ -n "${_cmd_cache[$1]}" ]] && return ${_cmd_cache[$1]}
    command -v "$1" &>/dev/null
    _cmd_cache[$1]=$?
    return ${_cmd_cache[$1]}
}

# Aliases
source $HOME/.indie-dawg-dots/archlinux/zsh/.alias
source $HOME/.secret/.alias

# Copy / Past
alias pbcopy='wl-copy'
alias pbpaste='wl-paste'

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

# Zinit
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
[[ ! -f $ZINIT_HOME/zinit.zsh ]] && ZINIT_HOME="/usr/share/zinit"
[[ ! -f $ZINIT_HOME/zinit.zsh ]] && ZINIT_HOME="/usr/share/zsh/plugins/zinit"
if [[ -f $ZINIT_HOME/zinit.zsh ]]; then
    source "$ZINIT_HOME/zinit.zsh"

    zinit light zsh-users/zsh-autosuggestions
    zinit light zsh-users/zsh-completions
    zinit light zdharma-continuum/fast-syntax-highlighting

    autoload -Uz compinit && compinit
    zinit cdreplay -q

    zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*' menu no

    bindkey '^[[A' history-search-backward
    bindkey '^[[B' history-search-forward
    bindkey '^ ' autosuggest-accept
fi

# Starship
has_cmd starship && eval "$(starship init zsh)"

# Mise
has_cmd mise && eval "$(mise activate zsh)"

# SSH AGENT (SYSTEMD)
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# bun completions
[ -s "/home/edo/.bun/_bun" ] && source "/home/edo/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
