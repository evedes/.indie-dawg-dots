if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#RUBY
eval "$(rbenv init - zsh)"

# ZSH THEME
ZSH_THEME="powerlevel10k/powerlevel10k"

# OH-MY-ZSH
source $ZSH/oh-my-zsh.sh

# ALIAS
source $HOME/.indie-dawg-dots/.config/zsh/.alias

# SECRETS
source $HOME/.ssh/load_secrets.sh

# HISTORY SETUP
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

## ZOXIDE
eval "$(zoxide init zsh)"

## FZF
source <(fzf --zsh)

plugins=(
	zsh-autosuggestions
	zsh-syntax-highlighting
	git
	docker
  ruby
  rails
  bundler
)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
