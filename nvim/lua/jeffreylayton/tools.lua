local M = {}

M.lsp_servers = function(lspconfig)
	return {
		denols = {
			root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
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
		eslint = {
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
end

M.formatters_by_ft = {
	javascript = { "prettier" },
	typescript = { "prettier" },
	json = { "prettier" },
	lua = { "stylua" },
}

return M
