local deps = require("mini.deps")
local add, now, later = deps.add, deps.now, deps.later

now(function()
	add({ source = "folke/snacks.nvim" })
	require("snacks").setup({
		bigfile = { enabled = true },
	})
end)

later(function()
	add({ source = "mason-org/mason.nvim" })
	require("mason").setup()

	add({ source = "folke/lazydev.nvim" })
	require("lazydev").setup({
		library = {
			path = "${3rd}/luv/library",
			words = { "vim%.uv" },
			library = { "nvim-dap-ui" },
		},
	})

	add({ source = "aserowy/tmux.nvim" })
	require("tmux").setup({ copy_sync = { enable = false } })

	add({ source = "chomosuke/typst-preview.nvim" })
	require("typst-preview").setup()

	add({ source = "lewis6991/gitsigns.nvim" })
	require("gitsigns").setup({ current_line_blame = true })

	add({ source = "sindrets/diffview.nvim" })
	vim.keymap.set("n", "<leader>dvo", "<cmd>DiffviewOpen<cr>", { desc = "Git: Open Diffview" })
	vim.keymap.set("n", "<leader>dvc", "<cmd>DiffviewClose<cr>", { desc = "Git: Close Diffview" })

	add({ source = "OXY2DEV/markview.nvim" })
	require("markview").setup({
		experimental = { check_rtp = false },
		latex = {
			enable = true,
		},
		typst = {
			enable = false,
		},
	})

	add({ source = "preservim/vim-pencil" })
	vim.api.nvim_create_augroup("Pencil", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = "Pencil",
		pattern = "text",
		callback = function()
			vim.cmd("PencilSoft")
		end,
	})

	add({ source = "andrewferrier/debugprint.nvim" })
	require("debugprint").setup({
		highlight_lines = false,
		display_counter = false,
		print_tag = "",
	})

	add({ source = "cameron-wags/rainbow_csv.nvim" })
	require("rainbow_csv").setup()

	add({ source = "windwp/nvim-ts-autotag" })
	require("nvim-ts-autotag").setup()
end)
