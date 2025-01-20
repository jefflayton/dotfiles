return {
	"stevearc/conform.nvim",
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local conform = require("conform")

		require("mason-tool-installer").setup({
			ensure_installed = {
				"prettierd",
				"stylua",
				"google-java-format",
			},
		})

		local formatters_by_ft = {
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			typescriptreact = { "prettierd" },
			json = { "prettierd" },
			jsonc = { "prettierd" },
			lua = { "stylua" },
			java = { "google-java-format" },
		}

		local jsFormatter = function()
			local cwd = vim.fn.getcwd()
			local is_deno = vim.fn.filereadable(cwd .. "/deno.json") == 1
				or vim.fn.filereadable(cwd .. "/deno.jsonc") == 1
				or vim.fn.filereadable(cwd .. "/deno.lock") == 1

			if is_deno then
				return { "deno_fmt" }
			else
				return { "prettierd" }
			end
		end

		formatters_by_ft.javascript = jsFormatter
		formatters_by_ft.typescript = jsFormatter
		formatters_by_ft.typescriptreact = jsFormatter
		formatters_by_ft.json = jsFormatter
		formatters_by_ft.jsonc = jsFormatter

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
