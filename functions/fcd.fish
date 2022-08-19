function fcd -d "fzf cd to a directory"
  set -l items (find ~/Code/zendesk -maxdepth 1 -mindepth 1 -type directory)
  set -la items (find . ~/Code/shoukoo -maxdepth 1 -mindepth 1 -type directory)
  set -l dir (echo "$items" | tr ' ' '\n' | gum filter)
  if test -n "$dir"
    cd $dir
  end
end
