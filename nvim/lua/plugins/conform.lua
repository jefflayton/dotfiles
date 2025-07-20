return {
	"stevearc/conform.nvim",
	config = function()
		local conform = require("conform")

		local formatters_by_ft = {
			css = { "prettier" },
			go = { "gofmt" },
			html = { "prettier" },
			java = { "google-java-format" },
			javascript = { "prettier" },
			javascriptreact = { "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			latex = { "bibtex-tidy" },
			lua = { "stylua" },
			sql = { "sql_formatter" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			yaml = { "prettier" },
			zig = { "zigfmt" },
		}

		local jsFormatter = function()
			local cwd = vim.fn.getcwd()
			local is_deno = vim.fn.filereadable(cwd .. "/deno.json") == 1
				or vim.fn.filereadable(cwd .. "/deno.jsonc") == 1
				or vim.fn.filereadable(cwd .. "/deno.lock") == 1

			if is_deno then
				return { "deno_fmt" }
			else
				return { "prettier" }
			end
		end

		formatters_by_ft.javascript = jsFormatter
		formatters_by_ft.typescript = jsFormatter
		formatters_by_ft.typescriptreact = jsFormatter
		formatters_by_ft.json = jsFormatter
		formatters_by_ft.jsonc = jsFormatter

		conform.setup({
			formatters_by_ft = formatters_by_ft,
			formatters = {
				deno_fmt = {
					cwd = require("conform.util").root_file({ "deno.json", "deno.jsonc" }),
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
