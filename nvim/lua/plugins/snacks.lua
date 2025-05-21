vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesActionRename",
	callback = function(event)
		require("snacks").rename.on_rename_file(event.data.from, event.data.to)
	end,
})

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		bufdelete = { enabled = true },
		notify = { enabled = true },
		quickfile = { enabled = true },
		rename = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
	},
}
