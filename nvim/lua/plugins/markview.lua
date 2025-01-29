return {
	"OXY2DEV/markview.nvim",
	lazy = false, -- Recommended
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"echasnovski/mini.icons",
	},
	config = function()
		require("markview").setup()
	end,
}
