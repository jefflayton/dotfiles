local add, now = require("mini.deps").add, require("mini.deps").now

now(function()
	add({ source = "L3MON4D3/LuaSnip", depends = { "rafamadriz/friendly-snippets" } })
	require("luasnip.loaders.from_vscode").lazy_load()
	require("luasnip").setup({ enable_autosnippets = true })

	add({ source = "zbirenbaum/copilot.lua" })
	require("copilot").setup({
		suggestion = { enabled = false },
		panel = { enabled = false },
		filetypes = {
			markdown = true,
			help = true,
		},
	})

	add({
		source = "saghen/blink.cmp",
		checkout = "1.*",
		depends = {
			"kristijanhusak/vim-dadbod-completion",
			"bydlw98/blink-cmp-env",
			"alexandre-abrioux/blink-cmp-npm.nvim",
			"archie-judd/blink-cmp-words",
			"fang2hou/blink-copilot",
		},
	})
	require("blink.cmp").setup({
		cmdline = { completion = { menu = {
			auto_show = true,
		} }, keymap = { preset = "inherit" } },
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
			default = {
				"buffer",
				"lsp",
				"lazydev",
				"path",
				"snippets",
				"copilot",
				"env",
			},
			per_filetype = {
				sql = { inherit_defaults = true, "dadbod" },
				json = { inherit_defaults = true, "npm" },
				jsonc = { inherit_defaults = true, "npm" },
			},
			providers = {
				dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100, -- Show at a higher priority than lsp
				},
				snippets = {
					name = "Snippets",
					module = "blink.cmp.sources.snippets",
					min_keyword_length = 3,
				},
				env = {
					name = "Env",
					module = "blink-cmp-env",
					--- @type blink-cmp-env.Options
					opts = {
						item_kind = require("blink.cmp.types").CompletionItemKind.Variable,
						show_braces = false,
						show_documentation_window = true,
					},
				},
				copilot = {
					name = "copilot",
					module = "blink-copilot",
					score_offset = 100,
					async = true,
					opts = {
						-- Local options override global ones
						max_completions = 3, -- Override global max_completions

						-- Final settings:
						-- * max_completions = 3
						-- * max_attempts = 2
						-- * all other options are default
					},
				},
				npm = {
					name = "npm",
					module = "blink-cmp-npm",
					async = true,
					-- optional - make blink-cmp-npm completions top priority (see `:h blink.cmp`)
					score_offset = 100,
					-- optional - blink-cmp-npm config
					---@module "blink-cmp-npm"
					---@type blink-cmp-npm.Options
					opts = {
						ignore = {},
						only_semantic_versions = true,
						only_latest_version = false,
					},
				},
			},
		},
		fuzzy = {
			implementation = "lua",
			sorts = {
				function(a, b)
					local sort = require("blink.cmp.fuzzy.sort")
					if a.source_id == "spell" and b.source_id == "spell" then
						return sort.label(a, b)
					end
				end,
				-- This is the normal default order, which we fall back to
				"score",
				"kind",
				"label",
			},
		},
	})
end)
