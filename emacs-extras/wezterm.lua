local wezterm = require 'wezterm'

local is_macos = wezterm.target_triple:match 'darwin' ~= nil

local config = wezterm.config_builder()

config.initial_cols = 120
config.initial_rows = 28
config.font_size = 10
config.font = wezterm.font(is_macos and 'Iosevka SS09' or 'Ubuntu Mono')
config.color_scheme = 'AdventureTime'
config.allow_win32_input_mode = false
config.disable_default_key_bindings = true
config.enable_csi_u_key_encoding = true
config.colors = { background = '#131c2b' }

local act = wezterm.action

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
  -- C-S-Arrow 交由 CSI-u 编码处理，移除显式 SendString 避免编码冲突
  -- { key = 'UpArrow',   mods = 'CTRL|SHIFT', action = act.SendString '\x1b[1;6A' },
  -- { key = 'DownArrow', mods = 'CTRL|SHIFT', action = act.SendString '\x1b[1;6B' },
  -- { key = 'RightArrow', mods = 'CTRL|SHIFT', action = act.SendString '\x1b[1;6C' },
  -- { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = act.SendString '\x1b[1;6D' },
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

  -- =====================================================
  -- F-keys for Emacs bindings (explicit SendString to
  -- bypass `enable_csi_u_key_encoding` which sends
  -- "u"-terminated sequences Emacs can't decode)
  -- =====================================================
  -- F1
  { key = 'F1', mods = 'CTRL',    action = act.SendString '\x1b[1;5P' },
  -- F2: eglot-rename / mc/mark-next-like-this / bookmark
  { key = 'F2',                   action = act.SendString '\x1b[12~' },
  { key = 'F2', mods = 'CTRL',    action = act.SendString '\x1b[1;5Q' },
  { key = 'F2', mods = 'SHIFT',   action = act.SendString '\x1b[1;2Q' },
  { key = 'F2', mods = 'CTRL|SHIFT', action = act.SendString '\x1b[1;6Q' },
  -- F3: isearch
  { key = 'F3',                   action = act.SendString '\x1b[13~' },
  { key = 'F3', mods = 'CTRL',    action = act.SendString '\x1b[1;5R' },
  { key = 'F3', mods = 'SHIFT',   action = act.SendString '\x1b[1;2R' },
  { key = 'F3', mods = 'CTRL|SHIFT', action = act.SendString '\x1b[1;6R' },
  -- F4: kill / save / register
  { key = 'F4', mods = 'CTRL',    action = act.SendString '\x1b[1;5S' },
  { key = 'F4', mods = 'SHIFT',   action = act.SendString '\x1b[1;2S' },
  { key = 'F4', mods = 'ALT',     action = act.SendString '\x1b[1;3S' },
  -- F5: goto-line
  { key = 'F5',                   action = act.SendString '\x1b[15~' },
  { key = 'F5', mods = 'CTRL',    action = act.SendString '\x1b[15;5~' },
  -- F6: other-window / switch-to-buffer / buffer-menu
  { key = 'F6',                   action = act.SendString '\x1b[17~' },
  { key = 'F6', mods = 'CTRL',    action = act.SendString '\x1b[17;5~' },
  { key = 'F6', mods = 'SHIFT',   action = act.SendString '\x1b[17;2~' },
  -- F7: comint shell history
  { key = 'F7',                   action = act.SendString '\x1b[18~' },
  { key = 'F7', mods = 'SHIFT',   action = act.SendString '\x1b[18;2~' },
  -- F8: consult-flymake
  { key = 'F8',                   action = act.SendString '\x1b[19~' },
  -- F9: query-replace
  { key = 'F9',                   action = act.SendString '\x1b[20~' },
  { key = 'F9', mods = 'CTRL',    action = act.SendString '\x1b[20;5~' },
  { key = 'F9', mods = 'SHIFT',   action = act.SendString '\x1b[20;2~' },
  -- F10: replace-string
  { key = 'F10',                  action = act.SendString '\x1b[21~' },
  { key = 'F10', mods = 'CTRL',   action = act.SendString '\x1b[21;5~' },
  { key = 'F10', mods = 'SHIFT',  action = act.SendString '\x1b[21;2~' },
  -- F11: fullscreen
  { key = 'F11',                  action = act.SendString '\x1b[23~' },
  { key = 'F11', mods = 'SHIFT',  action = act.SendString '\x1b[23;2~' },
  -- F12: xref
  { key = 'F12',                  action = act.SendString '\x1b[24~' },
  { key = 'F12', mods = 'ALT',    action = act.SendString '\x1b[24;3~' },
  -- Ctrl+Shift+V paste fix: intercept before any CSI-u encoding
  { key = 'V', mods = 'CTRL|SHIFT', action = act.PasteFrom("Clipboard") },
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
