# Command existence cache for performance
typeset -gA _cmd_cache
has_cmd() {
    [[ -n "${_cmd_cache[$1]}" ]] && return ${_cmd_cache[$1]}
    command -v "$1" &>/dev/null
    _cmd_cache[$1]=$?
    return ${_cmd_cache[$1]}
}

# Zinit
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit ice wait lucid atload"zicompinit; zicdreplay"
zinit light zsh-users/zsh-completions

# Aliases
source $HOME/.indie-dawg-dots/archlinux/zsh/.alias
source $HOME/.secret/.alias

# Clipboard compatibility - Wayland first, then X11 fallback
if [[ -n "$WAYLAND_DISPLAY" ]] && has_cmd wl-copy; then
    alias pbcopy='wl-copy'
    alias pbpaste='wl-paste'
elif has_cmd xsel; then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
elif has_cmd xclip; then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
fi

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
