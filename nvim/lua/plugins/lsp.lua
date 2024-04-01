return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "williamboman/mason.nvim" },
        { "williamboman/mason-lspconfig.nvim" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "folke/neodev.nvim" },
    },
    config = function()
        local lspconfig = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        local on_attach = function(_, bufnr)
            local opts = { buffer = bufnr, remap = false }

            vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
            vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.code_action() end, opts)

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
            pyright = {},
            rust_analyzer = {},
        }

        require("neodev").setup({})

        require("mason").setup({})
        local mason_lspconfig = require("mason-lspconfig")
        mason_lspconfig.setup({
            ensure_installed = vim.tbl_keys(servers),
            automatic_installation = true,
            handlers = {
                function(server)
                    lspconfig[server].setup({
                        capabilities = capabilities,
                        on_attach = on_attach
                    })
                end
            }
        })

    end
}
