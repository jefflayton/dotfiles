return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", opt = {} },
		{ "williamboman/mason-lspconfig.nvim" },
		{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
		{ "saghen/blink.cmp" },
	},
	config = function()
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		local handlers = {
			["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
			["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
		}

		local callback = function(event)
			local builtin = require("telescope.builtin")
			local map = function(keys, func, desc)
				vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
			end

			map("gd", builtin.lsp_definitions, "Goto Definition")
			map("gr", builtin.lsp_references, "Goto References")
			map("gI", builtin.lsp_implementations, "Goto Implementation")
			map("<leader>lD", builtin.lsp_type_definitions, "Type Definition")
			map("<leader>ld", builtin.lsp_document_symbols, "Document Symbols")
			map("<leader>lw", builtin.lsp_dynamic_workspace_symbols, "Workspace Symbols")
			map("<leader>lr", vim.lsp.buf.rename, "Rename")
			map("<leader>la", vim.lsp.buf.code_action, "Code Action")
			map("K", vim.lsp.buf.hover, "Hover Documentation")
			map("gD", vim.lsp.buf.declaration, "Goto Declaration")

			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client and client.server_capabilities.documentHighlightProvider then
				local highlight_augroup = vim.api.nvim_create_augroup("user-lsp-highlight", { clear = false })
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = event.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.document_highlight,
				})

				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					buffer = event.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.clear_references,
				})

				vim.api.nvim_create_autocmd("LspDetach", {
					group = vim.api.nvim_create_augroup("user-lsp-detach", { clear = true }),
					callback = function(event2)
						vim.lsp.buf.clear_references()
						vim.api.nvim_clear_autocmds({
							group = "user-lsp-highlight",
							buffer = event2.buf,
						})
					end,
				})
			end

			if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
				map("<leader>lh", function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
				end, "Toggle Inlay Hints")
			end
		end

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
			callback = callback,
		})

		local servers = require("jeffreylayton.tools").lsp_servers(require("lspconfig"))
		local ensure_installed = vim.tbl_keys(servers or {})

		local formatters = require("jeffreylayton.tools").formatters_by_ft
		vim.list_extend(ensure_installed, formatters)

		local linters = require("jeffreylayton.tools").linters_by_ft
		vim.list_extend(ensure_installed, linters)

		require("mason-tool-installer").setup({
			ensure_installed = ensure_installed,
		})

		local lspconfig = require("lspconfig")
		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}

					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					server.handlers = vim.tbl_deep_extend("force", {}, handlers, server.handlers or {})
					if server_name == "denols" then
						server.root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc")
					elseif server_name == "ts_ls" then
						server.root_dir = lspconfig.util.root_pattern("package.json")
					end

					lspconfig[server_name].setup(server)
				end,
			},
		})
	end,
}
