return {
	"saghen/blink.cmp",
	version = "*",
	dependencies = {
		"mikavilpas/blink-ripgrep.nvim",
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
			default = { "lazydev", "lsp", "path", "snippets", "buffer", "ripgrep" },
			providers = {
				snippets = {
					name = "snippets",
					module = "blink.cmp.sources.snippets",
					score_offset = 10,
				},
				lazydev = {
					module = "lazydev.integrations.blink",
					name = "LazyDev",
					-- make lazydev completions top priority (see `:h blink.cmp`)
					score_offset = 100,
				},
				ripgrep = {
					module = "blink-ripgrep",
					name = "Ripgrep",
					opts = {
						prefix_min_len = 3,
						context_size = 5,
						max_filesize = "1M",
						project_root_marker = ".git",
						project_root_fallback = true,
						search_casing = "--ignore-case",
						additional_rg_options = {},
						fallback_to_regex_highlighting = true,
						ignore_paths = {},
						debug = false,
					},
				},
			},
		},
	},
}
