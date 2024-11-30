local wezterm = require("wezterm")

local config = {
	{
		key = "c",
		mods = "LEADER",
		help = "Open a new tab",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "X",
		mods = "LEADER",
		help = "Close the current tab",
		action = wezterm.action.CloseCurrentTab({ confirm = true }),
	},
	{
		key = "x",
		mods = "LEADER",
		help = "Close the current pane",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "%",
		mods = "LEADER",
		help = "Split the current pane horizontally",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = '"',
		mods = "LEADER",
		help = "Split the current pane vertically",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "h",
		mods = "LEADER",
		help = "Moves the current pane to the left",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "LEADER",
		help = "Moves the current pane to the right",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "j",
		mods = "LEADER",
		help = "Moves the current pane down",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "LEADER",
		help = "Moves the current pane up",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "r",
		mods = "LEADER",
		action = wezterm.action.RotatePanes("CounterClockwise"),
	},
	{
		key = "R",
		mods = "LEADER",
		action = wezterm.action.RotatePanes("Clockwise"),
	},
	{
		key = "H",
		mods = "LEADER",
		action = wezterm.action.AdjustPaneSize({ "Left", 10 }),
	},
	{
		key = "L",
		mods = "LEADER",
		action = wezterm.action.AdjustPaneSize({ "Right", 10 }),
	},
	{
		key = "J",
		mods = "LEADER",
		action = wezterm.action.AdjustPaneSize({ "Down", 10 }),
	},
	{
		key = "K",
		mods = "LEADER",
		action = wezterm.action.AdjustPaneSize({ "Up", 10 }),
	},
	{
		key = "[",
		mods = "LEADER",
		action = wezterm.action.ActivateCopyMode,
	},
}

for i = 1, 9 do
	table.insert(config, {
		key = tostring(i),
		mods = "LEADER",
		action = wezterm.action.ActivateTab(i - 1),
	})
end
table.insert(config, {
	key = "0",
	mods = "LEADER",
	action = wezterm.action.ActivateTab(10),
})

return config
