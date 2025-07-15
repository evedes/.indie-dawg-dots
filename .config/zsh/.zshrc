# Platform detection
case "$(uname -s)" in
    Darwin) PLATFORM="macos" ;;
    Linux)  PLATFORM="linux" ;;
    *)      PLATFORM="unknown" ;;
esac

# Platform-specific paths using associative arrays
typeset -A platform_paths
platform_paths=(
    [macos_zinit]="/opt/homebrew/opt/zinit/zinit.zsh"
    [linux_zinit]="/usr/share/zinit/zinit.zsh"
    [macos_claude]="$HOME/.claude/local/claude"
    [linux_claude]="$HOME/.claude/local/claude"
)

# Helper function to get platform-specific path
get_platform_path() {
    local key="${PLATFORM}_${1}"
    echo "${platform_paths[$key]}"
}

# Zinit
[[ -f "$(get_platform_path zinit)" ]] && source "$(get_platform_path zinit)"

# Load Zinit plugins - keeping just the essential ones
if command -v zinit &>/dev/null; then
    zinit light zsh-users/zsh-autosuggestions
    zinit light zsh-users/zsh-syntax-highlighting
    zinit light zdharma-continuum/fast-syntax-highlighting

    # Completions
    zinit ice wait lucid atload"zicompinit; zicdreplay"
    zinit light zsh-users/zsh-completions

    # Git completions (without Oh-My-Zsh dependency)
    zinit ice as"completion"
    zinit snippet https://github.com/git/git/blob/master/contrib/completion/git-completion.zsh
fi

# Fnm
eval "$(fnm env --use-on-cd)"

# Platform-specific configurations
[[ -f "$HOME/.indie-dawg-dots/.config/zsh/.${PLATFORM}rc" ]] && source "$HOME/.indie-dawg-dots/.config/zsh/.${PLATFORM}rc"

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
command -v fzf &>/dev/null && source <(fzf --zsh)

# Starship
command -v starship &>/dev/null && eval "$(starship init zsh)"

# Claude
[[ -f "$(get_platform_path claude)" ]] && alias claude="$(get_platform_path claude)"

# Ruby
command -v rbenv &>/dev/null && eval "$(rbenv init -)"
