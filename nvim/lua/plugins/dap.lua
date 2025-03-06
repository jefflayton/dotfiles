local install_tools = function()
	require("mason").setup()
	require("mason-nvim-dap").setup({
		automatic_installation = true,
		ensure_installed = {
			"js",
		},
		handlers = {
			function(config)
				require("mason-nvim-dap").default_setup(config)
			end,
		},
	})
end

return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",
		{ "theHamsta/nvim-dap-virtual-text", opts = {} },
	},
	config = function()
		local dap = require("dap")

		install_tools()

		local mason_registry = require("mason-registry")
		local js_debug = mason_registry.get_package("js-debug-adapter") -- note that this will error if you provide a non-existent package name
		local js_debug_path = js_debug:get_install_path()

		dap.adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "node",
				args = { js_debug_path .. "/js-debug/src/dapDebugServer.js", "${port}" },
			},
		}
		dap.configurations.typescript = {

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

		require("which-key").add({
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
		})
	end,
}
