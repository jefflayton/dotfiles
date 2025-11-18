local deps = require("mini.deps")
local add, now, later = deps.add, deps.now, deps.later

now(function()
	add({ source = "folke/snacks.nvim" })
	require("snacks").setup({
		bigfile = { enabled = true },
		gh = { enabled = true },
		image = { enabled = true },
	})
end)

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
