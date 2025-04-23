return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = { "OXY2DEV/markview.nvim" },
	config = function()
		local configs = require("nvim-treesitter.configs")
		configs.setup({
			ensure_installed = {
				"bash",
				"c",
				"cpp",
				"css",
				"csv",
				"go",
				"html",
				"http",
				"java",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"latex",
				"lua",
				"make",
				"markdown",
				"markdown_inline",
				"sql",
				"typescript",
				"yaml",
				"zig",
			},
			sync_install = false,
			auto_install = true,
			ignore_install = {},
			highlight = {
				enable = true,
				disable = {},
				additional_vim_regex_highlighting = true,
			},
			indent = { enable = true },
			autotag = {
				enable = false,
			},
			refactor = {
				highlight_definitions = {
					enable = false,
				},
				highlight_current_scopes = {
					enable = false,
				},
				smart_rename = {
					enable = true,
				},
			},
		})
	end,
}
