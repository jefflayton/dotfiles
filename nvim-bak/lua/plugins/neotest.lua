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
		"markemmons/neotest-deno",
		"lawrence-laz/neotest-zig",
		"nvim-neotest/neotest-jest",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-deno"),
				require("neotest-zig")({
					dap = {
						adapter = "lldb",
					},
				}),
				require("neotest-jest")({
					jestCommand = "npm test --",
					jestConfigFile = "custom.jest.config.ts",
					env = { CI = true },
					cwd = function(path)
						return vim.fn.getcwd()
					end,
				}),
			},
		})
	end,
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
}
