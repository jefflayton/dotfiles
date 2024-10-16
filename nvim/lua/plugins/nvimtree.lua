return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("nvim-web-devicons").setup({})
		require("nvim-tree").setup({
			sort_by = "case_sensitive",
			view = {
				width = 25,
				side = "left",
			},
			on_attach = function(bufnr)
				require("which-key").add({
					{
						"%",
						function()
							require("nvim-tree.api").fs.create()
						end,
						desc = "Create File or Directory",
						mode = "n",
					},
					{
						"D",
						function()
							require("nvim-tree.api").fs.remove()
						end,
						desc = "Remove",
						mode = "n",
					},
					{
						"<leader>rn",
						function()
							require("nvim-tree.api").fs.rename()
						end,
						desc = "Rename",
						mode = "n",
					},
					{
						"<CR>",
						function()
							require("nvim-tree.api").node.open.edit()
						end,
						desc = "Open",
						mode = "n",
					},
					{
						"q",
						function()
							require("nvim-tree.api").tree.close()
						end,
						desc = "Close",
						mode = "n",
					},
					{
						"<C-v>",
						function()
							require("nvim-tree.api").node.open.vertical()
						end,
						desc = "Open Vertical",
						mode = "n",
					},
				})
			end,
		})

		require("which-key").add({
			{
				"<C-n>",
				":NvimTreeToggle<CR>",
				desc = "Toggle nvim-tree",
				mode = "n",
			},
			{
				"<leader>e",
				":NvimTreeFocus<CR>",
				desc = "Focus nvim-tree",
				mode = "n",
			},
		})
	end,
}
