return {
	"mfussenegger/nvim-lint",
	config = function()
		local linters_by_ft = {}

		local jsFormatter = function()
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

		linters_by_ft.json = jsFormatter()
		linters_by_ft.jsonc = jsFormatter()
		linters_by_ft.javascript = jsFormatter()
		linters_by_ft.typescript = jsFormatter()

		require("lint").linters_by_ft = linters_by_ft

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
