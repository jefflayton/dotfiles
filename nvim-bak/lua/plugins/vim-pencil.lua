return {
	"preservim/vim-pencil",
	config = function()
		vim.api.nvim_create_augroup("Pencil", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			group = "Pencil",
			pattern = "text",
			callback = function()
				vim.cmd("PencilSoft")
			end,
		})
	end,
}
