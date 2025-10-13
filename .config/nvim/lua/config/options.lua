local o = vim.opt

-- Hint: use `:h <option>` to figure out the meaning if needed
o.clipboard = "unnamedplus" -- use system clipboard
o.completeopt = { "menu", "menuone", "noselect" }
o.mouse = "a" -- allow the mouse to be used

-- Tab (update to change for filetype)
o.tabstop = 4 -- number of visual spaces per TAB
o.softtabstop = 4 -- number of spaces in tab when editing
o.shiftwidth = 4 -- insert 4 spaces on a tab
o.expandtab = true -- tabs are spaces, mainly because of python

-- UI config
o.number = true -- show absolute number
o.relativenumber = true -- add numbers to each line on the left side
o.cursorline = true -- highlight cursor line underneath the cursor
o.splitbelow = true -- open new vertical split bottom
o.splitright = true -- open new horizontal split right

-- Searching
o.incsearch = true -- search as characters are entered
o.hlsearch = true -- highlight matches
o.ignorecase = true -- ignore case searches by default
o.smartcase = true -- make it case sensitive if an uppercase is entered

-- Get rid of swapfiles by using persistent undo file
o.undofile = true
o.swapfile = false

-- DiffOrig command to compare unsaved buffer with file
-- https://neovim.io/doc/user/diff.html#%3ADiffOrig
vim.api.nvim_create_user_command(
	"DiffOrig",
	"vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis | wincmd p | diffthis",
	{ desc = "Compare unsaved buffer with file" }
)
