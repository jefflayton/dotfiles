local utils = require("utils")

return {
	"stevearc/conform.nvim",
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				css = { "prettier" },
				html = { "prettier" },
				javascript = utils.deno_or_node({ "deno_fmt" }, { "prettier" }),
				javascriptreact = utils.deno_or_node({ "deno_fmt" }, { "prettier" }),
				json = utils.deno_or_node({ "deno_fmt" }, { "prettier" }),
				jsonc = utils.deno_or_node({ "deno_fmt" }, { "prettier" }),
				lua = { "stylua" },
				sql = { "sql_formatter" },
				typescript = utils.deno_or_node({ "deno_fmt" }, { "prettier" }),
				typescriptreact = utils.deno_or_node({ "deno_fmt" }, { "prettier" }),
				yaml = { "prettier" },
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

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				conform.format({ bufnr = args.buf })
			end,
		})
	end,
	keys = {
		{
			"<leader>fm",
			function()
				require("conform").format({ bufnr = vim.api.nvim_get_current_buf(), async = true })
			end,
		},
	},
}
