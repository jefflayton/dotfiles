local function root_dir()
	local function get_project_root()
		local markers = { ".git", "package.json", "Makefile", "README.md" }
		local cwd = vim.loop.cwd()
		for _, marker in ipairs(markers) do
			local found = vim.fs.find(marker, { path = cwd, upward = true, limit = 1 })
			if #found > 0 then
				return vim.fs.dirname(found[1])
			end
		end
		return cwd
	end

	local root = get_project_root()
	if not root then
		return ""
	end

	local home = os.getenv("HOME")
	if home and root:find(home, 1, true) == 1 then
		root = "~" .. root:sub(#home + 1)
	end

	return root
end

local function get_words()
	if vim.fn.mode() == "v" or vim.fn.mode() == "V" or vim.fn.mode() == "" then
		return tostring(vim.fn.wordcount().visual_words .. " words")
	elseif vim.bo.filetype == "text" or vim.bo.filetype == "markdown" then
		return vim.fn.wordcount().words .. " words"
	else
		return ""
	end
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("lualine").setup({
			options = {
				theme = "catppuccin",
				icons_enabled = true,
				component_separators = { left = "", right = "│" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = {
					{ "mode", icon = "" },
				},
				lualine_b = {
					{ root_dir, icon = "󱉭" },
				},
				lualine_c = {
					{
						"branch",
						fmt = function(str)
							local branch = str
							if string.len(str) > 32 then
								branch = string.sub(str, 1, 17) .. "…" .. string.sub(str, -13)
							end

							return branch
						end,
						icon = "",
					},
				},
				lualine_x = { "filetype" },
				lualine_y = { "diagnostics", "diff", get_words },
				lualine_z = { "location" },
			},
		})
	end,
}
