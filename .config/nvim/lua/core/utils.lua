local ok, lazy = pcall(require, "lazy")
if not ok then
	return
end

------------------------
--- global functions ---
------------------------
-- list functions and urls for sharing, adding to README
--
function PLUGINS()
	for _, value in pairs(lazy.plugins()) do
		print("[" .. value.name .. "](" .. value.url .. ")<br>")
	end
end

-- functions that will be used by rest of config
local M = {}

-- toggle relative line number for the window
-- see https://neovim.io/doc/user/lua-guide.html#lua-guide-options for discussion between o, opt, wo
M.toggle_relative_line = function()
	if vim.wo.relativenumber then
		vim.wo.relativenumber = false
	else
		vim.wo.relativenumber = true
	end
end

-- adapted from https://github.com/tummetott/unimpaired.nvim/blob/main/lua/unimpaired/functions.lua
-- didn't want the whole plugin, since many of the functions are standard in nvim
M.blank_above = function()
	local count = vim.v.count1
	local repeated = vim.fn["repeat"]({ "" }, count)
	local line = vim.api.nvim_win_get_cursor(0)[1]
	vim.api.nvim_buf_set_lines(0, line - 1, line - 1, true, repeated)
	-- move to the top most line
	vim.api.nvim_win_set_cursor(0, { line, 0 })
end

M.blank_below = function()
	local count = vim.v.count1
	local repeated = vim.fn["repeat"]({ "" }, count)
	local line = vim.api.nvim_win_get_cursor(0)[1]
	vim.api.nvim_buf_set_lines(0, line, line, true, repeated)
	-- move to the bottom most line
	vim.api.nvim_win_set_cursor(0, { line + count, 0 })
end

return M
