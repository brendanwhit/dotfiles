-- Pull in the wezterm API
---@type Wezterm
local wezterm = require("wezterm")

local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local act = wezterm.action
local mux = wezterm.mux

-- This will hold the configuration.
---@type Config
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font = wezterm.font("JetBrains Mono")
config.font_size = 14
-- config.color_scheme = "AdventureTime"
config.color_scheme = "Solarized Darcula"

-- fancy tab bars
config.enable_scroll_bar = true

-- add the mistress as a ssh agent
config.ssh_domains = {
	{
		-- The name of this specific domain.  Must be unique amongst
		-- all types of domain in the configuration file.
		name = "the.mistress",

		-- identifies the host:port pair of the remote server
		-- Can be a DNS name or an IP address with an optional
		-- ":port" on the end.
		remote_address = "themistress.local",

		-- Whether agent auth should be disabled.
		-- Set to true to disable it.
		-- no_agent_auth = false,

		-- The username to use for authenticating with the remote host
		username = "brendan",

		-- If true, connect to this domain automatically at startup
		-- connect_automatically = true,

		-- Specify an alternative read timeout
		-- timeout = 60,

		-- The path to the wezterm binary on the remote host.
		-- Primarily useful if it isn't installed in the $PATH
		-- that is configure for ssh.
		-- remote_wezterm_path = "/home/yourusername/bin/wezterm"
	},
}

-- toggle function to switch opacity, activate using the keybindings below
wezterm.on("toggle-opacity", function(window, _)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		-- if no override is setup, override the default opacity value with 1.0
		overrides.window_background_opacity = 0.4
	else
		-- if there is an override, make it nil so the opacity goes back to the default
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end)

