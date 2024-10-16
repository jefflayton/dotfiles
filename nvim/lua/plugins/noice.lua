return {
	"folke/noice.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	config = function()
		require("noice").setup({})

		require("notify").setup({
			background_colour = "#1E1E2E", -- Set to a color that contrasts with your text
		})

		require("telescope").load_extension("notify")
	end,
}
