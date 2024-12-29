--- Formating
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4

vim.opt.smartindent = true

vim.opt.scrolloff = 8

-- Sync clipboard between MacOS and NeoVim
vim.opt.clipboard = "unnamedplus"

-- Case insensitive searching
vim.opt.ignorecase = true
vim.opt.hlsearch = false
vim.opt.smartcase = true

-- Terminal colors
vim.opt.termguicolors = true

-- Required for Denols
vim.g.markdown_fenced_languages = {
	"ts=typescript",
}
