local mini_extra = require("mini.extra")
local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local nmap = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = args.buf, desc = "LSP: " .. desc })
		end

		nmap("grd", function()
			mini_extra.pickers.lsp({ scope = "definition" })
		end, "Goto Definition")
		nmap("grr", function()
			mini_extra.pickers.lsp({ scope = "references" })
		end, "Goto References")
		nmap("gri", function()
			mini_extra.pickers.lsp({ scope = "implementation" })
		end, "Goto Implementation")
		nmap("grt", function()
			mini_extra.pickers.lsp({ scope = "type_definition" })
		end, "Type Definition")
		nmap("grs", function()
			mini_extra.pickers.lsp({ scope = "document_symbol" })
		end, "Document Symbols")
		nmap("grw", function()
			mini_extra.pickers.lsp({ scope = "workspace_symbol" })
		end, "Workspace Symbols")
		nmap("grf", function()
			mini_extra.pickers.diagnostic({
				scope = "all",
			})
		end, "All Diagnostics")
		nmap("grD", function()
			mini_extra.pickers.diagnostic({
				scope = "current",
			})
		end, "Diagnostics")
	end,
})

vim.lsp.config("*", {
	capabilities = capabilities,
})

vim.lsp.enable({
	"gopls",
	"cssls",
	"harperls",
	"html",
	"jdtls",
	"jsonls",
	"luals",
	"ltex",
	"zls",
})

-- Conditionally Enable JavaScript Language Servers
local cwd = vim.fn.getcwd()
local is_deno = vim.fn.filereadable(cwd .. "/deno.json") == 1
	or vim.fn.filereadable(cwd .. "/deno.jsonc") == 1
	or vim.fn.filereadable(cwd .. "/deno.lock") == 1

if is_deno then
	vim.lsp.enable("denols")
else
	vim.lsp.enable({ "eslint", "ts_ls" })
end
