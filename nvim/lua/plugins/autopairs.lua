return {
	"windwp/nvim-autopairs",
	config = function()
		require("nvim-autopairs").setup({
			check_ts = true,
			ts_config = {
				lua = { "string" }, -- it will not add a pair on that treesitter node
				javascript = { "template_string" },
				typescript = { "template_string" },
				rust = { "template_string" },
			},
		})
	end,
}
