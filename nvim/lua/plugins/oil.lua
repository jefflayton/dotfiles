return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {},
	-- Optional dependencies
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
	config = function()
		local oil = require("oil")
		oil.setup({
			float = {
				padding = 2,
				max_width = 120,
				max_height = 40,
			},
			view_options = {
				show_hidden = true,
			},
		})

		vim.keymap.set("n", "<leader>pv", oil.open, { desc = "Oil: Open" })
		vim.keymap.set("n", "<leader>pV", oil.open_float, { desc = "Oil: Open Float" })
		vim.keymap.set("n", "<leader>e", oil.toggle_float, { desc = "Oil: Toggle Float" })
	end,
}
