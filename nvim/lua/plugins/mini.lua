return {
	"echasnovski/mini.nvim",
	version = "*",
	config = function()
		require("mini.ai").setup()
		require("mini.extra").setup()
		require("mini.indentscope").setup({ options = { border = "top" } })
		require("mini.move").setup()
		require("mini.pairs").setup()
		require("mini.surround").setup()
	end,
}
