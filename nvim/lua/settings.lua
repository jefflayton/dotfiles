--- Formatting
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.softtabstop = 4
vim.o.smartindent = true
vim.o.scrolloff = 8

vim.o.swapfile = false

-- Sync clipboard between MacOS and Neovim
vim.o.clipboard = "unnamedplus"

-- Case insensitive searching
vim.o.ignorecase = true
vim.o.hlsearch = false
vim.o.smartcase = true

-- Enable spell checking
vim.o.spell = true

-- Terminal colors
vim.o.termguicolors = true

-- Required for Deno
vim.g.markdown_fenced_languages = {
	"ts=typescript",
}

-- Enable virtual lines for diagnostic
vim.diagnostic.config({ virtual_lines = { current_line = true } })

-- Disable the auto comment on newlines after a comment
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
})
