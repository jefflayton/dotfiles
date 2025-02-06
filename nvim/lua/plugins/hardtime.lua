return {
	"m4xshen/hardtime.nvim",
	dependencies = { "MunifTanjim/nui.nvim" },
	opts = {
		enabled = true,
		-- Allow mouse because I'm bad
		disable_mouse = false,
		-- Allow arrow keys for jake-stewart/multicursor.nvim
		disabled_keys = {
			["<Up>"] = {},
			["<Down>"] = {},
			["<Left>"] = {},
			["<Right>"] = {},
		},
	},
}
