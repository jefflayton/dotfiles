return {
	"vim-test/vim-test",
	config = function()
		vim.g["test#strategy"] = "neovim"

		-- Set custom patterns for Deno test files
		vim.g["test#typescript#deno#file_pattern"] = "\\v(test|_test|\\.test)\\.ts$"
		vim.g["test#javascript#deno#file_pattern"] = "\\v(test|_test|\\.test)\\.js$"

		-- Make sure deno is the test runner for TypeScript and JavaScript
		vim.g["test#typescript#runner"] = "deno"
		vim.g["test#javascript#runner"] = "deno"

		-- Define the command for running Deno tests
		vim.g["test#custom_strategies"] = {
			deno = {
				test_file = function(file)
					return "deno test " .. file
				end,
				test_nearest = function(file, line)
					return "deno test " .. file .. " --filter " .. line
				end,
			},
		}

		require("which-key").add({
			{
				"<leader>nt",
				function()
					vim.cmd("TestNearest")
				end,
				desc = "VimTest: Run nearest",
				mode = "n",
			},
			{
				"<leader>ntt",
				function()
					vim.cmd("TestFile")
				end,
				desc = "VimTest: Run file",
				mode = "n",
			},
			{
				"<leader>ntr",
				function()
					vim.cmd("TestLast")
				end,
				desc = "VimTest: Rerun",
				mode = "n",
			},
			{
				"<leader>ntc",
				function()
					vim.cmd("TestClose")
				end,
				desc = "VimTest: Close",
				mode = "n",
			},
			{
				"<leader>ntl",
				function()
					vim.cmd("TestOpen")
				end,
				desc = "VimTest: Open",
				mode = "n",
			},
			{
				"<leader>nto",
				function()
					vim.cmd("TestOutput")
				end,
				desc = "VimTest: Open output",
				mode = "n",
			},
		})
	end,
}
