return {
	"lewis6991/gitsigns.nvim",
	"tpope/vim-fugitive",
	{
		"sindrets/diffview.nvim",
		keys = {
			{
				"<leader>gd",
				"<CMD>DiffviewOpen<CR>",
				desc = "Git: Diffview Open",
			},
			{
				"<leader>gdc",
				"<CMD>DiffviewClose<CR>",
				desc = "Git: Diffview Close",
			},
		},
	},
}
