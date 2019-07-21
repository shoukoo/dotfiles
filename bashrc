### Install
# 1. Install latest bash via brew: brew install bash
# 2. To source .bashrc, create .bash_profile with content:
#
#    if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
#
###############

export GOPATH=$HOME/Documents/go
export GO111MODULE=on
export AWS_REGIONS="us-west-2 ap-southeast-2"
export PATH="$HOME/bin:$PATH";
export PATH=$PATH:$GOPATH/bin

export EDITOR="vim"

export CLICOLOR=1
# checkout `man ls` for the meaning
export LSCOLORS=cxBxhxDxfxhxhxhxhxcxcx

# enable GIT prompt options
export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true

# -- Source some files

# On Mac OS X: brew install bash-completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# Get it from the original Git repo:
# https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
if [ -f ~/.git-prompt.sh ]; then
  source ~/.git-prompt.sh
fi

# 1. Git branch is being showed
# 2. Title of terminal is changed for each new shell
# 3. History is appended each time
# 4. AWS Vault is being showed
export PROMPT_COMMAND='__git_ps1 "\[$(tput setaf 6)\]\W\[$(tput sgr0)\]\[$(tput sgr0)\]" " "; echo -ne "\033]0;${PWD##*/}\007"; [ "${AWS_VAULT}" ] && echo -ne "\033[0;33maws-${AWS_VAULT} ";'


# -- Misc

# Colored man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# check windows size if windows is resized
shopt -s checkwinsize

#use extra globing features. See man bash, search extglob.
shopt -s extglob

#include .files when globbing.
shopt -s dotglob

# Do not exit an interactive shell upon reading EOF.
set -o ignoreeof;

# Check the hash table for a command name before searching $PATH.
shopt -s checkhash

# Do not attempt completions on an empty line.
shopt -s no_empty_cmd_completion

# Case-insensitive filename matching in filename expansion.
shopt -s nocaseglob

# https://github.com/99designs/aws-vault
awsv() { aws-vault exec "$@" --no-session -- bash;}
