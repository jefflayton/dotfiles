local deps = require("mini.deps")
local add, now, later = deps.add, deps.now, deps.later

now(function()
	add({ source = "folke/snacks.nvim" })
	require("snacks").setup({
		bigfile = { enabled = true },
	})

	add({ source = "mason-org/mason.nvim" })
	require("mason").setup()
end)

later(function()
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

	add({
		source = "Bekaboo/dropbar.nvim",
		depends = { "nvim-telescope/telescope-fzf-native.nvim" },
	})
	local dropbar_api = require("dropbar.api")
	vim.keymap.set("n", "<leader>;", dropbar_api.pick, { desc = "Dropbar: Pick symbols in winbar" })
	vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Dropbar: Go to start of current context" })
	vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Dropbar: Select next context" })

	add({ source = "windwp/nvim-autopairs" })
	require("nvim-autopairs").setup()
end)
