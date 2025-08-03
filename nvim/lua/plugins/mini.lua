local pickOpts = {
	tool = "rg",
	globs = {
		"!**/.git/**",
		"!**/node_modules/**",
		"!**/!ios/**",
		"!**/android/**",
		"!**/dist/**",
	},
}

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

	local desc = "Split " .. direction
	vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
end

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
		require("mini.surround").setup()

		local extra = require("mini.extra")
		extra.setup()

		-- Configuration for mini.files
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

		-- Configuration for mini.pick
		local pick = require("mini.pick")
		pick.setup({
			options = {
				use_cache = true,
			},
		})
		vim.ui.select = pick.ui_select

		pick.registry.buffers = function(local_opts, opts)
			local_opts = local_opts or {}

			-- Delete the current buffer
			local wipeout_cur = function()
				vim.api.nvim_buf_delete(pick.get_picker_matches().current.bufnr, {})
				pick.builtin.buffers(local_opts, opts)
			end

			-- Map <C-d> to delete the buffer
			local buffer_mappings = { wipeout = { char = "<C-d>", func = wipeout_cur } }

			-- Show buffers with short names
			local show = function(buf_id, items, query)
				vim.tbl_map(function(i)
					i.text = vim.fn.fnamemodify(i.text, ":t")
				end, items)
				pick.default_show(buf_id, items, query, { show_icons = true })
			end

			-- Merge options
			opts = vim.tbl_deep_extend("force", {
				source = { show = show },
				mappings = buffer_mappings,
			}, opts or {})

			return pick.builtin.buffers(local_opts, opts)
		end
	end,
	keys = {
		-- mini.files
		{
			"<leader>e",
			function()
				require("mini.files").open()
			end,
			desc = "Open mini.files",
		},
		-- mini.pick
		{
			"<leader>ff",
			function()
				require("mini.pick").builtin.files(pickOpts)
			end,
			desc = "Mini Pick: Files",
		},
		{
			"<leader>fg",
			function()
				require("mini.pick").builtin.grep_live(pickOpts)
			end,
			desc = "Mini Pick: Live Grep",
		},
		{
			"<leader>fb",
			function()
				require("mini.pick").registry.buffers(pickOpts)
			end,
			desc = "Mini Pick: Buffers",
		},
		{
			"<leader>fs",
			function()
				require("mini.extras").pickers.buf_lines()
			end,
			desc = "Mini Extra: Buffer Search",
		},
	},
}
