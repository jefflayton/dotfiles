local add, later = require("mini.deps").add, require("mini.deps").later

local pickFiles = function(exe)
	return function()
		return coroutine.create(function(coro)
			-- Get executable files asynchronously
			local title = "Files"
			local command = { "fd", "--hidden", "--ignore" }
			if exe then
				title = "Executables"
				table.insert(command, "--type")
				table.insert(command, "x")
			end

			local result = vim.system(command, { text = true }):wait()

			if result.code ~= 0 then
				coroutine.resume(coro, nil)
				return
			end

			local items = {}
			for line in result.stdout:gmatch("[^\r\n]+") do
				if line ~= "" then
					table.insert(items, line)
				end
			end

			local pick = require("mini.pick")
			pick.start({
				source = {
					items = items,
					name = title,
				},
				mappings = {
					select = {
						char = "<CR>",
						func = function()
							local selected = pick.get_picker_matches().current
							if selected then
								pick.stop()
								coroutine.resume(coro, selected)
							end
						end,
					},
					esc = {
						char = "<ESC>",
						func = function()
							pick.stop()
							coroutine.resume(coro, nil)
						end,
					},
				},
				options = {
					prompt = "Path to executable: ",
				},
			})
		end)
	end
end

local pickArgs = function()
	local args_string = vim.fn.input("Program arguments: ")
	return vim.split(args_string, " ", { trimempty = true })
end

later(function()
	add({
		source = "rcarriga/nvim-dap-ui",
		depends = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
	})

	local dap = require("dap")
	local dapui = require("dapui")
	require("dapui").setup()

	-- JavaScript/TypeScript
	local js_debug = vim.fn.exepath("js-debug-adapter")
	dap.adapters["pwa-node"] = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = {
			command = "node",
			args = { js_debug, "${port}" },
		},
	}

	dap.adapters.node = {
		type = "executable",
		command = "node",
		args = { js_debug },
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
			name = "Node: Attach to a Process",
			cwd = "${workspaceFolder}",
			pid = require("dap.utils").pick_process,
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
	local codelldb = vim.fn.exepath("codelldb")
	dap.adapters.codelldb = {
		type = "executable",
		command = codelldb,
	}

	dap.configurations.c = {
		{
			name = "Launch file",
			type = "codelldb",
			request = "launch",
			cwd = "${workspaceFolder}",
			program = pickFiles(true),
			args = pickArgs,
			stopOnEntry = false,
		},
		{
			name = "Launch file with stdin redirect",
			type = "codelldb",
			request = "launch",
			cwd = "${workspaceFolder}",
			program = pickFiles(true),
			args = pickArgs,
			stdio = pickFiles(false),
			stopOnEntry = false,
		},
	}
	dap.configurations.cpp = dap.configurations.c
	dap.configurations.zig = {
		{
			name = "Debug Zig",
			type = "codelldb",
			request = "launch",
			cwd = "${workspaceFolder}",
			program = pickFiles(true),
			args = pickArgs,
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

	local nmap = function(keymap, action, desc)
		vim.keymap.set("n", keymap, action, { desc = "DAP: " .. desc })
	end

	nmap("<leader>ddu", function()
		dapui.toggle()
	end, "Toggle UI")
	nmap("<leader>ddc", function()
		dap.continue()
	end, "Continue")
	nmap("<leader>ddr", function()
		dap.run_last()
	end, "Continue")

	-- Stepping
	nmap("<down>", function()
		dap.step_over()
	end, "Step Over")
	nmap("<left>", function()
		dap.step_out()
	end, "Step Out")
	nmap("<right>", function()
		dap.step_into()
	end, "Step Into")

	-- Breakpoints
	nmap("<leader>ddb", function()
		dap.toggle_breakpoint()
	end, "Toggle Breakpoint")
	nmap("<leader>ddl", function()
		dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
	end, "Set Log Point")

	-- Widgets
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
