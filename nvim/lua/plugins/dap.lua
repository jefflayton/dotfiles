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

		local debuggers = vim.fn.expand("$HOME/tools/debuggers")

		-- JavaScript/TypeScript
		local js_debug_path = vim.fn.expand(debuggers .. "/js-debug/src")
		dap.adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "node",
				args = { js_debug_path .. "/dapDebugServer.js", "${port}" },
			},
		}

		dap.configurations.javascript = {
			{
				type = "pwa-node",
				request = "launch",
				name = "Node: Launch file",
				program = "${file}",
				cwd = "${workspaceFolder}",
			},
			{
				type = "pwa-node",
				request = "launch",
				name = "Deno: Launch file",
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
		dap.configurations.typescript = dap.configurations.javascript

		-- C/C++/Zig
		local codelldb_path = vim.fn.expand(debuggers .. "/codelldb/extension/adapter/codelldb")
		dap.adapters.codelldb = {
			type = "executable",
			command = codelldb_path,
		}

		dap.configurations.zig = {
			{
				name = "Debug Zig",
				type = "codelldb",
				request = "launch",
				-- Ask for the path, default to the zig-cache bin
				program = function()
					local fname = vim.fn.expand("%:t:r") -- e.g. “test” from “test.zig”
					local default = vim.fn.getcwd() .. "/zig-out/bin/" .. fname
					return vim.fn.input("Path to executable: ", default, "file")
				end,
				cwd = "${workspaceFolder}",
				args = {},
				stopOnEntry = false,
				runInTerminal = false,
			},
		}

		-- Automatically open and close dap-view
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
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

		local disconnect = { "event_terminated", "event_exited", "disconnect" }
		local function restore()
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
		dap.listeners.after.event_terminated["me"] = restore
		dap.listeners.after.event_exited["me"] = restore
		dap.listeners.after.disconnect["me"] = restore

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
