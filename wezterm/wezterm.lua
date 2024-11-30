-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- Change Leader Key
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }

-- Font
config.font = wezterm.font("JetBrains Mono")
config.font_size = 14.0

-- Color Scheme
config.color_scheme = "Catppuccin Mocha"

-- Window
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.85
config.window_decorations = "RESIZE"

local keybinds = require("keybinds")
config.keys = keybinds

-- and finally, return the configuration to wezterm
return config
