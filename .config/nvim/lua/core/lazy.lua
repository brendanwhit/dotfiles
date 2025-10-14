-- following the structured setup https://lazy.folke.io/installation
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.runtimepath:prepend(lazypath)

local ok, lazy = pcall(require, "lazy")
if not ok then
	print("lazy not installed")
	return
end
--------------------
--- plugins list ---
--------------------
local plugins = {
	require("plugins.coding"),
	require("plugins.colorscheme"),
	require("plugins.context"),
	require("plugins.editor"),
	require("plugins.git"),
	require("plugins.linting"),
	require("plugins.lsp"),
	require("plugins.navigation"),
	{
		"sindrets/diffview.nvim",
		keys = {
			{
				"<leader>pr",
				function()
					require("plugins.diffview").compare_with_default()
				end,
				{ desc = "Compare as if PR" },
			},
		},
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = function()
			return require("plugins.conform").keys
		end,
		opts = function()
			return require("plugins.conform").opts
		end,
		init = function()
			return require("plugins.conform").init
		end,
	},
}

local opts = {
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
}

lazy.setup(plugins, opts)
