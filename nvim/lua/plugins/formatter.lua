return {
	"mhartington/formatter.nvim",
	config = function()
		local util = require("formatter.util")

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

		-- Define the Deno formatter function
		local useDeno = function()
			return {
				exe = "deno",
				args = { "fmt", "-" },
				stdin = true,
			}
		end

		local formatTypescript = function()
			local cwd = vim.fn.getcwd()
			local is_deno = vim.fn.filereadable(cwd .. "/deno.json") == 1
				or vim.fn.filereadable(cwd .. "/deno.jsonc") == 1

			if is_deno then
				return useDeno()
			else
				return usePrettier()
			end
		end

		-- Define the Stylua formatter function
		local useStylua = function()
			return {
				exe = "stylua",
				args = { "-" },
				stdin = true,
			}
		end

		-- Define the Clang-format formatter function
		local useClangFormat = function()
			return {
				exe = "clang-format",
				args = { "--style='{IndentWidth: 4}'" },
				stdin = true,
			}
		end

		-- Define Clang-format for Java files
		local useClangFormatJava = function()
			return {
				exe = "clang-format",
				args = {
					"--style='{BasedOnStyle: Chromium}'",
				},
				stdin = true,
			}
		end

		-- Define the pgFormatter formatter function
		local useSQLFluff = function()
			return {
				exe = "sqlfluff",
				args = {
					"format",
					"--disable-progress-bar",
					"--nocolor",
					"-",
				},
				stdin = true,
				ignore_exitcode = false,
			}
		end

		require("formatter").setup({
			logging = false,
			filetype = {
				lua = { useStylua },
				json = { usePrettier },
				javascript = { usePrettier },
				javascriptreact = { usePrettier },
				typescript = { formatTypescript },
				typescriptreact = { usePrettier },
				c = { useClangFormat },
				cpp = { useClangFormat },
				java = { useClangFormatJava },
				sql = { useSQLFluff },
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
	end,
}
