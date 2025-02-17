return {
	"saghen/blink.cmp",
	version = "v12.0.4",
	dependencies = {
		{ "L3MON4D3/LuaSnip", version = "v2.*" },
	},
	opts = {
		keymap = {
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide", "fallback" },

			["<Tab>"] = {
				function(cmp)
					if cmp.snippet_active() then
						return cmp.accept()
					else
						return cmp.select_and_accept()
					end
				end,
				"snippet_forward",
				"fallback",
			},
			["<S-Tab>"] = { "snippet_backward", "fallback" },

			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },

			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
		},
		snippets = { preset = "luasnip" },
		sources = {
			default = { "buffer", "lsp", "lazydev", "path", "snippets" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
				},
				snippets = {
					min_keyword_length = 1,
					score_offset = 4,
				},
				lsp = {
					name = "LSP",
					module = "blink.cmp.sources.lsp",
					min_keyword_length = 0,
					score_offset = 3,
				},
				path = {
					min_keyword_length = 0,
					score_offset = 2,
				},
				buffer = {
					min_keyword_length = 1,
					score_offset = 1,
				},
			},
		},
	},
}
