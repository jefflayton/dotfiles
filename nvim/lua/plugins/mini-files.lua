local map_split = function(buf_id, lhs, direction)
	local rhs = function()
		-- Make new window and set it as target
		local cur_target = require("mini.files").get_explorer_state().target_window
		local new_target = vim.api.nvim_win_call(cur_target, function()
			vim.cmd(direction .. " split")
			return vim.api.nvim_get_current_win()
		end)
		require("mini.files").go_in()
		require("mini.files").close()

		vim.api.nvim_set_current_win(cur_target)
	end

	-- Adding `desc` will result into `show_help` entries
	local desc = "Split " .. direction
	vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
end

return {
	"echasnovski/mini.files",
	version = "*",
	config = function()
		require("mini.files").setup({
			mappings = {
				synchronize = ":w<CR>",
			},
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "MiniFilesBufferCreate",
			callback = function(args)
				local buf_id = args.data.buf_id
				-- Tweak keys to your liking
				map_split(buf_id, "<C-s>", "belowright horizontal")
				map_split(buf_id, "<C-v>", "belowright vertical")
			end,
		})

		require("which-key").add({
			{
				"pv",
				function()
					require("mini.files").open()
				end,
				desc = "Open File",
			},
		})
	end,
}