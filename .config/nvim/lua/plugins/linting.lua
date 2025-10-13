return {
	{
		"mfussenegger/nvim-lint",
		enabled = false,
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				python = { "mypy" },
			}

			-- overrideable options set here https://github.com/mfussenegger/nvim-lint/blob/9c6207559297b24f0b7c32829f8e45f7d65b991f/lua/lint/linters/mypy.lua
			lint.linters.mypy.cmd = "pdm run mypy"
			-- setting env requires the linter to be called with the given path
			lint.linters.mypy.env = nil

			-- set an augroup, don't understand why
			-- https://www.josean.com/posts/neovim-linting-and-formatting
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

			-- automatically try linting
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
}
