return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"saghen/blink.cmp",
		"echasnoviski/mini.nvim",
		{
			"sontungexpt/better-diagnostic-virtual-text",
			lazy = true,
		},
	},
	config = function()
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		local on_attach = function(_, bufnr)
			require("better-diagnostic-virtual-text.api").setup_buf(bufnr, {})

			local map = function(keys, func, desc)
				vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
			end

			local mini = require("mini.extra")
			map("gd", function()
				mini.pickers.lsp({ scope = "definition" })
			end, "LSP: Goto Definition")
			map("gr", function()
				mini.pickers.lsp({ scope = "references" })
			end, "Goto References")
			map("gI", function()
				mini.pickers.lsp({ scope = "implementation" })
			end, "Goto Implementation")
			map("<leader>lD", function()
				mini.pickers.lsp({ scope = "type" })
			end, "Type Definition")
			map("<leader>ld", function()
				mini.pickers.lsp({ scope = "document_symbol" })
			end, "Document Symbols")
			map("<leader>lw", function()
				mini.pickers.lsp({ scope = "workspace_symbol" })
			end, "Workspace Symbols")
			map("<leader>fd", function()
				mini.pickers.diagnostic({
					scope = "all",
				})
			end, "LSP: Diagnostics")

			map("<leader>lr", vim.lsp.buf.rename, "Rename")
			map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
			map("K", vim.lsp.buf.hover, "Hover Documentation")
			map("gD", vim.lsp.buf.declaration, "Goto Declaration")
		end

		local lspconfig = require("lspconfig")

		local servers = {
			denols = {
				root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deno.lock"),
				settings = {
					deno = {
						unstable = true,
						suggest = {
							imports = {
								hosts = {
									["https://deno.land"] = true,
									["https://cdn.nest.land"] = true,
									["https://crux.land"] = true,
								},
							},
						},
					},
				},
			},
			dockerls = {},
			gopls = {},
			lua_ls = {
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
			},
			ltex = {
				settings = {
					ltex = {
						enabled = {
							"bibtex",
							"gitcommit",
							"markdown",
							"org",
							"tex",
							"restructuredtext",
							"rsweave",
							"latex",
							"quarto",
							"rmd",
							"context",
							"xhtml",
							"mail",
							"plaintext",
						},
						additionalRules = {
							languageModel = "~/ngrams/",
						},
					},
				},
			},
			jdtls = {},
			texlab = {},
			ts_ls = {
				root_dir = lspconfig.util.root_pattern("package.json"),
				single_file_support = false,
			},
			zls = {},
		}
		local ensure_installed = vim.tbl_keys(servers)

		require("mason").setup()
		require("mason-tool-installer").setup({
			ensure_installed = ensure_installed,
		})

		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}

					server.on_attach = on_attach
					server.capabilities = capabilities

					lspconfig[server_name].setup(server)
				end,
			},
		})
	end,
}
