vim.g.mapleader = " "

vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y<cr>', { desc = "Yank to System" })
vim.keymap.set({ "n", "v", "x" }, "<leader>d", '"+d<cr>', { desc = "Delete to System" })
