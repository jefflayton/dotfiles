local add, later = require("mini.deps").add, require("mini.deps").later
local utils = require("utils")

later(function()
	add({
		source = "stevearc/conform.nvim",
	})
	local conform = require("conform")

	local jsFormatter = utils.deno_or_node({ "deno_fmt" }, { "prettierd" })

	local sql_formatter = function()
		local pg_wd = utils.root_pattern({ ".pg_format" })

		if pg_wd ~= nil then
			return {}
		else
			return { "pg_format" }
		end
	end

	conform.setup({
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
		formatters_by_ft = {
			c = { "clang-format" },
			css = jsFormatter,
			html = jsFormatter,
			javascript = jsFormatter,
			javascriptreact = jsFormatter,
			json = jsFormatter,
			jsonc = jsFormatter,
			lua = { "stylua" },
			sql = sql_formatter(),
			svelte = { "prettierd" },
			typescript = jsFormatter,
			typescriptreact = jsFormatter,
			typst = { "typstyle" },
			yaml = jsFormatter,
			zig = { "zigfmt" },
		},
		formatters = {
			["clang-format"] = {
				args = { "-assume-filename", "$FILENAME", "--style", "{BasedOnStyle: llvm, IndentWidth: 4}" },
			},
		},
	})

	vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
end)
