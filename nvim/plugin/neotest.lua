local add, later = require("mini.deps").add, require("mini.deps").later

later(function()
	add({
		source = "nvim-neotest/neotest",
		depends = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			-- Adapters
			"markemmons/neotest-deno",
			"lawrence-laz/neotest-zig",
			"nvim-neotest/neotest-jest",
		},
	})
	local neotest = require("neotest")
	neotest.setup({
		adapters = {
			require("neotest-deno"),
			require("neotest-zig")({
				dap = {
					adapter = "codelldb",
				},
			}),
			require("neotest-jest")({
				jestCommand = "npm test --",
				jestConfigFile = "custom.jest.config.ts",
				env = { CI = true },
				cwd = function(path)
					return vim.fn.getcwd()
				end,
			}),
		},
	})

	local nmap = function(keymap, action, desc)
		vim.keymap.set("n", keymap, action, { desc = "Test: " .. desc })
	end
	nmap("<leader>tn", function()
		neotest.run.run()
	end, "Run Nearest")
	nmap("<leader>tf", function()
		neotest.run.run(vim.fn.expand("%"))
	end, "Run File")
	nmap("<leader>ts", function()
		neotest.run.stop()
	end, "Stop Nearest")
end)
