local wezterm = require 'wezterm'
local config = wezterm.config_builder()
config.color_scheme = 'Gruvbox Dark (Gogh)'
config.font = wezterm.font({ family = 'Hack' })
config.font_size = 20
config.enable_tab_bar = false

config.keys = {
  {
    key = 'h',
    mods = 'CMD',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = 'q',
    mods = 'CMD',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = 'n',
    mods = 'CMD',
    action = wezterm.action.DisableDefaultAssignment,
  },
}

-- Window
config.window_padding = {
  left   = 3,
  right  = 3,
  top    = 10,
  bottom = 3,
}

return config
