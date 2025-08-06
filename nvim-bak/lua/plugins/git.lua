return {
	"tpope/vim-fugitive",
	-- gitsigns.nvim
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			current_line_blame = true,
		},
	},
	-- diffview.nvim
	{
		"sindrets/diffview.nvim",
		keys = {
			{
				"<leader>dvo",
				"<CMD>DiffviewOpen<CR>",
				desc = "Git: Diffview Open",
			},
			{
				"<leader>dvc",
				"<CMD>DiffviewClose<CR>",
				desc = "Git: Diffview Close",
			},
		},
	},
}
