return {
	"dense-analysis/ale",
	config = function()
		vim.g.ale_linters_explicit = 1

		vim.g.ale_linters = {
			javascript = { "eslint" },
			typescript = { "eslint" },
			python = { "flake8", "mypy" },
			lua = { "luacheck" },
			-- Add more linters for other file types
		}

		-- Use specific fixers (formatters) for file types
		vim.g.ale_fixers = {
			javascript = { "prettier", "eslint" },
			typescript = { "prettier", "eslint" },
			python = { "black", "isort" },
			lua = { "stylua" },
			-- Add more fixers for other file types
		}

		-- Optional: automatically fix files on save
		vim.g.ale_fix_on_save = 1
	end,
}
