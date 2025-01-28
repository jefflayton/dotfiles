return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"echasnovski/mini.extra",
		"saghen/blink.cmp",
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

			local snacks = require("snacks")
			map("gd", function()
				snacks.picker.lsp_definitions()
			end, "Goto Definition")
			map("gr", function()
				snacks.picker.lsp_references()
			end, "Goto References")
			map("gI", function()
				snacks.picker.lsp_implementations()
			end, "Goto Implementations")
			map("<leader>lD", function()
				snacks.picker.lsp_type_definitions()
			end, "Type Definitions")
			map("<leader>ld", function()
				snacks.picker.lsp_symbols()
			end, "LSP Symbols")

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
			jdtls = {},
			texlab = {},
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
