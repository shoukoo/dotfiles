# =============
#    INIT
# =============

# Senstive functions which are not pushed to Github
# It contains GOPATH, some functions, aliases etc...
[ -r ~/.zsh_private ] && source ~/.zsh_private

# =============
#    ALIAS
# =============
alias ..='cd ..'

alias k9ss="k9s --as-group=system:masters --as admin"
alias t="tig status"
alias tigs="tig status" #old habits don't die
alias d='git diff'
alias vi='nvim'
alias vim='nvim'
alias v='nvim'
alias find='fd'
alias vimx='nvim --cmd "set rtp+=./"' # use it when developing a vim lua plugin
alias cl="printf '\33c\e[3J'"
# https://kubernetes.io/docs/tasks/tools/included/optional-kubectl-configs-zsh/
alias k=kubectl
alias fix='git diff --name-only | uniq | xargs $EDITOR'
alias lg='CONFIG_DIR=~/.config/lazygit lazygit'
alias cat='bat'
alias sq='git rebase -i $(git merge-base $(git rev-parse --abbrev-ref HEAD) master)'
alias co='git checkout master'
alias po='git pull origin $(git rev-parse --abbrev-ref HEAD)'
alias b='git branch'
alias icloud='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/'
alias vimrc='vim ~/.config/nvim/init.lua'
function ks () {
  kubectl --as admin --as-group system:masters "${@}"
}

case `uname` in
  Darwin)
    alias flushdns='sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder;say cache flushed'
    alias ls='ls -GpF' # Mac OSX specific
    alias ll='ls -alGpF' # Mac OSX specific
  ;;
  Linux)
    alias ll='ls -al'
    alias ls='ls --color=auto'
  ;;
esac

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

# =============
#   Oh my zsh
# =============
source ~/.config/antigen.zsh

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-autosuggestions

antigen theme robbyrussell
antigen apply



# =============
#    EXPORT
# =============
export PATH="/usr/local/sbin:/usr/local/go/bin:$GOBIN:$HOME/bin:$HOME/.krew/bin:$PATH"

export EDITOR="nvim"
export LSCOLORS=cxBxhxDxfxhxhxhxhxcxcx
export CLICOLOR=1

export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -l -g ""'
# =============
#    HISTORY
# =============

## Command history configuration
HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
# ignore duplication command history list
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
# share command history data
setopt share_history

# ===================
#    MISC SETTINGS
# ===================

# automatically remove duplicates from these arrays
typeset -U path PATH cdpath CDPATH fpath FPATH manpath MANPATH

# only exit if we're not on the last pane

exit() {
  if [[ -z $TMUX ]]; then
    builtin exit
    return
  fi

  panes=$(tmux list-panes | wc -l)
  wins=$(tmux list-windows | wc -l)
  count=$(($panes + $wins - 1))
  if [ $count -eq 1 ]; then
    tmux detach
  else
    builtin exit
  fi
}

function switchgo() {
  version=$1
  if [ -z $version ]; then
    echo "Usage: switchgo [version]"
    return
  fi

  if ! command -v "go$version" > /dev/null 2>&1; then
    echo "version does not exist, download with: "
    echo "  go install golang.org/dl/go${version}@latest"
    echo "  go${version} download"
    return
  fi

  go_bin_path=$(command -v "go$version")
  ln -sf "$go_bin_path" "$GOBIN/go"
  echo "Switched to ${go_bin_path}"
}

function fcd() {
  items=`find . ~/Code/zendesk --max-depth 1 --min-depth 1 --type directory`
  items+=`find . ~/Code/shoukoo --max-depth 1 --min-depth 1 --type directory`
  items+=("$HOME/shoukoo")
  items+=("$HOME/zendesk")
  selected=`echo "$items" | gum filter --height 20`
  if [ -z "$selected" ]; then
    return
  fi
  cd $selected
}

function fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac --height 20 | sed -r 's/ *[0-9]*\*? *//' | sed -r 's/\\/\\\\/g')
}

function fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  file=$(rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}")
  vim $file
}

# ===================
#    THIRD PARTY
# ===================

# brew install rbenv
eval "$(rbenv init -)"
# direnv
eval "$(direnv hook zsh)"
# powerline-go
function powerline_precmd() {
    PS1="$($GOPATH/bin/powerline-go -modules="aws,kube,venv,ssh,cwd,perms,git,exit,root" -error $? -jobs ${${(%):%j}:-0})"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" ] && [ -f "$GOPATH/bin/powerline-go" ]; then
    install_powerline_precmd
fi
