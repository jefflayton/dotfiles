return {
	"mfussenegger/nvim-dap",
	dependencies = {
		{
			"rcarriga/nvim-dap-ui",
			dependencies = {
				"mfussenegger/nvim-dap",
			},
		},
		"leoluz/nvim-dap-go",
	},
	config = function()
		require("mason").setup({
			ensure_installed = { "codelldb" },
			automatic_installation = true,
		})

		local mason_registry = require("mason-registry")
		local codelldb_root = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"

		local codelldb_path = codelldb_root .. "adapter/codelldb"
		local liblldb_path = codelldb_root .. "lldb/lib/liblldb.dylib"

		local dap = require("dap")

		require("dap-go").setup()

		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			host = "127.0.0.1",
			executable = {
				command = codelldb_path,
				args = { "--liblldb", liblldb_path, "--port", "${port}" },
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

		vim.keymap.set("n", "<leader>dd", function()
			dap.continue()
		end)

		vim.keymap.set("n", "<leader>do", function()
			dap.step_over()
		end)

		vim.keymap.set("n", "<leader>dO", function()
			dap.step_out()
		end)

		vim.keymap.set("n", "<leader>di", function()
			dap.step_into()
		end)

		vim.keymap.set("n", "<leader>db", function()
			dap.toggle_breakpoint()
		end)

		vim.keymap.set("n", "<leader>dl", function()
			dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
		end)

		vim.keymap.set("n", "<leader>dr", function()
			dap.run_last()
		end)

		vim.keymap.set("n", "<leader>dt", function()
			dap.terminate()
		end)

		require("which-key").add({
			{
				"<leader>dd",
				function()
					dap.continue()
				end,
				desc = "DAP Continue",
				mode = "n",
			},
			{
				"<leader>do",
				function()
					dap.step_over()
				end,
				desc = "DAP Step Over",
				mode = "n",
			},
			{
				"<leader>dO",
				function()
					dap.step_out()
				end,
				desc = "DAP Step Out",
				mode = "n",
			},
			{
				"<leader>di",
				function()
					dap.step_into()
				end,
				desc = "DAP Step Into",
				mode = "n",
			},
			{
				"<leader>db",
				function()
					dap.toggle_breakpoint()
				end,
				desc = "DAP Toggle Breakpoint",
				mode = "n",
			},
			{
				"<leader>dl",
				function()
					dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
				end,
				desc = "DAP Set Breakpoint",
				mode = "n",
			},
			{
				"<leader>dr",
				function()
					dap.run_last()
				end,
				desc = "DAP Run Last",
				mode = "n",
			},
			{
				"<leader>dt",
				function()
					dap.terminate()
				end,
				desc = "DAP Terminate",
				mode = "n",
			},
		})
	end,
}
