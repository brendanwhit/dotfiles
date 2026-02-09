---------------------------------
--- general lsp configuration ---
---------------------------------
--- modified from https://github.com/gennaro-tedesco/dotfiles/blob/master/nvim/lua/lsp.lua
vim.lsp.config("*", {
	root_markers = { ".git" },
	capabilities = {
		textDocument = {
			semanticTokens = {
				multilineTokenSupport = true,
			},
		},
	},
})

local configs = {}

-- enable all of the lsps in the lsp/ directory
for _, v in ipairs(vim.api.nvim_get_runtime_file("lsp/*", true)) do
	local name = vim.fn.fnamemodify(v, ":t:r")
	configs[name] = true
end

vim.lsp.enable(vim.tbl_keys(configs))

-------------------------------------------
---         :LspList command            ---
-------------------------------------------
vim.api.nvim_create_user_command("LspList", function()
	local lsp_dir = vim.fn.stdpath("config") .. "/lsp"
	local configured = {}

	-- Get all configured LSPs from lsp/ directory
	for _, file in ipairs(vim.fn.glob(lsp_dir .. "/*.lua", false, true)) do
		local name = vim.fn.fnamemodify(file, ":t:r")
		local config = dofile(file)
		local cmd = config.cmd and config.cmd[1] or name
		local installed = vim.fn.executable(cmd) == 1
		local filetypes = config.filetypes or {}
		configured[name] = {
			cmd = cmd,
			installed = installed,
			filetypes = filetypes,
		}
	end

	-- Get active LSP clients
	local active_clients = {}
	for _, client in ipairs(vim.lsp.get_clients()) do
		active_clients[client.name] = true
	end

	-- Build output
	local lines = { "Configured LSPs:" }
	local sorted_names = vim.tbl_keys(configured)
	table.sort(sorted_names)

	for _, name in ipairs(sorted_names) do
		local info = configured[name]
		local status = info.installed and "✓" or "✗"
		local active = active_clients[name] and " (active)" or ""
		local ft = #info.filetypes > 0 and " [" .. table.concat(info.filetypes, ", ") .. "]" or ""
		table.insert(lines, string.format("  %s %s%s%s", status, name, active, ft))
	end

	vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end, { desc = "List configured LSPs and their status" })

-------------------------------------------
--- diagnostics: linting and formatting ---
-------------------------------------------
-- Diagnostic config, show the errors for the current line
vim.diagnostic.config({
	-- virtual_text = { current_line = true, prefix = "●", source = true },
	virtual_lines = { current_line = true, prefix = "●", source = true },
	update_in_insert = false,
	float = {
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
		focusable = false,
	},
})

-------------------------------------------
---           lsp autocommands          ---
-------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
		local bufopts = { noremap = true, silent = true, buffer = bufnr }

		--- toggle diagnostics
		vim.g.diagnostics_visible = true
		local function toggle_diagnostics()
			if vim.g.diagnostics_visible then
				vim.g.diagnostics_visible = false
				vim.diagnostic.enable(false)
			else
				vim.g.diagnostics_visible = true
				vim.diagnostic.enable(true)
			end
		end

		vim.keymap.set(
			"n",
			"gd",
			vim.lsp.buf.definition,
			vim.tbl_extend("force", bufopts, { desc = "lsp go to definition" })
		)
		-- vim.keymap.set(
		-- 	"n",
		-- 	"gr",
		-- 	require("fzf-lua").lsp_references({ ignore_current_line = true }),
		-- 	vim.tbl_extend("force", bufopts, { desc = "lsp go to references" })
		-- )
		vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", bufopts, { desc = "lsp hover for docs" }))
		vim.keymap.set("n", "rn", vim.lsp.buf.rename, vim.tbl_extend("force", bufopts, { desc = "lsp rename" }))
		vim.keymap.set(
			"n",
			"<leader>d",
			toggle_diagnostics,
			vim.tbl_extend("force", bufopts, { desc = "lsp toggle diagnostics" })
		)
		vim.keymap.set("n", "<leader>dh", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ nil }))
		end, vim.tbl_extend("force", bufopts, { desc = "lsp toggle inlay hints" }))
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_codeAction) then
			-- match VScode keymap
			vim.keymap.set("n", "<c-.>", function()
				require("fzf-lua").lsp_code_actions()
			end, { desc = "lsp code actions" })
		end
	end,
})
