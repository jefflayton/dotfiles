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
config.window_frame = {
	active_titlebar_bg = "rgba(17, 17, 27, 0.85)",
}

-- Tabs
config.use_fancy_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false

-- Window
config.window_background_opacity = 0.85
config.window_decorations = "RESIZE"
config.window_padding = { top = 32, right = 16, bottom = 16, left = 16 }

-- Keybinds
local keybinds = require("keybinds")
config.keys = keybinds.keys
config.key_tables = keybinds.key_tables

-- and finally, return the configuration to wezterm
return config
