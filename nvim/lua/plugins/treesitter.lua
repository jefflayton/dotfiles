return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = {
				"c",
				"cpp",
				"json",
				"jsdoc",
				"javascript",
				"typescript",
				"lua",
				"bash",
				"make",
				"markdown",
				"markdown_inline",
			},
			sync_install = false,
			auto_install = true,
			ignore_install = {},
			highlight = {
				enable = true,
				disable = {},
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = false },
			autotag = {
				enable = true,
				filetypes = { "html", "jsx", "tsx" },
			},
			refactor = {
				highlight_definitions = {
					enable = false,
				},
				highlight_current_scopes = {
					enable = false,
				},
				smart_rename = {
					enable = false,
				},
			},
		})
	end,
}
