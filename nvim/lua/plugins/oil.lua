return {
	"stevearc/oil.nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		default_file_explorer = true,
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
