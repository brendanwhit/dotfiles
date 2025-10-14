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
		print("[" .. value.name .. "](" .. value.url .. ")")
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

return M
