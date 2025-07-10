local function js_linter()
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

return {
	"mfussenegger/nvim-lint",
	config = function()
		require("lint").linters_by_ft = {
			javascript = js_linter(),
			javascriptreact = js_linter(),
			json = js_linter(),
			jsonc = js_linter(),
			typescript = js_linter(),
			typescriptreact = js_linter(),
		}

		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = "*",
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
