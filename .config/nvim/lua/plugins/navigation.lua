return {
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
		-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
		lazy = false,
	},
	-- seeing if snacks can replace this all
	{
		"nvim-telescope/telescope.nvim",
		enabled = false,
		tag = "0.1.8", -- or, branch = '0.1.x',
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- below is a way to recreate the config loading function in the keys section, which eliminates the need for a config function
		-- see https://github.com/LazyVim/LazyVim/blob/25abbf546d564dc484cf903804661ba12de45507/lua/lazyvim/plugins/editor.lua#L30 for more examples
		-- keys = {
		--    { "<C-p>", mode = { "n" }, function() require('telescope.builtin').find_files() end, desc = "Telescope find files" },
		--    {"<leader>fg", mode = { "n" }, function() require('telescope.builtin').live_grep() end, desc = "Telescope live grep" }
		--},
		opts = {
			defaults = {
				path_display = "filename_first",
			},
		},
		config = function(_, opts)
			local builtin = require("telescope.builtin")

			require("telescope").setup(opts)

			vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Telescope find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

			-- lsp telescope settings
			vim.keymap.set("n", "<leader>gd", builtin.lsp_definitions, { desc = "Telescope definitions" })
			vim.keymap.set("n", "<leader>gr", builtin.lsp_references, { desc = "Telescope references" })
		end,
	},
	-- -- telescope extensions, use fzf when looking for files
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		enabled = false,
		build = "make",
		config = function()
			require("telescope").setup({
				extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					},
				},
			})
			-- To get fzf loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("fzf")
		end,
	},
	-- -- telescope extensions, use a nice ui box for code actions
	{
		"nvim-telescope/telescope-ui-select.nvim",
		enabled = false,
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_cursor({}),
					},
				},
			})
			-- To get ui-select loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("ui-select")
		end,
	},
	-- -- telscope extension, use a nice ui box for lsp actions
	{
		"gbrlsnchs/telescope-lsp-handlers.nvim",
		enabled = false,
		config = function()
			require("telescope").setup({
				extensions = {
					lsp_handlers = {
						code_action = {
							telescope = require("telescope.themes").get_cursor({}),
						},
						location = {
							telescope = require("telescope.themes").get_dropdown({}),
						},
					},
				},
			})
			require("telescope").load_extension("lsp_handlers")
		end,
	},
	-- use fzf-lua for a general purpose picker, add the keymaps that I want slowly
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{
				"<C-p>",
				function()
					FzfLua.global()
				end,
				desc = "FzfLua VSCode like global picker",
			},
			{
				"<C-f>",
				function()
					FzfLua.files({ previewer = false })
				end,
				desc = "FzfLua file picker",
			},
			{
				"<C-b>",
				function()
					FzfLua.buffers({ previewer = false })
				end,
				desc = "FzfLua open buffers picker",
			},
			{
				"<leader>/",
				function()
					FzfLua.live_grep({ resume = true })
				end,
				desc = "FzfLua grep the entire project not using fzf",
			},
			{
				"gr",
				function()
					FzfLua.lsp_references({ ignore_current_line = true })
				end,
				desc = "lsp go to references",
			},
			-- Git pickers
			{
				"<leader>b",
				function()
					FzfLua.git_branches({ cmd = "git branch --color" })
				end,
				desc = "FzfLua switch local branches",
			},
			{
				"<leader>B",
				function()
					FzfLua.git_branches({ cmd = "git branch --remotes --color" })
				end,
				desc = "FzfLua get remote branches",
			},
			-- Messing around with colorschemes
			{
				"<leader>ac",
				function()
					FzfLua.awesome_colorschemes()
				end,
				desc = "FzfLua change neovim 'awesome' colorschemes",
			},
			{
				"<leader>cs",
				function()
					FzfLua.colorschemes()
				end,
				desc = "FzfLua change normal colorschemes",
			},
			{
				"<C-s>",
				function()
					FzfLua.command_history()
				end,
				mode = { "n", "x" },
				desc = "Search for recent commands",
			},
		},
		opts = {
			winopts = {
				preview = {
					default = "bat_native",
					vertical = "down:20%",
					layout = "vertical",
				},
			},
			files = {
				formatter = "path.filename_first",
			},
			-- git = {
			-- 	branches = {
			-- 		-- automatically switch to new branch
			-- 		cmd_add = { "git", "checkout", "-b" },
			-- 	},
			-- },
		},
		config = function(_, opts)
			require("fzf-lua").setup(opts)
			-- dynamically size ui-select height
			require("fzf-lua").register_ui_select(function(_, items)
				local min_h, max_h = 0.15, 0.70
				local h = (#items + 4) / vim.o.lines
				if h < min_h then
					h = min_h
				elseif h > max_h then
					h = max_h
				end
				return { winopts = { height = h, width = 0.60, row = 0.40 } }
			end)
		end,
	},
	-- trying out snacks for a wholesale QOL, going to try mini.picker for a standalone picker
	{
		"folke/snacks.nvim",
		enabled = true,
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			bigfile = { enabled = false },
			dashboard = { enabled = false },
			explorer = { enabled = false },
			indent = { enabled = false },
			input = { enabled = true },
			notifier = {
				enabled = false,
				timeout = 3000,
			},
			picker = { enabled = false },
			quickfile = { enabled = false },
			scope = { enabled = false },
			scroll = { enabled = false },
			statuscolumn = { enabled = false },
			words = { enabled = false },
		},
		-- turning off keys for Snacks, just using it for pretty input
		-- keys = {
		-- 	-- Top Pickers & Explorer
		-- 	{
		-- 		"<C-p>",
		-- 		function()
		-- 			Snacks.picker.smart()
		-- 		end,
		-- 		desc = "Smart Find Files",
		-- 	},
		-- 	{
		-- 		"<leader>,",
		-- 		function()
		-- 			Snacks.picker.buffers()
		-- 		end,
		-- 		desc = "Buffers",
		-- 	},
		-- 	{
		-- 		"<C-g>",
		-- 		function()
		-- 			Snacks.picker.grep()
		-- 		end,
		-- 		desc = "Grep",
		-- 	},
		-- 	{
		-- 		"<leader>:",
		-- 		function()
		-- 			Snacks.picker.command_history()
		-- 		end,
		-- 		desc = "Command History",
		-- 	},
		-- 	{
		-- 		"<leader>e",
		-- 		function()
		-- 			Snacks.explorer()
		-- 		end,
		-- 		desc = "File Explorer",
		-- 	},
		-- 	-- find
		-- 	{
		-- 		"<leader>fc",
		-- 		function()
		-- 			Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
		-- 		end,
		-- 		desc = "Find Config File",
		-- 	},
		-- 	{
		-- 		"<leader>fg",
		-- 		function()
		-- 			Snacks.picker.git_files()
		-- 		end,
		-- 		desc = "Find Git Files",
		-- 	},
		-- 	{
		-- 		"<leader>fp",
		-- 		function()
		-- 			Snacks.picker.projects()
		-- 		end,
		-- 		desc = "Projects",
		-- 	},
		-- 	-- git
		-- 	{
		-- 		"<leader>gb",
		-- 		function()
		-- 			Snacks.picker.git_branches()
		-- 		end,
		-- 		desc = "Git Branches",
		-- 	},
		-- 	{
		-- 		"<leader>gl",
		-- 		function()
		-- 			Snacks.picker.git_log()
		-- 		end,
		-- 		desc = "Git Log",
		-- 	},
		-- 	{
		-- 		"<leader>gL",
		-- 		function()
		-- 			Snacks.picker.git_log_line()
		-- 		end,
		-- 		desc = "Git Log Line",
		-- 	},
		-- 	{
		-- 		"<leader>gs",
		-- 		function()
		-- 			Snacks.picker.git_status()
		-- 		end,
		-- 		desc = "Git Status",
		-- 	},
		-- 	{
		-- 		"<leader>gS",
		-- 		function()
		-- 			Snacks.picker.git_stash()
		-- 		end,
		-- 		desc = "Git Stash",
		-- 	},
		-- 	{
		-- 		"<leader>gd",
		-- 		function()
		-- 			Snacks.picker.git_diff()
		-- 		end,
		-- 		desc = "Git Diff (Hunks)",
		-- 	},
		-- 	{
		-- 		"<leader>gf",
		-- 		function()
		-- 			Snacks.picker.git_log_file()
		-- 		end,
		-- 		desc = "Git Log File",
		-- 	},
		-- 	{
		-- 		"<leader>gB",
		-- 		function()
		-- 			Snacks.gitbrowse()
		-- 		end,
		-- 		desc = "Git Browse",
		-- 		mode = { "n", "v" },
		-- 	},
		-- 	-- Grep
		-- 	-- search
		-- 	{
		-- 		'<leader>s"',
		-- 		function()
		-- 			Snacks.picker.registers()
		-- 		end,
		-- 		desc = "Registers",
		-- 	},
		-- 	{
		-- 		"<leader>s/",
		-- 		function()
		-- 			Snacks.picker.search_history()
		-- 		end,
		-- 		desc = "Search History",
		-- 	},
		-- 	{
		-- 		"<leader>sC",
		-- 		function()
		-- 			Snacks.picker.commands()
		-- 		end,
		-- 		desc = "Commands",
		-- 	},
		-- 	{
		-- 		"<leader>sd",
		-- 		function()
		-- 			Snacks.picker.diagnostics()
		-- 		end,
		-- 		desc = "Diagnostics",
		-- 	},
		-- 	{
		-- 		"<leader>sh",
		-- 		function()
		-- 			Snacks.picker.help()
		-- 		end,
		-- 		desc = "Help Pages",
		-- 	},
		-- 	{
		-- 		"<leader>sk",
		-- 		function()
		-- 			Snacks.picker.keymaps()
		-- 		end,
		-- 		desc = "Keymaps",
		-- 	},
		-- 	{
		-- 		"<leader>sm",
		-- 		function()
		-- 			Snacks.picker.man()
		-- 		end,
		-- 		desc = "Man Pages",
		-- 	},
		-- 	{
		-- 		"<leader>su",
		-- 		function()
		-- 			Snacks.picker.undo()
		-- 		end,
		-- 		desc = "Undo History",
		-- 	},
		-- 	{
		-- 		"<leader>uC",
		-- 		function()
		-- 			Snacks.picker.colorschemes()
		-- 		end,
		-- 		desc = "Colorschemes",
		-- 	},
		-- 	-- LSP
		-- 	{
		-- 		"gd",
		-- 		function()
		-- 			Snacks.picker.lsp_definitions()
		-- 		end,
		-- 		desc = "Goto Definition",
		-- 	},
		-- 	{
		-- 		"gD",
		-- 		function()
		-- 			Snacks.picker.lsp_declarations()
		-- 		end,
		-- 		desc = "Goto Declaration",
		-- 	},
		-- 	{
		-- 		"gr",
		-- 		function()
		-- 			Snacks.picker.lsp_references()
		-- 		end,
		-- 		nowait = true,
		-- 		desc = "References",
		-- 	},
		-- 	{
		-- 		"gI",
		-- 		function()
		-- 			Snacks.picker.lsp_implementations()
		-- 		end,
		-- 		desc = "Goto Implementation",
		-- 	},
		-- 	-- Other
		-- 	{
		-- 		"<leader>z",
		-- 		function()
		-- 			Snacks.zen()
		-- 		end,
		-- 		desc = "Toggle Zen Mode",
		-- 	},
		-- 	{
		-- 		"<leader>Z",
		-- 		function()
		-- 			Snacks.zen.zoom()
		-- 		end,
		-- 		desc = "Toggle Zoom",
		-- 	},
		-- 	{
		-- 		"<leader>.",
		-- 		function()
		-- 			Snacks.scratch()
		-- 		end,
		-- 		desc = "Toggle Scratch Buffer",
		-- 	},
		-- 	{
		-- 		"<leader>S",
		-- 		function()
		-- 			Snacks.scratch.select()
		-- 		end,
		-- 		desc = "Select Scratch Buffer",
		-- 	},
		-- 	{
		-- 		"<leader>bd",
		-- 		function()
		-- 			Snacks.bufdelete()
		-- 		end,
		-- 		desc = "Delete Buffer",
		-- 	},
		-- 	{
		-- 		"<leader>cR",
		-- 		function()
		-- 			Snacks.rename.rename_file()
		-- 		end,
		-- 		desc = "Rename File",
		-- 	},
		-- 	{
		-- 		"<leader>gg",
		-- 		function()
		-- 			Snacks.lazygit()
		-- 		end,
		-- 		desc = "Lazygit",
		-- 	},
		-- 	{
		-- 		"<c-/>",
		-- 		function()
		-- 			Snacks.terminal()
		-- 		end,
		-- 		desc = "Toggle Terminal",
		-- 	},
		-- 	{
		-- 		"]]",
		-- 		function()
		-- 			Snacks.words.jump(vim.v.count1)
		-- 		end,
		-- 		desc = "Next Reference",
		-- 		mode = { "n", "t" },
		-- 	},
		-- 	{
		-- 		"[[",
		-- 		function()
		-- 			Snacks.words.jump(-vim.v.count1)
		-- 		end,
		-- 		desc = "Prev Reference",
		-- 		mode = { "n", "t" },
		-- 	},
		-- 	{
		-- 		"<leader>N",
		-- 		desc = "Neovim News",
		-- 		function()
		-- 			Snacks.win({
		-- 				file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
		-- 				width = 0.6,
		-- 				height = 0.6,
		-- 				wo = {
		-- 					spell = false,
		-- 					wrap = false,
		-- 					signcolumn = "yes",
		-- 					statuscolumn = " ",
		-- 					conceallevel = 3,
		-- 				},
		-- 			})
		-- 		end,
		-- 	},
		-- },
		-- init = function()
		-- 	vim.api.nvim_create_autocmd("User", {
		-- 		pattern = "VeryLazy",
		-- 		callback = function()
		-- 			-- Setup some globals for debugging (lazy-loaded)
		-- 			_G.dd = function(...)
		-- 				Snacks.debug.inspect(...)
		-- 			end
		-- 			_G.bt = function()
		-- 				Snacks.debug.backtrace()
		-- 			end
		-- 			vim.print = _G.dd -- Override print to use snacks for `:=` command
		--
		-- 			-- Create some toggle mappings
		-- 			Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
		-- 			Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
		-- 			Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
		-- 			Snacks.toggle.diagnostics():map("<leader>ud")
		-- 			Snacks.toggle.line_number():map("<leader>ul")
		-- 			Snacks.toggle
		-- 				.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
		-- 				:map("<leader>uc")
		-- 			Snacks.toggle.treesitter():map("<leader>uT")
		-- 			Snacks.toggle
		-- 				.option("background", { off = "light", on = "dark", name = "Dark Background" })
		-- 				:map("<leader>ub")
		-- 			Snacks.toggle.inlay_hints():map("<leader>uh")
		-- 			Snacks.toggle.indent():map("<leader>ug")
		-- 			Snacks.toggle.dim():map("<leader>uD")
		-- 		end,
		-- 	})
		-- end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		enabled = false,
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- for image preview rendering
			-- "folke/snacks.nvim",
		},
		lazy = false, -- neo-tree will lazily load itself
		opts = {},
		config = function(_, opts)
			require("neo-tree").setup(opts)
			vim.keymap.set("n", "<leader>n", "<Cmd>Neotree reveal<CR>")
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		enabled = false,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{
		"mrjones2014/smart-splits.nvim",
		version = ">=1.0.0",
		lazy = false,
		config = function()
			local ss = require("smart-splits")
			-- recommended mappings
			-- resizing splits
			-- these keymaps will also accept a range,
			-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
			vim.keymap.set("n", "<A-h>", ss.resize_left)
			vim.keymap.set("n", "<A-j>", ss.resize_down)
			vim.keymap.set("n", "<A-k>", ss.resize_up)
			vim.keymap.set("n", "<A-l>", ss.resize_right)
			-- moving between splits
			vim.keymap.set("n", "<C-h>", ss.move_cursor_left)
			vim.keymap.set("n", "<C-j>", ss.move_cursor_down)
			vim.keymap.set("n", "<C-k>", ss.move_cursor_up)
			vim.keymap.set("n", "<C-l>", ss.move_cursor_right)
			vim.keymap.set("n", "<C-\\>", ss.move_cursor_previous)
			-- swapping buffers between windows
			vim.keymap.set("n", "<leader><leader>h", ss.swap_buf_left)
			vim.keymap.set("n", "<leader><leader>j", ss.swap_buf_down)
			vim.keymap.set("n", "<leader><leader>k", ss.swap_buf_up)
			vim.keymap.set("n", "<leader><leader>l", ss.swap_buf_right)
		end,
	},
}
