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
keymap.set("n", "bd", "<CMD>bdelete<CR>", keyopts("Delete the current buffer"))

keymap.set("n", "<CR>", "<CMD>nohlsearch<CR>", keyopts("Disable highlights after done with searching"))

-- toggle the relative line number
keymap.set("n", "<leader>r", utils.toggle_relative_line, keyopts("Toggle relative line numbers for pairing"))

-- swap how tab cycling and tag cycling work
keymap.set("n", "[t", "gT", keyopts("move back one tab"))
keymap.set("n", "]t", "gt", keyopts("move forward one tab"))

keymap.set("n", "gT", "[t", keyopts("move back one tag"))
keymap.set("n", "gt", "]t", keyopts("move forward one tag"))

keymap.set("n", "[<Space>", utils.blank_above, keyopts("Add count blank lines above current line"))
keymap.set("n", "]<Space>", utils.blank_below, keyopts("Add count blank lines below current line"))

-- Oil command to back out of file
keymap.set("n", "-", "<CMD>Oil<CR>", keyopts("Open parent directory"))

-----------------
-- Visual mode --
-----------------

-----------------
-- Insert mode --
-----------------