-- tmux configuration are better with a leader key
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	-- Claude Code terminal-setup keybinding
	{ key = "Enter", mods = "SHIFT", action = act.SendString("\x1b\r") },
	{ key = "o", mods = "SUPER", action = act.EmitEvent("toggle-opacity") },
	-- tmux emulator keys (https://www.florianbellmann.com/blog/switch-from-tmux-to-wezterm)
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "|", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "m", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "0", mods = "LEADER", action = act.PaneSelect({ mode = "SwapWithActive" }) },
	{ key = "w", mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },
	-- workspace and domain switcher
	{ key = "p", mods = "SUPER|SHIFT", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES|DOMAINS" }) },
	{
		key = "#",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, _, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	-- map clear screen to match zsh, https://github.com/wezterm/wezterm/blob/6a493f88fab06a792308e0c704790390fd3c6232/docs/config/lua/keyassignment/ClearScrollback.md
	{
		key = "k",
		mods = "SUPER",
		action = act.Multiple({
			act.ClearScrollback("ScrollbackAndViewport"),
			act.SendKey({ key = "L", mods = "CTRL" }),
		}),
	},
}

-- CMD to CTRL remapping, currently obsolete because of CAPS LOCK to CTRL system remapping
-- current list of default mapped keys with CTRL
-- cat /usr/local/Cellar/neovim/0.11.0/share/nvim/runtime/doc/* | rg 'CTRL-([a-zA-z]+?)' -or '$1' | sort -fu
-- local default_vim_control_keys = "_[]\\^abcdefghijklmnopqrstuvwxyz"
--
-- local user_defined_control_keys = ".bfhjklpqstw"
-- local special_keys = { "Bspace" }
-- mapping of wezterm default super commands to their keys
-- local lookup_table = {
-- 	["-"] = act.DecreaseFontSize,
-- 	["0"] = act.ResetFontSize,
-- 	["1"] = act.ActivateTab(0),
-- 	["2"] = act.ActivateTab(1),
-- 	["3"] = act.ActivateTab(2),
-- 	["4"] = act.ActivateTab(3),
-- 	["5"] = act.ActivateTab(4),
-- 	["6"] = act.ActivateTab(5),
-- 	["7"] = act.ActivateTab(6),
-- 	["8"] = act.ActivateTab(7),
-- 	["9"] = act.ActivateTab(-1),
-- 	["="] = act.IncreaseFontSize,
-- 	["["] = act.ActivateTabRelative(-1),
-- 	["]"] = act.ActivateTabRelative(1),
-- 	["c"] = act.CopyTo("ClipboardAndPrimarySelection"),
-- 	["f"] = act.Search("CurrentSelectionOrEmptyString"),
-- 	["h"] = act.HideApplication,
-- 	["k"] = act.ClearScrollback("ScrollbackOnly"),
-- 	["m"] = act.Hide,
-- 	["n"] = act.SpawnWindow,
-- 	-- special opacity switcher
-- 	["o"] = act.EmitEvent("toggle-opacity"),
-- 	["q"] = act.QuitApplication,
-- 	["r"] = act.ReloadConfiguration,
-- 	["t"] = act.SpawnTab("CurrentPaneDomain"),
-- 	["v"] = act.PasteFrom("Clipboard"),
-- 	["w"] = act.CloseCurrentTab({ confirm = true }),
-- 	["{"] = act.ActivateTabRelative(-1),
-- 	["}"] = act.ActivateTabRelative(1),
-- }
-- local function is_vim(pane)
-- 	-- Check if the foreground process is Vim or Neovim
-- 	local process_name = string.gsub(pane:get_foreground_process_name(), "(. *[/\\\\])(. *)", "%2")
-- 	return process_name == "nvim" or process_name == "vim"
-- end
--
-- wezterm.on("user-var-changed", function(window, pane, var_name, value)
-- 	if var_name == "IS_NVIM" then
-- 		-- Reapply keybindings when IS_NVIM changes
-- 		window:perform_action(act.ReloadConfiguration)
-- 	end
-- end)
-- helper function to enable <SUPER> mapping in nvim
-- see https://seb.bearblog.dev/wezterm-and-neovim-keybindings-in-macos/ for more info
-- local function bind_keys_in_nvim(key, mods)
-- 	return function(window, pane)
-- 		if not is_vim(pane) then
-- 			return false
-- 		end
--
-- 		window:perform_action({ SendKey = { key = key, mods = mods } }, pane)
-- 		return true
-- 	end
-- end
-- vim send keys for the file searcher
--    {
--      key = "p",
--      mods = "SUPER",
--      action = wezterm.action_callback(function(window, pane)
--        if is_vim(pane) then
--          window:perform_action(act.SendKey{key="p", mods="CTRL"})
--        else
--            return
--        end
--      end),
--    },
--    {
--      key = "b",
--      mods = "SUPER",
--      action = wezterm.action_callback(function(window, pane)
--        if is_vim(pane) then
--          window:perform_action(act.SendKey{key="b", mods="CTRL"})
--        else
--            return
--        end
--      end),
--    },
--    -- Add more CMD-to-CTRL mappings as needed
--    -- For example: CMD-c to CTRL-c
--    {
--      key = "c",
--      mods = "SUPER",
--      action = wezterm.action_callback(function(window, pane)
--        if is_vim(pane) then
--          window:perform_action(act.SendKey{key="c", mods="CTRL"})
--        else
--          window:perform_action(act.CopyTo "ClipboardAndPrimarySelection")
--        end
--      end),
--    },
-- { key = "p", mods = "SUPER", action = wezterm.action_callback(bind_keys_in_nvim("p", "CTRL")) },
-- { key = "w", mods = "SUPER", action = wezterm.action_callback(bind_keys_in_nvim("w", "CTRL")) },
-- { key = "b", mods = "SUPER", action = wezterm.action_callback(bind_keys_in_nvim("b", "CTRL")) },
-- { key = ".", mods = "SUPER", action = wezterm.action_callback(bind_keys_in_nvim(".", "CTRL")) },
--
--
-- -- set a key binding for each character in the default vim commands
-- default_vim_control_keys:gsub(".", function(c)
-- 	table.insert(config.keys, {
-- 		key = c,
-- 		mods = "SUPER",
-- 		action = wezterm.action_callback(function(window, pane)
-- 			if is_vim(pane) then
-- 				window:perform_action(act.SendKey({ key = c, mods = "CTRL" }), pane)
-- 			elseif lookup_table[c] then
-- 				window:perform_action(lookup_table[c])
-- 			else
-- 				return
-- 			end
-- 		end),
-- 	})
-- end)

-- add smart-splits configuration using the plugin!
-- more info: https://github.com/mrjones2014/smart-splits.nvim/tree/master?tab=readme-ov-file#install
smart_splits.apply_to_config(config)

-- Finally, return the configuration to wezterm:
return config
