return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
	},
	config = function()
		require("telescope").setup({
			defaults = {
				file_ignore_patterns = { "node_modules" },
				vimgrep_arguments = {
					"rg",
					"--hidden",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--no-ignore",
					"--glob=!.git",
				},
			},
			pickers = {
				find_files = {
					find_command = {
						"rg",
						"--hidden",
						"--files",
						"--glob=!.git",
					},
				},
			},
		})

		local telescope_builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, { desc = "Telescope Find Files" })
		vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, { desc = "Telescope Live Grep" })
		vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, { desc = "Telescope Buffers" })
		vim.keymap.set("n", "<leader>fd", telescope_builtin.diagnostics, { desc = "Telescope Diagnostics" })
	end,
}
