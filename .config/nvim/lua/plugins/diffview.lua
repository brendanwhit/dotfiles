local ok, diffview = pcall(require, "diffview")
if not ok then
	return
end

local M = {}
local default_branch = nil

local function get_default_branch()
	if default_branch then
		return default_branch
	end

	-- Synchronous call on first use
	local obj = vim.system({ "git", "symbolic-ref", "refs/remotes/origin/HEAD", "--short" }, { text = true }):wait()

	if obj.code == 0 then
		default_branch = vim.trim(obj.stdout):gsub("origin/", "")
	end

	return default_branch
end

-- This function is called by your keybinding
function M.compare_with_default()
	local branch = get_default_branch()
	diffview.open(branch)
end

return M
