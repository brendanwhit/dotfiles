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

local ok, utils = pcall(require, "core.utils")
if not ok then
	return
end

-----------------
-- Normal mode --
-----------------
keymap.set("n", "bd", ":bdelete<cr>", keyopts("Delete the current buffer"))

keymap.set("n", "<CR>", ":nohlsearch<CR>", keyopts("Disable highlights after done with searching"))

-- toggle the relative line number
keymap.set("n", "<leader>r", utils.toggle_relative_line, keyopts("Toggle relative line numbers for pairing"))

-- Visual mode --
-----------------

-----------------
-- Insert mode --
-----------------
-- no longer needed because I remapped caps lock to CTRL
-- keymap.set("i", "kj", "<esc>", keyopts("Exit insert mode with kj"))
