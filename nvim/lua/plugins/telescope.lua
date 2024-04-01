return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-dap.nvim" },
    },
    config = function()
        local telescope = require("telescope")
        telescope.setup({})

        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>ff", builtin.find_files)
        vim.keymap.set("n", "<leader>fg", builtin.live_grep)
        vim.keymap.set("n", "<leader>fb", builtin.buffers)
        vim.keymap.set("n", "<leader>fh", builtin.help_tags)

        telescope.load_extension("dap")
        vim.keymap.set("n", "<leader>dlb", function() telescope.extensions.dap.list_breakpoints({}) end)
        vim.keymap.set("n", "<leader>dlv", function() telescope.extensions.dap.variables({}) end)
        vim.keymap.set("n", "<leader>dlf", function() telescope.extensions.dap.frames({}) end)
        vim.keymap.set("n", "<leader>dlc", function() telescope.extensions.dap.commands({}) end)

    end
}

