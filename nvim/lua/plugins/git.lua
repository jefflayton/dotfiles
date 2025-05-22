return {
	"lewis6991/gitsigns.nvim",
	"tpope/vim-fugitive",
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
