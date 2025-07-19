# Command existence cache for performance
typeset -gA _cmd_cache
has_cmd() {
    [[ -n "${_cmd_cache[$1]}" ]] && return ${_cmd_cache[$1]}
    command -v "$1" &>/dev/null
    _cmd_cache[$1]=$?
    return ${_cmd_cache[$1]}
}

# Platform-specific paths using associative arrays
typeset -A platform_paths
platform_paths=(
    [macos_zinit]="/opt/homebrew/opt/zinit/zinit.zsh"
    [linux_zinit]="/usr/share/zinit/zinit.zsh"
    [linux_zinit_alt1]="$HOME/.local/share/zinit/zinit.zsh"
    [linux_zinit_alt2]="/usr/share/zsh/plugins/zinit/zinit.zsh"
    [macos_claude]="$HOME/.claude/local/claude"
    [linux_claude]="$HOME/.claude/local/claude"
)

# Helper function to get platform-specific path
get_platform_path() {
    local key="${ZSH_PLATFORM}_${1}"
    echo "${platform_paths[$key]}"
}

# Zinit - check multiple possible locations
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

# Load Zinit plugins - keeping just the essential ones
if has_cmd zinit; then
    zinit light zsh-users/zsh-autosuggestions
    zinit light zsh-users/zsh-syntax-highlighting
    zinit light zdharma-continuum/fast-syntax-highlighting

    # Completions
    zinit ice wait lucid atload"zicompinit; zicdreplay"
    zinit light zsh-users/zsh-completions

    # Git completions (without Oh-My-Zsh dependency)
    zinit ice as"completion"
    zinit snippet https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh
fi

# Fnm - Fast Node Manager (cross-platform)
if has_cmd fnm; then
    eval "$(fnm env --use-on-cd --shell zsh)"
fi

# Platform-specific configurations
[[ -f "$HOME/.indie-dawg-dots/.config/zsh/.${ZSH_PLATFORM}rc" ]] && source "$HOME/.indie-dawg-dots/.config/zsh/.${ZSH_PLATFORM}rc"

# Common configurations
source $HOME/.indie-dawg-dots/.config/zsh/.alias
[[ -f "$HOME/.ssh/load_secrets.sh" ]] && source $HOME/.ssh/load_secrets.sh

# History setup
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

# Starship
has_cmd starship && eval "$(starship init zsh)"

# Claude
[[ -f "$(get_platform_path claude)" ]] && alias claude="$(get_platform_path claude)"

# Ruby
has_cmd rbenv && eval "$(rbenv init -)"
