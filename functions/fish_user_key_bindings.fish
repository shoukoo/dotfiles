function fish_user_key_bindings
  fzf_key_bindings

  # extra vim bindings
  bind yy fish_clipboard_copy
  bind Y fish_clipboard_copy
  bind p fish_clipboard_paste
  bind -M visual -m default y "fish_clipboard_copy; commandline -f end-selection repaint-mode"
end
