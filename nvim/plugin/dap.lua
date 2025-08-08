local add, later = require("mini.deps").add, require("mini.deps").later

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
			-- smartStep = true,
			skipFiles = { "<node_internals>/**", "**/node_modules/**" },
			sourceMapPathOverrides = {
				["file:///home/deno/functions/*"] = "${workspaceFolder}/supabase/functions/*",
			},
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
			program = function()
				return coroutine.create(function(coro)
					-- Get executable files asynchronously

					local result = vim.system({ "fd", "--hidden", "--no-ignore", "--type", "x" }, { text = true })
						:wait()

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
							name = "Executables",
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
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
		},
	}
	dap.configurations.cpp = dap.configurations.c
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
