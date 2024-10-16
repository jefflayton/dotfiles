return {
	"mhartington/formatter.nvim",
	config = function()
		local util = require("formatter.util")

		local mason = require("mason")
		local mason_registry = require("mason-registry")

		mason.setup({
			ensure_installed = {
				"clang-format",
				"stylua",
				"shfmt",
				"prettier",
				"gofmt",
				"google-java-format",
			},
		})

		-- Define the Prettier formatter function
		local usePrettier = function()
			return {
				exe = "npx",
				args = {
					"prettier",
					"--stdin-filepath",
					util.escape_path(util.get_current_buffer_file_path()),
				},
				stdin = true,
			}
		end

		-- Define the Stylua formatter function
		local useStylua = function()
			return {
				exe = "stylua",
				args = { "-" },
				stdin = true,
			}
		end

		-- Define the Gofmt formatter function
		local useGofmt = function()
			return {
				exe = "gofmt",
				stdin = true,
			}
		end

		-- Define the clang-format formatter function
		local useClangFormat = function()
			return {
				exe = "clang-format",
				args = { "-style=file:/Users/jeffreylayton/.config/.clang-format" },
				stdin = true,
			}
		end

		local useShfmt = function()
			local shiftwidth = vim.opt.shiftwidth:get()

			return {
				exe = "shfmt",
				args = { "-i", shiftwidth, "-ci", "-bn", "-w" },
				stdin = true,
			}
		end

		local useJavaFormat = function()
			return {
				exe = "google-java-format",
				args = { "--replace" },
				stdin = true,
			}
		end

		require("formatter").setup({
			logging = false,
			filetype = {
				-- Use clang-format for C/C++ files
				c = { useClangFormat },
				cpp = { useClangFormat },

				-- Use google-java-format for Java files
				java = { useJavaFormat },

				-- Use Stylua for Lua files
				lua = { useStylua },

				-- Use Gofmt for Go files
				go = { useGofmt },

				-- Use Prettier for JavaScript and TypeScript files
				json = { usePrettier },
				javascript = { usePrettier },
				javascriptreact = { usePrettier },
				typescript = { usePrettier },
				typescriptreact = { usePrettier },

				-- Use Shfmt for Shell files
				sh = { useShfmt },
				bash = { useShfmt },
			},
		})

		-- Automatically format on save
		vim.api.nvim_create_augroup("FormatAutgroup", { clear = true })
		vim.api.nvim_create_autocmd("BufWritePost", {
			group = "FormatAutgroup",
			pattern = "*",
			callback = function()
				vim.cmd("FormatWrite")
			end,
		})

		require("which-key").add({
			{
				"<leader>fm",
				function()
					vim.cmd("FormatWrite")
				end,
				desc = "Format: Format",
				mode = "n",
			},
		})
	end,
}
