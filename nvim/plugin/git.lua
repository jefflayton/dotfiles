local deps = require("mini.deps")
local add, later = deps.add, deps.later

later(function()
	add({ source = "lewis6991/gitsigns.nvim" })
	require("gitsigns").setup({ current_line_blame = true })

	add({ source = "sindrets/diffview.nvim" })
	vim.keymap.set("n", "<leader>dvo", "<cmd>DiffviewOpen<cr>", { desc = "Git: Open Diffview" })
	vim.keymap.set("n", "<leader>dvc", "<cmd>DiffviewClose<cr>", { desc = "Git: Close Diffview" })

	add({
		source = "NeogitOrg/neogit",
		depends = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"echasnovski/mini.pick",
		},
	})
end)
