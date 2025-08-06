local add, later = require("mini.deps").add, require("mini.deps").later
local utils = require("utils")

later(function()
	add({
		source = "stevearc/conform.nvim",
	})
	local conform = require("conform")

	local jsFormatter = utils.deno_or_node({ "deno_fmt" }, { "prettierd" })
	conform.setup({
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
		formatters_by_ft = {
			css = jsFormatter,
			html = jsFormatter,
			javascript = jsFormatter,
			javascriptreact = jsFormatter,
			json = jsFormatter,
			jsonc = jsFormatter,
			lua = { "stylua" },
			sql = { "sql_formatter" },
			typescript = jsFormatter,
			typescriptreact = jsFormatter,
			typst = { "typstyle" },
			yaml = jsFormatter,
			zig = { "zigfmt" },
		},
		formatters = {
			prettier = {
				args = {
					"--stdin-filepath",
					"$FILENAME",
					"--tab-width",
					"4",
				},
			},
			deno_fmt = {
				cwd = require("conform.util").root_file({ "deno.json", "deno.jsonc" }),
				args = {
					"fmt",
					"-",
					"--indent-width",
					"4",
				},
			},
			sql_formatter = {
				args = {
					"--indent",
					"    ",
				},
			},
		},
	})

	vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
end)
