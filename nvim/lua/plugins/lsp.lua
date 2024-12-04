return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		local lspconfig = require("lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local telescope_builtin = require("telescope.builtin")
		local on_attach = function(_, bufnr)
			vim.keymap.set(
				"n",
				"<leader>gd",
				telescope_builtin.lsp_definitions,
				{ buffer = bufnr, desc = "Telescope Goto Definition" }
			)
			vim.keymap.set(
				"n",
				"<leader>gr",
				telescope_builtin.lsp_references,
				{ buffer = bufnr, desc = "Telescope Find References" }
			)
			vim.keymap.set(
				"n",
				"<leader>gi",
				telescope_builtin.lsp_implementations,
				{ buffer = bufnr, desc = "Telescope Find Implementations" }
			)
			vim.keymap.set(
				"n",
				"<leader>gt",
				telescope_builtin.lsp_type_definitions,
				{ buffer = bufnr, desc = "Telescope Find Type Definitions" }
			)
			vim.keymap.set(
				"n",
				"<leader>gds",
				telescope_builtin.lsp_document_symbols,
				{ buffer = bufnr, desc = "Telescope Find Document Symbols" }
			)

			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename Symbol" })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })
		end

		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"eslint",
				"ts_ls",
				"denols",
				"clangd",
				"sqls",
				"jdtls",
			},
			automatic_installation = true,
		})

		lspconfig.lua_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
			filetypes = { "lua" },
		})

		lspconfig.ts_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			root_dir = lspconfig.util.root_pattern("package.json"),
			single_file_support = false,
		})

		lspconfig.eslint.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			root_dir = lspconfig.util.root_pattern("package.json"),
			single_file_support = false,
			handlers = {
				["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
					-- Disable diagnostics for node_modules
					if result.uri:match("node_modules") then
						return
					end
					vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
				end,
			},
		})

		lspconfig.denols.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
		})

		lspconfig.clangd.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		lspconfig.sqls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		lspconfig.jdtls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			{
				"jdtls",
				"-configuration",
				"/home/user/.cache/jdtls/config",
				"-data",
				"/home/user/.cache/jdtls/workspace",
			},
			single_file_support = true,
		})
	end,
}
