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
				"bibtex-tidy",
			},
		})

		local formatters_by_ft = {
			go = { "gofmt" },
			html = { "prettierd" },
			java = { "google-java-format" },
			javascript = { "prettierd" },
			json = { "prettierd" },
			jsonc = { "prettierd" },
			latex = { "bibtex-tidy" },
			lua = { "stylua" },
			typescript = { "prettierd" },
			typescriptreact = { "prettierd" },
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

		-- Adjust settings for Java. google-java-formatter uses 2 spaces
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			callback = function()
				vim.opt_local.tabstop = 2
				vim.opt_local.shiftwidth = 2
				vim.opt_local.softtabstop = 2
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
