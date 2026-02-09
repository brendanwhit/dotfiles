---@brief
---
--- https://github.com/yioneko/vtsls
---
--- A faster TypeScript language server using native tsserver protocol.
--- Install via: npm install -g @vtsls/language-server

---@type vim.lsp.Config
return {
	cmd = { "vtsls", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
	settings = {
		typescript = {
			-- Inlay hints: inline type annotations (toggle with <leader>dh)
			-- parameterNames: show arg names at call sites -> greet(/* name: */ "Bob")
			-- parameterTypes: show param types in signatures
			-- variableTypes: show inferred types -> const x/* : number */ = 5
			-- propertyDeclarationTypes: show types on class properties
			-- functionLikeReturnTypes: show return types -> const fn = ()/* : string */ => "hi"
			-- enumMemberValues: show enum values -> Up/* = 0 */
			inlayHints = {
				parameterNames = { enabled = "literals" },
				parameterTypes = { enabled = true },
				variableTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				enumMemberValues = { enabled = true },
			},
		},
		javascript = {
			inlayHints = {
				parameterNames = { enabled = "literals" },
				parameterTypes = { enabled = true },
				variableTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				enumMemberValues = { enabled = true },
			},
		},
		vtsls = {
			-- Use the workspace's TypeScript version if available
			autoUseWorkspaceTsdk = true,
		},
	},
}
