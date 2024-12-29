local M = {}

M.lsp_servers = function()
	return {
		clangd = {},
		denols = {
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
		sqls = {},
		ts_ls = {
			single_file_support = false,
		},
	}
end

M.formatters_by_ft = {
	c = { "clang-format" },
	cpp = { "clang-format" },
	javascript = { "prettier" },
	typescript = { "prettier" },
	json = { "prettier" },
	lua = { "stylua" },
	sql = { "sqlfluff" },
}

M.linters_by_ft = {
	json = { "jsonlint" },
	markdown = { "markdownlint" },
	text = { "vale" },
}

return M
