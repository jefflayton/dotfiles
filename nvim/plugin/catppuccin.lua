local add, now = require("mini.deps").add, require("mini.deps").now

now(function()
	add({
		source = "catppuccin/nvim",
	})
	require("catppuccin").setup({
		flabor = "mocha",
		float = {
			transparent = true,
			solid = true,
		},
	})
	vim.cmd.colorscheme("catppuccin")
end)
