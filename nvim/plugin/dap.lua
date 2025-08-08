local add, later = require("mini.deps").add, require("mini.deps").later

later(function()
	add({
		source = "rcarriga/nvim-dap-ui",
		depends = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
	})

	local dap = require("dap")
	local dapui = require("dapui")
	require("dapui").setup()

	local debuggers = vim.fn.expand("$HOME/tools/debuggers")

	-- JavaScript/TypeScript
	local js_debug_path = vim.fn.expand(debuggers .. "/js-debug/src" .. "/dapDebugServer.js")
	dap.adapters["pwa-node"] = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = {
			command = "node",
			args = { js_debug_path, "${port}" },
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
			request = "attach",
			name = "Attach: Supabase Edge Runtime",
			address = "127.0.0.1",
			port = 8083,
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
			-- only look for .map files in your project
			resolveSourceMapLocations = {
				"${workspaceFolder}/**",
				"!**/node_modules/**",
				"!/var/tmp/sb-compile-edge-runtime/**",
			},
			-- optional quality-of-life
			smartStep = true,
			skipFiles = { "<node_internals>/**", "**/node_modules/**" },
			sourceMapPathOverrides = {
				["file:///home/deno/functions/*"] = "${workspaceFolder}/supabase/functions/*",
			},
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

	local nmap = function(keymap, action, desc)
		vim.keymap.set("n", keymap, action, { desc = "DAP: " .. desc })
	end

	nmap("<leader>ddu", function()
		dapui.toggle()
	end, "Toggle UI")
	nmap("<leader>ddc", function()
		dap.continue()
	end, "Continue")
	nmap("<leader>ddo", function()
		dap.step_over()
	end, "Step Over")
	nmap("<leader>ddO", function()
		dap.step_out()
	end, "Step Out")
	nmap("<leader>ddi", function()
		dap.step_into()
	end, "Step Into")
	nmap("<leader>ddb", function()
		dap.toggle_breakpoint()
	end, "Toggle Breakpoint")
	nmap("<leader>ddl", function()
		dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
	end, "Set Log Point")

	local widgets = require("dap.ui.widgets")
	nmap("<leader>ddp", function()
		widgets.preview()
	end, "Preview")
	nmap("<leader>ddf", function()
		widgets.centered_float(widgets.frames)
	end, "Frames")
	nmap("<leader>dds", function()
		widgets.centered_float(widgets.scopes)
	end, "Scopes")
end)
