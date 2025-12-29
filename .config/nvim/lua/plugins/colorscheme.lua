return {
	-- {
	-- 	"catppuccin/nvim",
	-- 	lazy = false,
	-- 	prority = 1000,
	-- 	config = function()
	-- 		vim.cmd.colorscheme("catppuccin")
	-- 	end,
	-- },
	{
		"ellisonleao/gruvbox.nvim",
		enabled = false,
		lazy = false,
		priority = 1000,
		opts = { transparent_mode = true },
		config = function(_, opts)
			local cs = require("gruvbox")
			cs.setup(opts)
			cs.load()
		end,
	},
	{
		"folke/tokyonight.nvim",
		enabled = true,
		lazy = false,
		priority = 999,
		opts = { style = "storm" },
		config = function(_, opts)
			local cs = require("tokyonight")
			cs.setup(opts)
			cs.load()
		end,
	},
}
