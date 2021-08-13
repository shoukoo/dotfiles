#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected="$1"
else
    items=`find ~/Code/zendesk -maxdepth 1 -mindepth 1 -type d`
    items+=`find ~/Code/shoukoo -maxdepth 1 -mindepth 1 -type d`
    items+=("$HOME/shoukoo")
    items+=("$HOME/zendesk")
    selected=`echo "$items" | fzf`
fi

dirname=$( basename "$selected" )

tmux switch-client -t $dirname
if [[ $? -eq 0 ]]; then
    exit 0
fi

tmux new-session -c "$selected" -d -s $dirname && tmux switch-client -t $dirname || tmux new -c "$selected" -A -s $dirname
