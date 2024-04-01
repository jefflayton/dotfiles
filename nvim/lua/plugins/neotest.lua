return {
	"nvim-neotest/neotest",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-treesitter/nvim-treesitter" },
		{ "rouge8/neotest-rust" },
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-rust"),
			},
		})

		vim.keymap.set("n", "<leader>tr", function()
			require("neotest").run.run()
		end)
		vim.keymap.set("n", "<leader>tf", function()
			require("neotest").run.run(vim.fn.expand("%"))
		end)
		vim.keymap.set("n", "<leader>tdr", function()
			require("neotest").run.run({ strategy = "dap" })
		end)
		vim.keymap.set("n", "<leader>tdf", function()
			require("neotest").run.run({ strategy = "dap", file = vim.fn.expand("%") })
		end)
		vim.keymap.set("n", "<leader>tl", function()
			require("neotest").run.last()
		end)
		vim.keymap.set("n", "<leader>ts", function()
			require("neotest").run.stop()
		end)
	end,
}
