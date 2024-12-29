return {
	{
		"saghen/blink.compat",
		version = "v2.1.2",
		lazy = true,
		opts = {},
	},
	{
		"saghen/blink.cmp",
		dependencies = {
			"L3MON4D3/LuaSnip",
			{
				"folke/lazydev.nvim",
				ft = "lua",
			},
			{
				"supermaven-inc/supermaven-nvim",
				opts = {
					keymaps = {
						accept_suggestion = nil,
					},
					-- disable_inline_completion = true,
					-- disable_auto_import = true,
				},
			},
		},
		version = "v0.8.2",
		config = function()
			require("blink.cmp").setup({
				keymap = {
					preset = "super-tab",
					["<C-n>"] = { "select_next", "show", "fallback" },
				},
				appearance = {
					use_nvim_cmp_as_default = false,
					nerd_font_variant = "mono",
				},
				snippets = {
					expand = function(snippet)
						require("luasnip").lsp_expand(snippet)
					end,
					active = function(filter)
						if filter and filter.direction then
							return require("luasnip").jumpable(filter.direction)
						end
						return require("luasnip").in_snippet()
					end,
					jump = function(direction)
						require("luasnip").jump(direction)
					end,
				},
				completion = {
					ghost_text = {
						enabled = true,
					},
				},
				sources = {
					default = { "supermaven", "lazydev", "lsp", "path", "luasnip", "snippets", "buffer" },
					providers = {
						lazydev = {
							name = "LazyDev",
							module = "lazydev.integrations.blink",
							score_offset = 99,
						},
						supermaven = {
							name = "supermaven",
							module = "blink.compat.source",
							score_offset = 100,
						},
					},
				},
			})
		end,
	},
}
