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
		-- Your DBUI configuration
		vim.g.db_ui_use_nerd_fonts = 1
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
