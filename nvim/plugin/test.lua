local add, later = require("mini.deps").add, require("mini.deps").later

later(function()
	add({ source = "vim-test/vim-test" })

	vim.g["test#strategy"] = "neovim"

	local nmap = function(keymap, action, desc)
		vim.keymap.set("n", keymap, action, { desc = "Test: " .. desc })
	end
	nmap("<leader>tn", "<cmd>TestNearest<cr>", "Nearest")
	nmap("<leader>tf", "<cmd>TestFile<cr>", "File")
	nmap("<leader>ts", "<cmd>TestSuite<cr>", "Suite")
	nmap("<leader>tl", "<cmd>TestLast<cr>", "Last")
	nmap("<leader>tv", "<cmd>TestVisit<cr>", "Visit")
end)
