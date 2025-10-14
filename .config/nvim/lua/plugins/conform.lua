local conform_ok, conform = pcall(require, "conform")
if not conform_ok then
	return
end

-- be able to turn formatting on and off globally or for a single buffer
vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
})

-- set a keybinding to toggle enable and disable
vim.keymap.set("n", "<leader>F", function()
	if vim.b.disable_autoformat or vim.g.disable_autoformat then
		vim.cmd("FormatEnable")
		vim.notify("Formatting enabled")
	else
		vim.cmd("FormatDisable")
		vim.notify("Formatting disabled")
	end
end, { desc = "Toggle [F]ormat" })

local M = {}

M.opts = {
	log_level = vim.log.levels.DEBUG,
	-- Define your formatterse
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_fix", "ruff_format" },
		json = { "jq" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		typscript = { "prettierd", "prettier", stop_after_first = true },
		sql = { "sqruff" },
		ruby = { "rubocop" },
	},
	-- Set default options
	default_format_opts = {
		lsp_format = "fallback",
	},
	-- Set up format-on-save
	format_on_save = function(bufnr)
		-- Don't format on save for client_data_transformations, not until I figure out sql formatting settings
		local bufname = vim.api.nvim_buf_get_name(bufnr)
		if bufname:match("/client_data_transformations/") then
			vim.notify("Auto formatting disabled for client_data_transformations")
			return
		end
		-- Disable with a global or buffer-local variable
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			vim.notify("Formatting disabled")
			return
		end
		return { timeout_ms = 500, lsp_format = "fallback" }
	end,
	-- Customize formatters
	formatters = {
		shfmt = {
			prepend_args = { "-i", "2" },
		},
	},
}

M.keys = {
	{
		-- Customize or remove this keymap to your liking
		"<leader>f",
		function()
			conform.format({ async = true, lsp_format = "fallback" })
		end,
		mode = "",
		desc = "Format buffer",
	},
}

M.init = function()
	-- If you want the formatexpr, here is the place to set it
	vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
end

return M
