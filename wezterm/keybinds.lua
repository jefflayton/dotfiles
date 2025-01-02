local wezterm = require("wezterm")

local config = {}

config.keys = {
	{
		key = "c",
		mods = "LEADER",
		help = "Open a new tab",
		action = wezterm.action.SpawnCommandInNewTab({ cwd = wezterm.home_dir }),
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
	{
		key = "]",
		mods = "LEADER",
		action = wezterm.action.PasteFrom("PrimarySelection"),
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

config.key_tables = {
	copy_mode = {
		{
			key = "Escape",
			mods = "NONE",
			action = wezterm.action.CopyMode("Close"),
		},
		{
			key = "h",
			mods = "NONE",
			action = wezterm.action.CopyMode("MoveLeft"),
		},
		{
			key = "j",
			mods = "NONE",
			action = wezterm.action.CopyMode("MoveDown"),
		},
		{
			key = "k",
			mods = "NONE",
			action = wezterm.action.CopyMode("MoveUp"),
		},
		{
			key = "l",
			mods = "NONE",
			action = wezterm.action.CopyMode("MoveRight"),
		},
		{
			key = "w",
			mods = "NONE",
			action = wezterm.action.CopyMode("MoveForwardWord"),
		},
		{
			key = "b",
			mods = "NONE",
			action = wezterm.action.CopyMode("MoveBackwardWord"),
		},
		{
			key = "4",
			mods = "SHIFT",
			action = wezterm.action.CopyMode("MoveToEndOfLineContent"),
		},
		{
			key = "^",
			mods = "NONE",
			action = wezterm.action.CopyMode("MoveToStartOfLineContent"),
		},
		{
			key = "^",
			mods = "SHIFT",
			action = wezterm.action.CopyMode("MoveToStartOfLineContent"),
		},
		{ key = "v", mods = "NONE", action = wezterm.action.CopyMode({ SetSelectionMode = "Cell" }) },
		{
			key = "V",
			mods = "NONE",
			action = wezterm.action.CopyMode({ SetSelectionMode = "Line" }),
		},
		{
			key = "v",
			mods = "CTRL",
			action = wezterm.action.CopyMode({ SetSelectionMode = "Block" }),
		},
		{
			key = "G",
			mods = "NONE",
			action = wezterm.action.CopyMode("MoveToScrollbackBottom"),
		},
		{
			key = "g",
			mods = "NONE",
			action = wezterm.action.CopyMode("MoveToScrollbackTop"),
		},

		-- Enter y to copy and quit the copy mode.
		{
			key = "y",
			mods = "NONE",
			action = wezterm.action.Multiple({
				wezterm.action.CopyTo("ClipboardAndPrimarySelection"),
				wezterm.action.CopyMode("Close"),
			}),
		},
		{
			key = "/",
			mods = "NONE",
			action = wezterm.action({ Search = { CaseSensitiveString = "" } }),
		},
		{
			key = "n",
			mods = "CTRL",
			action = wezterm.action({ CopyMode = "NextMatch" }),
		},
		{
			key = "p",
			mods = "CTRL",
			action = wezterm.action({ CopyMode = "PriorMatch" }),
		},
	},
	search_mode = {
		{
			key = "Escape",
			mods = "NONE",
			action = wezterm.action({ CopyMode = "Close" }),
		},
		-- Go back to copy mode when pressing enter, so that we can use unmodified keys like "n"
		-- to navigate search results without conflicting with typing into the search area.
		{
			key = "Enter",
			mods = "NONE",
			action = "ActivateCopyMode",
		},
		{
			key = "c",
			mods = "CTRL",
			action = "ActivateCopyMode",
		},
		{
			key = "n",
			mods = "CTRL",
			action = wezterm.action({ CopyMode = "NextMatch" }),
		},
		{
			key = "p",
			mods = "CTRL",
			action = wezterm.action({ CopyMode = "PriorMatch" }),
		},
		{
			key = "r",
			mods = "CTRL",
			action = wezterm.action.CopyMode("CycleMatchType"),
		},
		{
			key = "u",
			mods = "CTRL",
			action = wezterm.action.CopyMode("ClearPattern"),
		},
	},
}

return config
