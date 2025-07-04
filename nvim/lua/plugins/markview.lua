return {
	"OXY2DEV/markview.nvim",
	lazy = false, -- Recommended
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		experimental = { check_rtp = false },
		latex = {
			enable = true,
		},
	},
}
