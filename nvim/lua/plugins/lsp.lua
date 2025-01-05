return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"echasnovski/mini.extra",
		"saghen/blink.cmp",
	},
	config = function()
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		local on_attach = function(_, bufnr)
			local map = function(keys, func, desc)
				vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
			end

			local miniExtra = require("mini.extra")
			map("gd", function()
				miniExtra.pickers.lsp({ scope = "definition" })
			end, "Goto Definition")
			map("gr", function()
				miniExtra.pickers.lsp({ scope = "references" })
			end, "Goto References")
			map("gI", function()
				miniExtra.pickers.lsp({ scope = "implementation" })
			end, "Goto Implementation")
			map("<leader>lD", function()
				miniExtra.pickers.lsp({ scope = "type" })
			end, "Type Definition")
			map("<leader>ld", function()
				miniExtra.pickers.lsp({ scope = "document_symbol" })
			end, "Document Symbols")
			map("<leader>lw", function()
				miniExtra.pickers.lsp({ scope = "workspace_symbol" })
			end, "Workspace Symbols")

			map("<leader>lr", vim.lsp.buf.rename, "Rename")
			map("<leader>la", vim.lsp.buf.code_action, "Code Action")
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
			eslint_d = {
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
			},
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
			ts_ls = {
				root_dir = lspconfig.util.root_pattern("package.json"),
				single_file_support = false,
			},
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
