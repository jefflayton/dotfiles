return {
	"mhartington/formatter.nvim",
	config = function()
		require("formatter").setup({
			logging = false,
			filetype = {
				lua = {
					function()
						return {
							exe = "stylua",
							args = { "-" },
							stdin = true,
						}
					end,
				},
				python = {
					function()
						return {
							exe = "black",
							args = { "-" },
							stdin = true,
						}
					end,
				},
				rust = {
					function()
						return {
							exe = "rustfmt",
							args = { "--emit=stdout" },
							stdin = true,
						}
					end,
				},
				toml = {
					function()
						return {
							exe = "taplo",
							args = { "format", "-" },
							stdin = true,
						}
					end,
				},
			},
		})

		vim.api.nvim_create_augroup("FormatAutgroup", { clear = true })
		vim.api.nvim_create_autocmd("BufWritePost", {
			group = "FormatAutgroup",
			pattern = "*",
			callback = function()
				vim.cmd("FormatWrite")
			end,
		})
	end,
}
