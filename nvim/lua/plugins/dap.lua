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
	end,
	keys = {
		-- dap
		{
			"<leader>ddc",
			function()
				require("dap").continue()
			end,
			desc = "DAP: Continue",
		},
		{
			"<leader>ddo",
			function()
				require("dap").step_over()
			end,
			desc = "DAP: Step Over",
		},
		{
			"<leader>ddO",
			function()
				require("dap").step_out()
			end,
			desc = "DAP: Step Out",
		},
		{
			"<leader>ddi",
			function()
				require("dap").step_into()
			end,
			desc = "DAP: Step Into",
		},
		{
			"<leader>ddb",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "DAP: Toggle Breakpoint",
		},
		{
			"<leader>ddl",
			function()
				require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end,
			desc = "DAP: Set Log Point",
		},
		{
			"<leader>ddp",
			function()
				require("dap.ui.widgets").preview()
			end,
		},
		{
			"<leader>ddf",
			function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.frames)
			end,
		},
		{
			"<leader>dds",
			function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.scopes)
			end,
		},
		-- dap-view
		{
			"<leader>ddu",
			function()
				require("dapui").toggle()
			end,
			desc = "DAP: Toggle View",
		},
	},
}
