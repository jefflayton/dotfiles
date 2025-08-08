local add, now = require("mini.deps").add, require("mini.deps").now

now(function()
	add({ source = "dmmulroy/ts-error-translator.nvim" })
	require("ts-error-translator").setup()

	vim.lsp.enable("ts_ls")
end)
