return {
	"mfussenegger/nvim-lint",
	config = function()
		local linters_by_ft = {
			javascript = { "eslint_d", "deno" },
			javascriptreact = { "eslint_d", "deno" },
			json = { "eslint_d", "deno" },
			jsonc = { "eslint_d", "deno" },
			typescript = { "eslint_d", "deno" },
			typescriptreact = { "eslint_d", "deno" },
		}

		local jsLinter = function()
			local cwd = vim.fn.getcwd()
			local is_deno = vim.fn.filereadable(cwd .. "/deno.json") == 1
				or vim.fn.filereadable(cwd .. "/deno.jsonc") == 1
				or vim.fn.filereadable(cwd .. "/deno.lock") == 1

			if is_deno then
				return { "deno" }
			else
				return { "eslint_d" }
			end
		end

		linters_by_ft.javascript = jsLinter
		linters_by_ft.javascriptreact = jsLinter
		linters_by_ft.json = jsLinter
		linters_by_ft.jsonc = jsLinter
		linters_by_ft.typescript = jsLinter
		linters_by_ft.typescriptreact = jsLinter

		require("lint").linters_by_ft = linters_by_ft

		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = "*",
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
