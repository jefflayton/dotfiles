return {
	"saghen/blink.cmp",
	version = "*",
	dependencies = {
		{ "L3MON4D3/LuaSnip", version = "v2.*" },
	},
	config = function()
		require("blink-cmp").setup({
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
				default = { "lsp", "lazydev", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						module = "lazydev.integrations.blink",
						name = "LazyDev",
					},
					snippets = {
						name = "snippets",
						module = "blink.cmp.sources.snippets",
					},
				},
			},
		})
	end,
}
