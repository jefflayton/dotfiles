return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = { "c", "cpp", "go", "java", "jsdoc", "javascript", "typescript",  "markdown", "markdown_inline", "tsx", "json", "python","jsonc", "lua", "bash" },
			sync_install = false,
			auto_install = true,
			ignore_install = {},
			highlight = {
				enable = true,
				disable = {},
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },
			autotag = {
				enable = true,
				filetypes = { "html", "xml", "vue", "jsx", "tsx" },
			},
			refactor = {
				highlight_definitions = {
					enable = true,
					clear_on_cursor_move = true,
				},
				highlight_current_scopes = {
					enable = true,
				},
				smart_rename = {
					enable = true,
					keymaps = {
						smart_rename = "grr",
					},
				},
			},
		})
	end,
}
