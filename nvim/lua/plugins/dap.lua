return {
	"mfussenegger/nvim-dap",
	config = function()
		local dap = require("dap")

		require("mason").setup({
			ensure_installed = { "codelldb" },
			automatic_installation = true,
		})

		local mason_registry = require("mason-registry")
		local codelldb_root = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"

		local codelldb_path = codelldb_root .. "adapter/codelldb"
		local liblldb_path = codelldb_root .. "lldb/lib/liblldb.dylib"

		local js_debug_path = mason_registry.get_package("js-debug-adapter"):get_install_path()
			.. "/js-debug/src/dapDebugServer.js"

		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			host = "127.0.0.1",
			executable = {
				command = codelldb_path,
				args = { "--port", "${port}" },
			},
		}

		dap.configurations.c = {
			{
				name = "Debug an Executable",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input({
						prompt = "Path to executable: ",
						default = vim.fn.getcwd() .. "/",
						completion = "file",
					})
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
			},
		}

		dap.configurations.cpp = dap.configurations.c
		dap.configurations.rust = dap.configurations.c

		dap.adapters.delve = function(callback, config)
			if config.mode == "remote" and config.request == "attach" then
				callback({
					type = "server",
					host = config.host or "127.0.0.1",
					port = config.port or "38697",
				})
			else
				callback({
					type = "server",
					port = "${port}",
					executable = {
						command = "dlv",
						args = { "dap", "-l", "127.0.0.1:${port}", "--log", "--log-output=dap" },
						detached = vim.fn.has("win32") == 0,
					},
				})
			end
		end

		-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
		dap.configurations.go = {
			{
				type = "delve",
				name = "Debug",
				request = "launch",
				program = "${file}",
			},
			{
				type = "delve",
				name = "Debug test", -- configuration for debugging test files
				request = "launch",
				mode = "test",
				program = "${file}",
			},
			-- works with go.mod packages and sub packages
			{
				type = "delve",
				name = "Debug test (go.mod)",
				request = "launch",
				mode = "test",
				program = "./${relativeFileDirname}",
			},
		}

		dap.adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "node",
				args = { js_debug_path, "${port}" },
			},
		}

		dap.configurations.typescript = {
			{
				type = "pwa-node",
				request = "launch",
				name = "[Deno] Launch file",
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
			{
				type = "pwa-node",
				request = "launch",
				name = "[Node] Launch file",
				runtimeExecutable = "node",
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

		dap.configurations.javascript = dap.configurations.typescript

		require("which-key").add({
			{
				"<leader>dd",
				function()
					dap.continue()
				end,
				desc = "DAP: Continue",
				mode = "n",
			},
			{
				"<leader>do",
				function()
					dap.step_over()
				end,
				desc = "DAP: Step Over",
				mode = "n",
			},
			{
				"<leader>dO",
				function()
					dap.step_out()
				end,
				desc = "DAP: Step Out",
				mode = "n",
			},
			{
				"<leader>di",
				function()
					dap.step_into()
				end,
				desc = "DAP: Step Into",
				mode = "n",
			},
			{
				"<leader>db",
				function()
					dap.toggle_breakpoint()
				end,
				desc = "DAP: Toggle Breakpoint",
				mode = "n",
			},
			{
				"<leader>dl",
				function()
					dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
				end,
				desc = "DAP: Set Breakpoint",
				mode = "n",
			},
			{
				"<leader>dr",
				function()
					dap.run_last()
				end,
				desc = "DAP: Run Last",
				mode = "n",
			},
			{
				"<leader>dt",
				function()
					dap.terminate()
				end,
				desc = "DAP: Terminate",
				mode = "n",
			},
		})
	end,
}
