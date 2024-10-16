return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		require("which-key").setup({})
		require("which-key").add({
			{
				"<leader>wK",
				function()
					require("which-key").show()
				end,
				desc = "WhichKey: Show",
				mode = "n",
			},
		})
	end,
}
