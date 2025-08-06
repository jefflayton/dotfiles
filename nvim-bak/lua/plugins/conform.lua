local utils = require("utils")

return {
	"stevearc/conform.nvim",
	config = function()
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
	end,
	keys = {
		{
			"<leader>fm",
			function()
				local range = nil
				local mode = vim.api.nvim_get_mode().mode

				-- Check if we're in visual mode
				if mode == "v" or mode == "V" or mode == "\22" then -- \22 is Ctrl-V (visual block)
					-- Get the visual selection range
					local start_line = vim.fn.line("v")
					local end_line = vim.fn.line(".")

					-- Ensure start_line is before end_line
					if start_line > end_line then
						start_line, end_line = end_line, start_line
					end

					local end_line_content = vim.api.nvim_buf_get_lines(0, end_line - 1, end_line, true)[1]
					range = {
						start = { start_line, 0 },
						["end"] = { end_line, end_line_content:len() },
					}
				end

				require("conform").format({ async = true, lsp_format = "fallback", range = range })
			end,
			mode = { "n", "v" },
			desc = "Conform: Format",
		},
	},
}
