local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 10
config.color_scheme = 'AdventureTime'
-- config.allow_win32_input_mode = false
config.enable_csi_u_key_encoding = true

config.colors = { background = '#131c2b' }

local act = wezterm.action

config.disable_default_key_bindings = false

config.keys = {
  -- { key = ' ',    mods = 'CTRL',    action = act.SendString '\x1b[9~'  },
  { key = 'Enter',    mods = 'CTRL',    action = act.SendString '\x1b[27;5;13~'  },
  { key = 'Tab',    mods = 'CTRL',    action = act.SendString '\x1b[27;5;9~'  },
  { key = 'Tab',    mods = 'CTRL|SHIFT',    action = act.SendString '\x1b[27;6;9~'  },
  { key = '.',    mods = 'CTRL',    action = act.SendString '\x1b[27;5;46~'  },
  { key = ',',    mods = 'CTRL',    action = act.SendString '\x1b[27;5;44~'  },
  { key = '-',    mods = 'CTRL',    action = act.SendString '\x1b[27;5;45~'  },
  { key = '=',    mods = 'CTRL',    action = act.SendString '\x1b[27;5;61~'  },
  { key = '\\',    mods = 'ALT|CTRL',    action = act.SendString '\x1b[27;13;92~'  },
  { key = ';',    mods = 'CTRL',    action = act.SendString '\x1b[27;5;59~'  },
  { key = '>',    mods = 'CTRL|SHIFT',    action = act.SendString '\x1b[27;6;62~'  },
  { key = '<',    mods = 'CTRL|SHIFT',    action = act.SendString '\x1b[27;6;60~'  },
  { key = 'UpArrow',   mods = 'CTRL|SHIFT', action = act.SendString '\x1b[1;6A' },
  { key = 'DownArrow', mods = 'CTRL|SHIFT', action = act.SendString '\x1b[1;6B' },
  { key = 'RightArrow', mods = 'CTRL|SHIFT', action = act.SendString '\x1b[1;6C' },
  { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = act.SendString '\x1b[1;6D' },
  -- #56 S-Home → select to line start
  { key = 'Home', mods = 'SHIFT', action = act.SendString '\x1b[1;2H' },
  -- #57 S-End → select to line end
  { key = 'End', mods = 'SHIFT', action = act.SendString '\x1b[1;2F' },
  -- #66 Shift+Alt+I → mc/edit-lines
  { key = 'i', mods = 'SHIFT|ALT', action = act.SendString '\x1b[27;4;105~' },
  -- #76 C-S-f10 → peek definition
  { key = 'F10', mods = 'CTRL|SHIFT', action = act.SendString '\x1b[21;6~' },
  -- #78 Shift+F12 → xref-find-references
  { key = 'F12', mods = 'SHIFT', action = act.SendString '\x1b[24;2~' },
  -- #87 C-S-space → parameter hints
  { key = 'Space', mods = 'CTRL|SHIFT', action = act.SendString '\x1b[27;6;32~' },
  -- #101 Shift+F8 → flymake-goto-prev-error
  { key = 'F8', mods = 'SHIFT', action = act.SendString '\x1b[19;2~' },
  -- #134 C-S-s → save as
  { key = 's', mods = 'CTRL|SHIFT', action = act.SendString '\x1b[27;6;115~' },
  -- #159 C-S-backtick → new terminal
  { key = '`', mods = 'CTRL|SHIFT', action = act.SendString '\x1b[27;6;96~' },
}

config.ssh_domains = {
  {
    -- This name identifies the domain
    name = 'h100',
    -- The hostname or address to connect to. Will be used to match settings
    -- from your ssh config file
    remote_address = 'jytfy-d1-308-h100-d01-3',
    -- The username to use on the remote host
    username = 'luman',
    -- If true, connect to this domain automatically at startup
    connect_automatically = false,
    -- Specify an alternative read timeout
    timeout = 300,
  },
}

-- Finally, return the configuration to wezterm:
return config
