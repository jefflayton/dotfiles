return {
	"echasnovski/mini.nvim",
	version = "*",
	config = function()
		require("mini.ai").setup()
		require("mini.move").setup()
		require("mini.diff").setup()
		require("mini.extra").setup()
		require("mini.pairs").setup()
		require("mini.surround").setup()
		require("mini.indentscope").setup({ options = { border = "top" } })
	end,
}
