vim.g.mapleader = " "

vim.keymap.set("n", "<leader>w", ":write<cr>", { desc = "Write Buffer" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Escape Terminal" })

-- System Clipboard
vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y<cr>', { desc = "Yank to System" })
vim.keymap.set({ "n", "v", "x" }, "<leader>d", '"+d<cr>', { desc = "Delete to System" })

-- Move Lines
vim.keymap.set("n", "<M-k>", ":m .-2<cr>==", { desc = "Move Line Up" })
vim.keymap.set("n", "<M-j>", ":m .+1<cr>==", { desc = "Move Line Down" })
vim.keymap.set("v", "<M-j>", ":m '>+1<cr>gv=gv", { desc = "Move Line Up" })
vim.keymap.set("v", "<M-k>", ":m '<-2<cr>gv=gv", { desc = "Move Line Down" })
vim.keymap.set("v", "<M-l>", ">gv", { desc = "Move Line Left" })
vim.keymap.set("v", "<M-h>", "<gv", { desc = "Move Line Right" })
