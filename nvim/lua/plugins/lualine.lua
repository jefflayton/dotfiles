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
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = {
					{ "mode", icon = "" },
				},
				lualine_b = { "filetype" },
				lualine_c = {
					{
						"filename",
						path = 1,
					},
				},
				lualine_x = { "diagnostics" },
				lualine_y = { "diff", get_words },
				lualine_z = { "branch" },
			},
		})
	end,
}
