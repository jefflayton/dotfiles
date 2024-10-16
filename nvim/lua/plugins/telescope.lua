return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope-dap.nvim" },
	},
	config = function()
		local telescope = require("telescope")
		telescope.setup({})

		local builtin = require("telescope.builtin")

		require("which-key").add({
			{
				"<leader>ff",
				builtin.find_files,
				desc = "Find files",
				mode = "n",
			},
			{
				"<leader>fg",
				builtin.live_grep,
				desc = "Live grep",
				mode = "n",
			},
			{
				"<leader>fb",
				builtin.buffers,
				desc = "Buffers",
				mode = "n",
			},
			{
				"<leader>fh",
				builtin.help_tags,
				desc = "Help tags",
				mode = "n",
			},
			{
				"<leader>fz",
				builtin.current_buffer_fuzzy_find,
				desc = "Fuzzy find",
				mode = "n",
			},
		})
	end,
}
