local add, later = require("mini.deps").add, require("mini.deps").later

later(function()
	add({
		source = "kristijanhusak/vim-dadbod-ui",
		depends = { "tpope/vim-dadbod", "tpope/vim-dotenv" },
		hooks = {
			post_install = function()
				vim.g.db_ui_use_nerd_fonts = 1
				vim.g.db_ui_env_variable_url = "DATABASE_URL"
			end,
		},
	})
	vim.keymap.set("n", "<leader>le", "<cmd>Dotenv<cr>", { desc = "Dotenv: Load" })

	vim.keymap.set("n", "<leader>db", "<cmd>DBUIToggle<cr>", { desc = "DB: Toggle UI" })
	vim.keymap.set("n", "<leader>dbf", "<cmd>DBUIFindBuffer<cr>", { desc = "DB: Find Buffer" })
end)
