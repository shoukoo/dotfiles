set -gx EDITOR nvim
set -gx GOBIN $HOME/go/bin
set -gx FZF_CTRL_T_COMMAND nvim

set -gxp PATH /usr/local/sbin $HOME/go/bin $HOME/.krew/bin

# git prompt settings
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_showdirtystate 'yes'
set -g __fish_git_prompt_char_stateseparator ' '
set -g __fish_git_prompt_char_dirtystate "✖"
set -g __fish_git_prompt_char_cleanstate "✔"
set -g __fish_git_prompt_char_untrackedfiles "…"
set -g __fish_git_prompt_char_stagedstate "●"
set -g __fish_git_prompt_char_conflictedstate "+"
set -g __fish_git_prompt_color_dirtystate yellow
set -g __fish_git_prompt_color_cleanstate green --bold
set -g __fish_git_prompt_color_invalidstate red
set -g __fish_git_prompt_color_branch cyan --dim --italics

# vim
alias vi='nvim'
alias vim='nvim'
alias v='nvim'
alias vimrc='vim ~/.config/nvim/init.lua'

# navigation
alias ..='cd ..'
alias ...='cd ../..'

# kubectl
alias k='kubectl'
alias ks='kubectl --as admin --as-group system:masters'

# lazy git
alias lg='CONFIG_DIR=~/.config/lazygit lazygit'

# apple
alias icloud='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/'

# Senstive functions which are not pushed to Github
# It contains work related stuff, some functions, aliases etc...
source ~/.private.fish

# direnv
direnv hook fish | source

# rbenv
status --is-interactive; and source (rbenv init -|psub)
