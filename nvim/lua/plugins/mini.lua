return {
	"echasnovski/mini.nvim",
	version = "*",
	config = function()
		require("mini.ai").setup()
		require("mini.indentscope").setup({ options = { border = "top" } })
		require("mini.move").setup({
			mappings = {
				-- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
				left = "<leader>h",
				down = "<leader>j",
				up = "<leader>k",
				right = "<leader>l",

				-- Move current line in Normal mode
				line_left = "<leader>h",
				line_down = "<leader>j",
				line_up = "<leader>k",
				line_right = "<leader>l",
			},
		})
		require("mini.pairs").setup()
		require("mini.surround").setup()

		local extra = require("mini.extra")
		extra.setup()

		-- Configuration for mini.pick
		local pick = require("mini.pick")
		pick.setup({
			options = {
				use_cache = true,
			},
		})
		vim.ui.select = pick.ui_select

		local pickOpts = { tool = "rg", globs = { "!.git/**", "!node_modules/**" } }

		require("which-key").add({
			{
				"<leader>ff",
				function()
					pick.builtin.files(pickOpts)
				end,
				desc = "Mini Pick: Start",
			},
			{
				"<leader>fg",
				function()
					pick.builtin.grep_live(pickOpts)
				end,
				desc = "Mini Pick: Live Grep",
			},
			{
				"<leader>fb",
				function()
					pick.builtin.buffers(pickOpts, {
						mappings = {
							wipeout = {
								char = "<C-d>",
								func = function()
									local items = pick.get_picker_items()
									local target = pick.get_picker_matches()
									--
									-- Close the buffer
									vim.api.nvim_buf_delete(target.current.bufnr, {})

									table.remove(items, target.current_ind)

									-- Update the list of buffers
									pick.set_picker_items(items)
								end,
							},
						},
					})
				end,
				desc = "Mini Pick: Buffers",
			},
			{
				"<leader>fs",
				function()
					extra.pickers.buf_lines()
				end,
				desc = "Mini Extra: Buffer Search",
			},
		})
	end,
}
