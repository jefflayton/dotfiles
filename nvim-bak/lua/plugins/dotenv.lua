vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	pattern = ".env*",
	callback = function()
		vim.cmd("Dotenv")
	end,
})

return {
	"tpope/vim-dotenv",
}
