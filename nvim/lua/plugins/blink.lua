return {
	"saghen/blink.cmp",
	version = "v1.0.0",
	dependencies = {
		{ "L3MON4D3/LuaSnip", version = "v2.*" },
		{ "ribru17/blink-cmp-spell" },
		{
			"fang2hou/blink-copilot",
			dependencies = {
				{
					"zbirenbaum/copilot.lua",
					cmd = "Copilot",
					event = "InsertEnter",
					opts = {},
				},
			},
			opts = {
				max_completions = 1, -- Global default for max completions
				max_attempts = 2, -- Global default for max attempts
			},
		},
	},
	opts = {
		cmdline = { completion = { menu = { auto_show = true } }, keymap = { preset = "inherit" } },
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
			default = { "buffer", "lsp", "lazydev", "path", "snippets", "spell", "copilot" },
			providers = {
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
				spell = {
					name = "Spell",
					module = "blink-cmp-spell",
					opts = {
						-- EXAMPLE: Only enable source in `@spell` captures, and disable it
						-- in `@nospell` captures.
						enable_in_context = function()
							local curpos = vim.api.nvim_win_get_cursor(0)
							local captures = vim.treesitter.get_captures_at_pos(0, curpos[1] - 1, curpos[2] - 1)
							local in_spell_capture = false
							for _, cap in ipairs(captures) do
								if cap.capture == "spell" then
									in_spell_capture = true
								elseif cap.capture == "nospell" then
									return false
								end
							end
							return in_spell_capture
						end,
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
			},
		},
		fuzzy = {
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
	},
}
