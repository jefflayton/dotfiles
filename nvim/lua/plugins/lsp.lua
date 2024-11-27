return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"sigmasd/deno-nvim",
	},
	config = function()
		local lspconfig = require("lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local which_key = require("which-key")

		local on_attach = function(_, bufnr)
			which_key.add({
				{
					"<leader>rn",
					function()
						vim.lsp.buf.rename()
					end,
					desc = "LSP: Rename",
					mode = "n",
				},
				{
					"<leader>ca",
					function()
						vim.lsp.buf.code_action()
					end,
					desc = "LSP: Code action",
					mode = "n",
				},
				{
					"gd",
					require("telescope.builtin").lsp_definitions,
					desc = "LSP: Definitions",
					mode = "n",
				},
				{
					"gr",
					require("telescope.builtin").lsp_references,
					desc = "LSP: References",
					mode = "n",
				},
				{
					"gI",
					require("telescope.builtin").lsp_implementations,
					desc = "LSP: Implementations",
					mode = "n",
				},
				{
					"<leader>D",
					require("telescope.builtin").lsp_type_definitions,
					desc = "LSP: Type definitions",
					mode = "n",
				},
				{
					"<leader>ds",
					require("telescope.builtin").lsp_document_symbols,
					desc = "LSP: Document symbols",
					mode = "n",
				},
				{
					"<leader>ws",
					require("telescope.builtin").lsp_dynamic_workspace_symbols,
					desc = "LSP: Workspace symbols",
					mode = "n",
				},
			})
		end

		require("mason").setup({
			ensure_installed = {
				"denols",
				"tsserver",
				"clangd",
				"gopls",
				"pyright",
				"jdtls",
				"lua-language-server",
			},
			automatic_installation = true,
		})

		lspconfig.denols.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
		})

		lspconfig.ts_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			root_dir = lspconfig.util.root_pattern("package.json"),
			single_file_support = false,
		})

		lspconfig.clangd.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		lspconfig.gopls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		lspconfig.pyright.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				python = {
					analysis = {
						autoSearchPaths = true,
						diagnosticMode = "workspace",
						useLibraryCodeForTypes = true,
					},
				},
			},
			filetypes = { "python" },
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

		lspconfig.jdtls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = { "java" },
			root_dir = lspconfig.util.root_pattern("build.gradle", "pom.xml", "build.xml"),
		})
	end,
}
