local deps = require("mini.deps")
local add, later = deps.add, deps.later

later(function()
	add({ source = "folke/lazydev.nvim" })
	require("lazydev").setup({
		library = {
			path = "${3rd}/luv/library",
			words = { "vim%.uv" },
			library = { "nvim-dap-ui" },
		},
	})

	add({ source = "folke/flash.nvim" })
	local flash = require("flash")
	vim.keymap.set({ "n", "x", "o" }, "zk", function()
		flash.jump()
	end, { desc = "Flash: Jump" })
	vim.keymap.set({ "n", "x", "o" }, "zK", function()
		flash.treesitter()
	end, { desc = "Flash: Treesitter" })
	vim.keymap.set("o", "r", function()
		flash.remote()
	end, { desc = "Flash: Remote" })
	vim.keymap.set({ "o", "x" }, "R", function()
		flash.treesitter_search()
	end, { desc = "Flash: Treesitter Search" })
	vim.keymap.set("c", "<c-s>", function()
		flash.toggle()
	end, { desc = "Flash: Toggle Search" })
end)
