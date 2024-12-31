return {
	"stevearc/conform.nvim",
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local conform = require("conform")

		conform.formatters.denofmt = {
			command = "deno",
			args = { "fmt", "-" },
			stdin = true,
		}

		conform.formatters["clang-format"] = {
			prepend_args = { "--style='{IndentWidth: 4}'" },
		}

		conform.formatters.sqlfluff = {
			prepend_args = {
				"format",
				"--disable-progress-bar",
				"--nocolor",
				"-",
			},
		}

		local formatters_by_ft = require("jeffreylayton.tools").formatters_by_ft
		formatters_by_ft.typescript = function()
			local cwd = vim.fn.getcwd()
			local is_deno = vim.fn.filereadable(cwd .. "/deno.json") == 1
				or vim.fn.filereadable(cwd .. "/deno.jsonc") == 1

			if is_deno then
				return { "denofmt" }
			else
				return { "prettier" }
			end
		end

		conform.setup({
			formatters_by_ft = formatters_by_ft,
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				conform.format({ bufnr = args.buf })
			end,
		})

		require("which-key").add({
			{
				"<leader>fm",
				function()
					conform.format({ bufnr = vim.api.nvim_get_current_buf() })
				end,
				desc = "Format",
			},
		})
	end,
}
