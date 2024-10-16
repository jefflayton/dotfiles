return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
		{
			"theHamsta/nvim-dap-virtual-text",
			dependencies = {
				"mfussenegger/nvim-dap",
				"nvim-treesitter/nvim-treesitter",
			},
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		require("dapui").setup({})

		require("nvim-dap-virtual-text").setup({
			enabled = true, -- enable virtual text
			enabled_commands = true, -- enable dap commands
			highlight_changed_variables = true, -- highlight changed variables
			highlight_new_as_changed = false, -- show new variables with the same highlight
			show_stop_reason = true, -- show reason for stopping
			commented = false, -- comment the virtual text
		})

		-- Hook into nvim-dap events to automatically open/close dap-ui
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open() -- Open UI automatically when debug session starts
		end

		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close() -- Close UI when debug session ends
		end

		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close() -- Close UI when debug session exits
		end

		require("which-key").add({
			{
				"<leader>du",
				function()
					dapui.toggle()
				end,
				desc = "DAP UI: Toggle",
				mode = "n",
			},
		})
	end,
}
