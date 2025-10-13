-- define common options
local function keyopts(desc)
	local opts = {
		noremap = true, -- non-recursive
		silent = true, -- do not show message
	}
	if desc then
		opts.desc = desc
	end
	return opts
end

local keymap = vim.keymap

-- toggle relative line number for the window
-- see https://neovim.io/doc/user/lua-guide.html#lua-guide-options for discussion between o, opt, wo
local function toggle_relative_line()
	if vim.wo.relativenumber then
		vim.wo.relativenumber = false
	else
		vim.wo.relativenumber = true
	end
end

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-----------------
-- Normal mode --
-----------------
keymap.set("n", "bd", ":bdelete<cr>", keyopts("Delete the current buffer"))

keymap.set("n", "<CR>", ":nohlsearch<CR>", keyopts("Disable highlights after done with searching"))

-- toggle the relative line number
keymap.set("n", "<leader>r", toggle_relative_line, keyopts("Toggle relative line numbers for pairing"))

-- Visual mode --
-----------------

-----------------
-- Insert mode --
-----------------
-- no longer needed because I remapped caps lock to CTRL
-- keymap.set("i", "kj", "<esc>", keyopts("Exit insert mode with kj"))
