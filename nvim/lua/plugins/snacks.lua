local pickerOpts = { hidden = true, glob = { "!node_modules/*", "!.git/*" } }
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		bigfile = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		picker = { enabled = true },
	},
	keys = {
		{
			"<leader>ff",
			function()
				require("snacks").picker.files(pickerOpts)
			end,
			desc = "Find Files",
		},
		{
			"<leader>fg",
			function()
				require("snacks").picker.grep(pickerOpts)
			end,
			desc = "Live Grep",
		},
		{
			"<leader>fb",
			function()
				require("snacks").picker.buffers(pickerOpts)
			end,
			desc = "Find Buffers",
		},
		{
			"<leader>fs",
			function()
				require("snacks").picker.lines()
			end,
			desc = "Buffer Lines",
		},
		{
			"<leader>fd",
			function()
				require("snacks").picker.diagnostics()
			end,
			desc = "Find Diagnostics",
		},
	},
	config = function()
		require("snacks").setup()
	end,
}
