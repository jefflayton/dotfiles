local capabilities = require("blink.cmp").get_lsp_capabilities()
local mini_extra = require("mini.extra")

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		require("better-diagnostic-virtual-text.api").setup_buf(args.buf, {})

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
		nmap("graD", function()
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

local servers = {
	"denols",
	"cssls",
	"gopls",
	"html",
	"jdtls",
	"jsonls",
	"luals",
	"ltex",
	"ts_ls",
	"zls",
}
vim.lsp.enable(servers)
