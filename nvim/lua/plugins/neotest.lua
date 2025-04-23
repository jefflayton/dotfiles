return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		-- vim-test
		"vim-test/vim-test",
		"nvim-neotest/neotest-vim-test",
		-- other adapters
		"hammerlink/neotest-deno",
		"lawrence-laz/neotest-zig",
	},
	keys = {
		{
			"<leader>tn",
			function()
				require("neotest").run.run()
			end,
			desc = "Test: Run Nearest",
		},
		{
			"<leader>tf",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "Test: Run File",
		},
		{
			"<leader>ts",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "Test: Stop Nearest",
		},
	},
	config = function()
		require("neotest").setup({
			log_level = vim.log.levels.TRACE,
			adapters = {
				-- require("neotest-vim-test")({ allowed_filetypes = { "javascript", "typescript" } }),
				require("neotest-deno"),
				require("neotest-zig")({
					dap = {
						adapter = "lldb",
					},
				}),
			},
		})
	end,
}
