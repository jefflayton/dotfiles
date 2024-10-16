return {
	"numToStr/Comment.nvim",
	config = function()
		require("Comment").setup({
			mappings = {
				basic = true,
			},
		})

		require("which-key").add({
			{
				"<leader>gcc",
				function()
					require("Comment.api").toggle.linewise.current()
				end,
				desc = "Comment: Comment line",
				mode = "n",
			},
			{
				"<leader>gcb",
				function()
					require("Comment.api").toggle.blockwise.current()
				end,
				desc = "Comment: Comment block",
				mode = "n",
			},
			{
				"<leader>gc",
				function()
					require("Comment.api").toggle.linewise.count(vim.v.count1)
				end,
				desc = "Comment: Comment line",
				mode = "v",
			},
			{
				"<leader>gb",
				function()
					require("Comment.api").toggle.blockwise.count(vim.v.count1)
				end,
				desc = "Comment: Comment block",
				mode = "v",
			},
		})
	end,
}
