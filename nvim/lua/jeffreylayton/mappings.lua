vim.g.mapleader = " "
vim.keymap.set({ "i", "v" }, "KJ", "<Escape>")

-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv")
-- vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<leader>fm", ":FormatWrite<CR>")

vim.keymap.set("n", "<C-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>")

-- Use vim.ui.select for spellcheck suggestions
local spell_on_choice = vim.schedule_wrap(function(_, idx)
	if type(idx) == "number" then
		vim.cmd("normal! " .. idx .. "z=")
	end
end)

local spellsuggest_select = function()
	if vim.v.count > 0 then
		spell_on_choice(nil, vim.v.count)
		return
	end
	local cword = vim.fn.expand("<cword>")
	local prompt = "Change " .. vim.inspect(cword) .. " to:"
	vim.ui.select(vim.fn.spellsuggest(cword, vim.o.lines), { prompt = prompt }, spell_on_choice)
end

vim.keymap.set("n", "z=", spellsuggest_select, { desc = "Shows spelling suggestions" })
