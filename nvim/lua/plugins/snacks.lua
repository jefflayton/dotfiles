local pickerOpts = {
	cmd = "rg",
	hidden = true,
	ignored = true,
	exclude = { "node_modules/*", ".git/*" },
	matcher = { history_bonus = true },
}
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		bigfile = { enabled = true },
		bufdelete = { enabled = true },
		dim = { enabled = true },
		notify = { enabled = true },
		-- picker = {
		-- 	enabled = true,
		-- 	sources = {
		-- 		files = pickerOpts,
		-- 		grep = pickerOpts,
		-- 		buffers = pickerOpts,
		-- 	},
		-- },
		quickfile = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
	},
	keys = {
		-- {
		-- 	"<leader>ff",
		-- 	function()
		-- 		require("snacks").picker.files()
		-- 	end,
		-- 	desc = "Find Files",
		-- },
		-- {
		-- 	"<leader>fg",
		-- 	function()
		-- 		require("snacks").picker.grep()
		-- 	end,
		-- 	desc = "Live Grep",
		-- },
		-- {
		-- 	"<leader>fb",
		-- 	function()
		-- 		require("snacks").picker.buffers()
		-- 	end,
		-- 	desc = "Find Buffers",
		-- },
		-- {
		-- 	"<leader>fs",
		-- 	function()
		-- 		require("snacks").picker.lines()
		-- 	end,
		-- 	desc = "Buffer Lines",
		-- },
		-- {
		-- 	"<leader>fd",
		-- 	function()
		-- 		require("snacks").picker.diagnostics()
		-- 	end,
		-- 	desc = "Find Diagnostics",
		-- },
		-- {
		-- 	"<leader>ss",
		-- 	function()
		-- 		local spell_on_choice = vim.schedule_wrap(function(_, idx)
		-- 			if type(idx) == "number" then
		-- 				vim.cmd("normal! " .. idx .. "z=")
		-- 			end
		-- 		end)
		--
		-- 		local spellsuggest_select = function()
		-- 			if vim.v.count > 0 then
		-- 				spell_on_choice(nil, vim.v.count)
		-- 				return
		-- 			end
		-- 			local cword = vim.fn.expand("<cword>")
		-- 			local prompt = "Change " .. vim.inspect(cword) .. " to:"
		-- 			require("snacks").picker.select(
		-- 				vim.fn.spellsuggest(cword, vim.o.lines),
		-- 				{ prompt = prompt },
		-- 				spell_on_choice
		-- 			)
		-- 		end
		--
		-- 		spellsuggest_select()
		-- 	end,
		-- 	desc = "Spellcheck Suggestions",
		-- },
		-- {
		-- 	"<leader>sd",
		-- 	function()
		-- 		require("snacks").dim()
		-- 	end,
		-- },
	},
}
