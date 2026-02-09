---@brief
---
--- https://github.com/DetachHead/basedpyright
---
--- A fast Python language server forked from pyright with additional features.
--- Install via: pipx install basedpyright
---
--- Note: mypy diagnostics come from pylsp (configured separately).
--- This LSP handles: completions, go-to-definition, hover, references, auto-import.

---@type vim.lsp.Config
return {
	cmd = { "basedpyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = {
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		"pyrightconfig.json",
		".git",
	},
	settings = {
		basedpyright = {
			analysis = {
				-- Automatically add paths for imports
				autoSearchPaths = true,
				-- Use type stubs from installed packages
				useLibraryCodeForTypes = true,
				-- "openFilesOnly" = faster, only analyzes open files
				-- "workspace" = slower, analyzes entire project but catches cross-file errors
				diagnosticMode = "workspace",
			},
		},
	},
}
