return {
	"echasnovski/mini.pick",
	dependencies = {
		"echasnovski/mini.extra",
	},
	version = "*",
	config = function()
		local extra = require("mini.extra")
		local pick = require("mini.pick")
		pick.setup()

		require("which-key").add({
			{
				"<leader>ff",
				function()
					pick.builtin.files({ tool = "rg" })
				end,
				desc = "Mini Pick: Start",
			},
			{
				"<leader>fg",
				function()
					pick.builtin.grep_live({ tool = "rg" })
				end,
				desc = "Mini Pick: Live Grep",
			},
			{
				"<leader>fb",
				function()
					pick.builtin.buffers({
						tool = "rg",
					}, {
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
				"<leader>fD",
				function()
					extra.pickers.diagnostic({
						scope = "all",
					})
				end,
				desc = "Mini Extra: Diagnostics",
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
