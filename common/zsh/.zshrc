# Command existence cache for performance
typeset -gA _cmd_cache
has_cmd() {
    [[ -n "${_cmd_cache[$1]}" ]] && return ${_cmd_cache[$1]}
    command -v "$1" &>/dev/null
    _cmd_cache[$1]=$?
    return ${_cmd_cache[$1]}
}

typeset -A platform_paths
platform_paths=(
    [macos_zinit]="/opt/homebrew/opt/zinit/zinit.zsh"
    [linux_zinit]="/usr/share/zinit/zinit.zsh"
    [linux_zinit_alt1]="$HOME/.local/share/zinit/zinit.git/zinit.zsh"
    [linux_zinit_alt2]="/usr/share/zsh/plugins/zinit/zinit.zsh"
)

get_platform_path() {
    local key="${ZSH_PLATFORM}_${1}"
    echo "${platform_paths[$key]}"
}

ZINIT_LOADED=0
if [[ "$ZSH_PLATFORM" == "linux" ]]; then
    for zinit_path in "$(get_platform_path zinit)" "$(get_platform_path zinit_alt1)" "$(get_platform_path zinit_alt2)"; do
        if [[ -f "$zinit_path" ]]; then
            source "$zinit_path"
            ZINIT_LOADED=1
            break
        fi
    done
else
    [[ -f "$(get_platform_path zinit)" ]] && source "$(get_platform_path zinit)" && ZINIT_LOADED=1
fi

if has_cmd zinit; then
    zinit light zsh-users/zsh-autosuggestions
    zinit light zdharma-continuum/fast-syntax-highlighting

    zinit ice wait lucid atload"zicompinit; zicdreplay"
    zinit light zsh-users/zsh-completions

    GIT_COMP_CACHE="$HOME/.cache/zsh/git-completion.zsh"
    if [[ ! -f "$GIT_COMP_CACHE" ]] || [[ $(find "$GIT_COMP_CACHE" -mtime +7 2>/dev/null) ]]; then
        mkdir -p "$(dirname "$GIT_COMP_CACHE")"
        curl -fsSL "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh" -o "$GIT_COMP_CACHE" 2>/dev/null
    fi
    zinit ice as"completion"
    zinit snippet "$GIT_COMP_CACHE"
fi

# Platform-specific configurations
if [[ "$ZSH_PLATFORM" == "linux" ]]; then
    [[ -f "$HOME/.indie-dawg-dots/archlinux/.linuxrc" ]] && source "$HOME/.indie-dawg-dots/archlinux/.linuxrc"
elif [[ "$ZSH_PLATFORM" == "macos" ]]; then
    [[ -f "$HOME/.indie-dawg-dots/macos/.macosrc" ]] && source "$HOME/.indie-dawg-dots/macos/.macosrc"
fi

# ALIASES
source $HOME/.indie-dawg-dots/common/zsh/.alias
source $HOME/.secret/.alias

# ZSH HISTORY
HISTFILE=$HOME/.zsh_history
HISTSIZE=5000
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt hist_expire_dups_first
setopt hist_ignore_space
setopt hist_ignore_dups
setopt hist_verify

# EMACS MODE
bindkey -e

# FZF
has_cmd fzf && source <(fzf --zsh)

# STARSHIP
has_cmd starship && eval "$(starship init zsh)"

# MISE
eval "$(mise activate zsh)"

# CLAUDE
# alias claude="~/.claude/local/claude"
