local deps = require("mini.deps")
local add, now, later = deps.add, deps.now, deps.later

now(function()
	add({ source = "mason-org/mason.nvim" })
	require("mason").setup()

	add({ source = "preservim/vim-pencil" })
	vim.api.nvim_create_augroup("Pencil", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = "Pencil",
		pattern = { "text", "markdown", "typst" },
		callback = function()
			vim.cmd("PencilSoft")
		end,
	})
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
		preview = { icon_provider = "mini" },
		latex = {
			enable = true,
		},
		typst = {
			enable = false,
		},
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

	add({ source = "shortcuts/no-neck-pain.nvim" })
	require("no-neck-pain").setup({
		width = 200,
	})
	vim.keymap.set("n", "<leader>np", "<CMD>NoNeckPain<CR>", { desc = "NoNeckPain: Toggle" })
end)
