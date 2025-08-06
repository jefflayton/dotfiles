return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	init = function()
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_env_variable_url = "DATABASE_URL"
	end,
	keys = {
		{
			"<leader>db",
			"<CMD>DBUIToggle<CR>",
			desc = "DB: Toggle UI",
		},
		{
			"<leader>dbf",
			"<CMD>DBUIFindBuffer<CR>",
			desc = "DB: Find Buffer",
		},
	},
}
