return {
	{
		"sindrets/diffview.nvim",
		keys = {
			{
				"<leader>pr",
				":DiffviewOpen origin/master<CR>",
				{ desc = "Compare as if PR" },
			},
		},
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration

			-- Only one of these is needed.
			-- "nvim-telescope/telescope.nvim", -- optional
			"ibhagwan/fzf-lua", -- optional
			-- "echasnovski/mini.pick",         -- optional
			-- "folke/snacks.nvim", -- optional
			-- TODO: switch to mini.pick at some point
		},
		keys = {
			{
				"<leader>G",
				function()
					require("neogit").open()
				end,
				{ desc = "Spawn Neogit" },
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end)

				map("n", "[h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end)

				-- Actions
				map("n", "<leader>hs", gitsigns.stage_hunk)
				map("n", "<leader>hr", gitsigns.reset_hunk)

				map("v", "<leader>hs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end)

				map("v", "<leader>hr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end)

				map("n", "<leader>hS", gitsigns.stage_buffer)
				map("n", "<leader>hR", gitsigns.reset_buffer)
				map("n", "<leader>hp", gitsigns.preview_hunk)
				map("n", "<leader>hi", gitsigns.preview_hunk_inline)

				map("n", "<leader>hb", function()
					gitsigns.blame_line({ full = true })
				end)

				map("n", "<leader>hd", gitsigns.diffthis)

				map("n", "<leader>hD", function()
					gitsigns.diffthis("~")
				end)

				map("n", "<leader>hQ", function()
					gitsigns.setqflist("all")
				end)
				map("n", "<leader>hq", gitsigns.setqflist)

				-- Toggles
				map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
				map("n", "<leader>tw", gitsigns.toggle_word_diff)

				-- Text object
				map({ "o", "x" }, "ih", gitsigns.select_hunk)
			end,
		},
	},
	-- create git links for sharing
	{
		"trevorhauter/gitportal.nvim",
		keys = {
			{
				"<leader>gy",
				mode = { "n", "v" },
				function()
					require("gitportal").copy_link_to_clipboard()
				end,
				{ desc = "Git portal: Copy link to github to clipboard" },
			},
			{
				"<leader>go",
				mode = { "n", "v" },
				function()
					require("gitportal").open_file_in_browser()
				end,
				{ desc = "Git portal: Open file in github" },
			},
			{
				"<leader>gf",
				mode = { "n" },
				function()
					require("gitportal").open_file_in_neovim()
				end,
				{ desc = "Git portal: Open github link in neovim" },
			},
		},
		opts = {
			always_include_current_line = true,
		},
	},
}
