local deps = require("mini.deps")
local now, later = deps.now, deps.later

now(function()
	local icons = require("mini.icons")
	icons.setup()
	icons.mock_nvim_web_devicons()
end)

now(function()
	local files = require("mini.files")
	files.setup({
		mappings = {
			synchronize = "<leader>w",
		},
	})
	vim.keymap.set("n", "<leader>e", function()
		files.open()
	end, { desc = "MiniFiles: Open" })

	local map_split = function(buf_id, lhs, direction)
		local rhs = function()
			-- Make new window and set it as target
			local cur_target = files.get_explorer_state().target_window
			vim.api.nvim_win_call(cur_target, function()
				vim.cmd(direction .. " split")
				return vim.api.nvim_get_current_win()
			end)
			files.go_in()
			files.close()
			vim.api.nvim_set_current_win(cur_target)
		end

		local desc = "MiniFiles: Split " .. direction
		vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
	end

	vim.api.nvim_create_autocmd("User", {
		pattern = "MiniFilesBufferCreate",
		callback = function(args)
			local buf_id = args.data.buf_id
			-- Tweak keys to your liking
			map_split(buf_id, "<C-s>", "belowright horizontal")
			map_split(buf_id, "<C-v>", "belowright vertical")
		end,
	})
end)

now(function()
	local pick = require("mini.pick")
	pick.setup({ options = { use_cache = true } })
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

		-- Merge options
		opts = vim.tbl_deep_extend("force", {
			mappings = buffer_mappings,
		}, opts or {})

		return pick.builtin.buffers(local_opts, opts)
	end

	local pickOpts = {
		tool = "rg",
		globs = {
			"!**/.git/**",
			"!**/.jj/**",
			"!**/node_modules/**",
			"!**/ios/**",
			"!**/android/**",
			"!**/dist/**",
			"!**/build/**",
			"!**/.zig-cache/**",
		},
	}

	local nmap = function(keymap, action, desc)
		vim.keymap.set("n", keymap, action, { desc = "MiniPick: " .. desc })
	end
	nmap("<leader>f", function()
		pick.builtin.files(pickOpts)
	end, "Files")
	nmap("<leader>g", function()
		pick.builtin.grep_live(pickOpts)
	end, "Live Grep")
	nmap("<leader>b", function()
		pick.registry.buffers(pickOpts)
	end, "Buffers")
	nmap("<leader>h", function()
		pick.builtin.help(pickOpts)
	end, "Help")
end)

later(function()
	local function get_words()
		local count = nil

		local filetype = vim.bo.filetype
		if vim.fn.mode() == "v" or vim.fn.mode() == "V" or vim.fn.mode() == "" then
			count = vim.fn.wordcount().visual_words
		elseif filetype == "text" or filetype == "markdown" or filetype == "typst" then
			count = vim.fn.wordcount().words
		else
			count = nil
		end

		if count == nil then
			return
		end

		local suffix = " words"
		if count == 1 then
			suffix = " word"
		end

		return "| " .. tostring(count) .. suffix
	end

	local statusline = require("mini.statusline")
	statusline.setup({
		-- Use default content
		content = {
			active = function()
				local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
				local git = statusline.section_git({ trunc_width = 40 })
				local diff = statusline.section_diff({ trunc_width = 75 })
				local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
				local lsp = statusline.section_lsp({ trunc_width = 75 })
				local filename = statusline.section_filename({ trunc_width = 140 })
				local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
				local location = statusline.section_location({ trunc_width = 75 })
				local search = statusline.section_searchcount({ trunc_width = 75 })

				local function get_filetype_with_icon()
					local ft = vim.bo.filetype
					if ft == "" then
						return "no ft"
					end

					-- Get icon using mini.icons
					local has_mini_icons, mini_icons = pcall(require, "mini.icons")
					if has_mini_icons then
						local icon = mini_icons.get("filetype", ft)
						if icon then
							return icon .. " " .. ft
						end
					end

					return ft
				end
				local filetype = get_filetype_with_icon()

				return statusline.combine_groups({
					{ hl = mode_hl, strings = { mode } },
					{ hl = "MiniStatuslineDevinfo", strings = { git } },
					"%<", -- Mark general truncate point
					{ hl = "MiniStatuslineFilename", strings = { filename } },
					"%=", -- End left alignment
					{ hl = "MiniStatuslineFilename", strings = { diff } },
					{ hl = "MiniStatuslineFileinfo", strings = { diagnostics } },
					-- { hl = mode_hl, strings = { search, location } },
					{ hl = mode_hl, strings = { filetype, get_words() } },
				})
			end,
		},
		use_icons = true,
		set_vim_settings = true,
	})
end)

later(function()
	require("mini.ai").setup()
	require("mini.comment").setup()
	require("mini.extra").setup()
	require("mini.indentscope").setup({ options = { border = "top" } })
	require("mini.git").setup()
	require("mini.jump").setup()
	-- Adjust HighLight for mini.jump to be more readable
	vim.cmd("highlight MiniJump guifg=#1e1e2e guibg=#f5c2e7")
	require("mini.notify").setup()
	-- require("mini.pairs").setup()
	require("mini.splitjoin").setup()
	require("mini.surround").setup()

	local clue = require("mini.clue")
	clue.setup({
		window = {
			delay = 500,
		},
		triggers = {
			-- Leader triggers
			{ mode = "n", keys = "<Leader>" },
			{ mode = "x", keys = "<Leader>" },

			-- Built-in completion
			{ mode = "i", keys = "<C-x>" },

			-- `g` key
			{ mode = "n", keys = "g" },
			{ mode = "x", keys = "g" },

			-- Marks
			{ mode = "n", keys = "'" },
			{ mode = "n", keys = "`" },
			{ mode = "x", keys = "'" },
			{ mode = "x", keys = "`" },

			-- Registers
			{ mode = "n", keys = '"' },
			{ mode = "x", keys = '"' },
			{ mode = "i", keys = "<C-r>" },
			{ mode = "c", keys = "<C-r>" },

			-- Window commands
			{ mode = "n", keys = "<C-w>" },

			-- `z` key
			{ mode = "n", keys = "z" },
			{ mode = "x", keys = "z" },
		},

		clues = {
			-- Enhance this by adding descriptions for <Leader> mapping groups
			clue.gen_clues.builtin_completion(),
			clue.gen_clues.g(),
			clue.gen_clues.marks(),
			clue.gen_clues.registers(),
			clue.gen_clues.windows(),
			clue.gen_clues.z(),
		},
	})
end)
