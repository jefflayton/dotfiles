return {
	"echasnovski/mini.notify",
	version = "*",
	config = function()
		require("mini.notify").setup({
			window = {
				winblend = 0,
			},
		})
	end,
}
