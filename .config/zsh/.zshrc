# Zinit
source /opt/homebrew/opt/zinit/zinit.zsh

# Load Zinit plugins - keeping just the essential ones
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zdharma-continuum/fast-syntax-highlighting

# Completions
zinit ice wait lucid atload"zicompinit; zicdreplay"
zinit light zsh-users/zsh-completions

# Fnm
eval "$(fnm env --use-on-cd)"

# Ruby
eval "$(rbenv init - zsh)"

# Alias
source $HOME/.indie-dawg-dots/.config/zsh/.alias

# Secrets
source $HOME/.ssh/load_secrets.sh

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

# ZOXIDE
eval "$(zoxide init zsh)"

# FZF
source <(fzf --zsh)

# Git completions (without Oh-My-Zsh dependency)
zinit ice as"completion"
zinit snippet https://github.com/git/git/blob/master/contrib/completion/git-completion.zsh

# Starship
eval "$(starship init zsh)"
