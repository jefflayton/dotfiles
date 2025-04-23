return {
	"stevearc/oil.nvim",
	opts = {
		keymaps = {
			["<C-v>"] = { "actions.select", opts = { vertical = true } },
			["<C-s>"] = { "actions.select", opts = { horizontal = true } },
			["q"] = { "actions.close", mode = "n" },
		},
	},
	keys = {
		{
			"<leader>e",
			function()
				require("oil").open_float()
			end,
			{ desc = "Oil: Open" },
		},
	},
}
