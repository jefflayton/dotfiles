return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
		{ "hrsh7th/cmp-nvim-lsp" },
	},
	config = function()
		local lspconfig = require("lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local on_attach = function(_, bufnr)
			local opts = { buffer = bufnr, remap = false }

			vim.keymap.set("n", "<leader>rn", function()
				vim.lsp.buf.rename()
			end, opts)
			vim.keymap.set("n", "<leader>rn", function()
				vim.lsp.buf.code_action()
			end, opts)

			vim.keymap.set("n", "gp", require("telescope.builtin").lsp_definitions, opts)
			vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, otps)
			vim.keymap.set("n", "gI", require("telescope.builtin").lsp_implementations, opts)
			vim.keymap.set("n", "<leader>D", require("telescope.builtin").lsp_type_definitions, opts)
			vim.keymap.set("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols, opts)
			vim.keymap.set("n", "<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, opts)

			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "<C-K>", vim.lsp.buf.signature_help, opts)
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
			vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)

			vim.keymap.set("n", "<leader>ws", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, opts)
		end

		local servers = {
			clangd = {},
			gopls = {},
			pyright = {},
			tsserver = {},
			tailwindcss = {},
		}

		require("mason").setup({})
		local mason_lspconfig = require("mason-lspconfig")
		mason_lspconfig.setup({
			ensure_installed = vim.tbl_keys(servers),
			automatic_installation = true,
			handlers = {
				function(server)
					lspconfig[server].setup({
						capabilities = capabilities,
						on_attach = on_attach,
					})
				end,
			},
		})

		require("which-key").add({
			{
				"<leader>rn",
				function()
					vim.lsp.buf.rename()
				end,
				desc = "LSP rename",
				mode = "n",
			},
			{
				"<leader>rn",
				function()
					vim.lsp.buf.code_action()
				end,
				desc = "LSP code action",
				mode = "n",
			},
			{ "gp", require("telescope.builtin").lsp_definitions, desc = "LSP definitions", mode = "n" },
			{ "gr", require("telescope.builtin").lsp_references, desc = "LSP references", mode = "n" },
			{ "gI", require("telescope.builtin").lsp_implementations, desc = "LSP implementations", mode = "n" },
			{
				"<leader>D",
				require("telescope.builtin").lsp_type_definitions,
				desc = "LSP type definitions",
				mode = "n",
			},
			{
				"<leader>ds",
				require("telescope.builtin").lsp_document_symbols,
				desc = "LSP document symbols",
				mode = "n",
			},
			{
				"<leader>ws",
				require("telescope.builtin").lsp_dynamic_workspace_symbols,
				desc = "LSP workspace symbols",
				mode = "n",
			},
			{ "K", vim.lsp.buf.hover, desc = "LSP hover", mode = "n" },
			{ "<C-K>", vim.lsp.buf.signature_help, desc = "LSP signature help", mode = "n" },
			{ "gD", vim.lsp.buf.declaration, desc = "LSP declaration", mode = "n" },
			{ "<leader>wa", vim.lsp.buf.add_workspace_folder, desc = "LSP add workspace folder", mode = "n" },
			{ "<leader>wr", vim.lsp.buf.remove_workspace_folder, desc = "LSP remove workspace folder", mode = "n" },
			{
				"<leader>ws",
				function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end,
				desc = "LSP workspace folders",
				mode = "n",
			},
		})
	end,
}
