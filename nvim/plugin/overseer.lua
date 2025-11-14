local add, later = require("mini.deps").add, require("mini.deps").later

later(function()
	add({ source = "akinsho/toggleterm.nvim" })
	require("toggleterm").setup()

	add({ source = "stevearc/overseer.nvim" })
	local overseer = require("overseer")
	overseer.setup({
		strategy = "toggleterm",
		templates = { "builtin", "zig.build", "zig.build_run" },
	})

	local nmap = function(keymap, action, desc)
		vim.keymap.set("n", keymap, action, { desc = "Overseer: " .. desc })
	end
	nmap("<leader>os", "<cmd>OverseerRun<cr>", "Run")
end)
