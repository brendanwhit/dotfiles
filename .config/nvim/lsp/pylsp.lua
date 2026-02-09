---@brief
---
--- https://github.com/python-lsp/python-lsp-server
---
--- Configured as a mypy-only LSP. All other features (completions, go-to-def,
--- hover, etc.) are handled by basedpyright which is much faster.
---
--- Install via:
---   pipx install 'python-lsp-server[rope]'
---   pipx inject python-lsp-server pylsp-mypy

---@type vim.lsp.Config
return {
	cmd = { "pylsp" },
	filetypes = { "python" },
	root_markers = {
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		"mypy.ini",
		".git",
	},
	settings = {
		pylsp = {
			plugins = {
				-- Disable everything - basedpyright handles these
				pycodestyle = { enabled = false },
				pyflakes = { enabled = false },
				mccabe = { enabled = false },
				autopep8 = { enabled = false },
				yapf = { enabled = false },
				pylsp_black = { enabled = false },
				pylsp_isort = { enabled = false },
				jedi_completion = { enabled = false },
				jedi_hover = { enabled = false },
				jedi_references = { enabled = false },
				jedi_signature_help = { enabled = false },
				jedi_symbols = { enabled = false },
				jedi_definition = { enabled = false },
				jedi_rename = { enabled = false },

				-- Keep rope_autoimport for auto-import on completion
				-- (adds imports automatically when you complete a symbol)
				rope_autoimport = { enabled = true },

				-- mypy - the reason this LSP exists
				pylsp_mypy = {
					enabled = true,
					dmypy = true, -- use daemon for speed
					live_mode = false, -- run on save, not on every keystroke
				},
			},
		},
	},
}
