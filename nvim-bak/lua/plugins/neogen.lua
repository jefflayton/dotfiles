return {
	"danymat/neogen",
	opts = {
		snippet_engine = "luasnip",
	},
	keys = {
		{
			"<leader>ng",
			function()
				require("neogen").generate()
			end,
			desc = "Neogen: Generate",
		},
	},
}
