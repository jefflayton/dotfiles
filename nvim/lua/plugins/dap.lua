return {
	"mfussenegger/nvim-dap",
	dependencies = {
		{ "theHamsta/nvim-dap-virtual-text" },
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

		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			host = "127.0.0.1",
			executable = {
				command = codelldb_path,
				args = { "--liblldb", liblldb_path, "--port", "${port}" },
			},
		}

		dap.configurations.cpp = {
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

		dap.configurations.rust = dap.configurations.cpp

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

		require("nvim-dap-virtual-text").setup({
			prefix = "ﬦ ",
			enabled = true,
			hl = "Comment",
		})
	end,
}
