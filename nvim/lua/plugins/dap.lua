return {
	"mfussenegger/nvim-dap",
	dependencies = {
		{
			"rcarriga/nvim-dap-ui",
			dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
			opts = {},
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		local js_debug_path = vim.fn.expand("$HOME/js-debug/src")

		dap.adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "node",
				args = { js_debug_path .. "/dapDebugServer.js", "${port}" },
			},
		}

		local jsConfig = function()
			local cwd = vim.fn.getcwd()
			local is_deno = vim.fn.filereadable(cwd .. "/deno.json") == 1
				or vim.fn.filereadable(cwd .. "/deno.jsonc") == 1
				or vim.fn.filereadable(cwd .. "/deno.lock") == 1

			if is_deno then
				return {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file",
						runtimeExecutable = "deno",
						runtimeArgs = {
							"run",
							"--inspect-wait",
							"--allow-all",
						},
						program = "${file}",
						cwd = "${workspaceFolder}",
						attachSimplePort = 9229,
					},
				}
			else
				return {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						cwd = "${workspaceFolder}",
					},
				}
			end
		end

		dap.configurations.javascript = jsConfig()

		dap.configurations.typescript = jsConfig()

		-- Automattically open and dclose dap-view
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		-- dap.listeners.before.event_terminated.dapui_config = function()
		-- 	dapui.close()
		-- end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		-- Map K to hover while session is active
		local api = vim.api
		local keymap_restore = {}
		dap.listeners.after["event_initialized"]["me"] = function()
			for _, buf in pairs(api.nvim_list_bufs()) do
				local keymaps = api.nvim_buf_get_keymap(buf, "n")
				for _, keymap in pairs(keymaps) do
					if keymap.lhs == "K" then
						table.insert(keymap_restore, keymap)
						api.nvim_buf_del_keymap(buf, "n", "K")
					end
				end
			end
			api.nvim_set_keymap("n", "K", '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
		end

		dap.listeners.after["event_terminated"]["me"] = function()
			for _, keymap in pairs(keymap_restore) do
				if keymap.rhs then
					api.nvim_buf_set_keymap(
						keymap.buffer,
						keymap.mode,
						keymap.lhs,
						keymap.rhs,
						{ silent = keymap.silent == 1 }
					)
				elseif keymap.callback then
					vim.keymap.set(
						keymap.mode,
						keymap.lhs,
						keymap.callback,
						{ buffer = keymap.buffer, silent = keymap.silent == 1 }
					)
				end
			end
			keymap_restore = {}
		end

		require("which-key").add({
			-- dap
			{
				"<leader>dc",
				function()
					dap.continue()
				end,
				desc = "DAP: Continue",
			},
			{
				"<leader>do",
				function()
					dap.step_over()
				end,
				desc = "DAP: Step Over",
			},
			{
				"<leader>dO",
				function()
					dap.step_out()
				end,
				desc = "DAP: Step Out",
			},
			{
				"<leader>di",
				function()
					dap.step_into()
				end,
				desc = "DAP: Step Into",
			},
			{
				"<leader>db",
				function()
					dap.toggle_breakpoint()
				end,
				desc = "DAP: Toggle Breakpoint",
			},
			{
				"<leader>dl",
				function()
					dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
				end,
				desc = "DAP: Set Log Point",
			},
			-- dap-view
			{
				"<leader>du",
				function()
					dapui.toggle()
				end,
				desc = "DAP: Toggle View",
			},
		})
	end,
}
