local add, now = require("mini.deps").add, require("mini.deps").now

now(function()
	add({
		source = "saghen/blink.cmp",
		depends = {
			"kristijanhusak/vim-dadbod-completion",
			"alexandre-abrioux/blink-cmp-npm.nvim",
			"L3MON4D3/LuaSnip",
		},
	})
	add({ source = "L3MON4D3/LuaSnip" })
	local luasnip = require("luasnip")
	luasnip.setup()
	require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
	vim.keymap.set({ "i", "s" }, "<C-e>", function()
		luasnip.expand()
	end, { desc = "LuaSnip: Expand" })
	vim.keymap.set("i", "<C-J>", function()
		luasnip.jump(1)
	end, { desc = "LuaSnip: Jump Down" })
	vim.keymap.set("i", "<C-K>", function()
		luasnip.jump(-1)
	end, { desc = "LuaSnip: Jump Up" })

	require("blink.cmp").setup({
		cmdline = {
			completion = {
				menu = { auto_show = true },
			},
			keymap = { preset = "inherit" },
		},
		completion = {
			menu = {
				draw = {
					treesitter = { "lsp" },
					columns = {
						{ "kind_icon", "label", "label_description", gap = 1 },
						{ "source_id" },
					},
				},
			},
		},
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
				"snippets",
				"path",
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
					min_keyword_length = 2,
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
		fuzzy = { implementation = "lua" },
	})
end)
