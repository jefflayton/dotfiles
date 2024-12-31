return {
	"echasnovski/mini.pick",
	dependencies = {
		"echasnovski/mini.nvim",
	},
	version = "*",
	config = function()
		local pick = require("mini.pick")
		pick.setup()

		local extra = require("mini.extra")

		local wipeout_cur = function()
			vim.api.nvim_buf_delete(pick.get_picker_matches().current.bufnr, {})
		end
		local buffer_mappings = { wipeout = { char = "<C-d>", func = wipeout_cur } }

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
					pick.builtin.buffers({ tool = "rg" })
				end,
				desc = "Mini Pick: Buffers",
			},
			{
				"<leader>fD",
				function()
					extra.pickers.diagnostic({ scope = "all", mapping = buffer_mappings })
				end,
				desc = "Mini Extra: Diagnostics",
			},
		})
	end,
}
