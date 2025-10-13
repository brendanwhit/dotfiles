return {
	{
		"mason-org/mason.nvim",
		lazy = false,
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
			ensure_installed = {
				-- LSPs
				"lua-language-server",
				"python-lsp-server",
				"ruff",
				"typescript-language-server",
				"ruby-lsp",

				-- Formatters
				"prettier",
				"prettierd",
				"stylua",
				"rubocop",
			},
		},
	},
}
