# Neovim Configuration Patterns

This document outlines the coding patterns and conventions used in this Neovim configuration for Claude Code to follow.

## Plugin Structure

### Plugin Loading Strategies

Plugins load in different ways depending on their configuration:

#### 1. Lazy-loaded via keys
Plugins with a `keys` table only load when their keybinding is first pressed:
- Initialization logic should run synchronously on first load
- Results should be cached for subsequent calls
- Example: `diffview.lua` custom module, `neogit`, `gitportal`

#### 2. Immediate loading
Plugins with `lazy = false` load on Neovim startup:
- Can use asynchronous initialization if needed
- Should avoid blocking startup time
- Example: `oil.nvim`, `smart-splits.nvim`, `nvim-treesitter`

#### 3. Event-based loading
Plugins load on specific events (filetype, autocmd, etc.):
- Example: `lazydev.nvim` with `ft = "lua"`

#### 4. Default lazy behavior
Plugins without explicit loading config use lazy.nvim's smart detection

### Module Pattern

Custom plugin functionality follows this structure:

```lua
-- 1. Safe require with pcall (if needed)
local ok, plugin = pcall(require, "plugin-name")
if not ok then
    return
end

-- 2. Module table
local M = {}

-- 3. Cache variables at module level
local cached_value = nil

-- 4. Helper functions (local scope)
local function get_cached_value()
    if cached_value then
        return cached_value
    end

    -- Synchronous initialization on first use
    local result = compute_expensive_value()
    cached_value = result
    return cached_value
end

-- 5. Public API functions
function M.main_function()
    local value = get_cached_value()
    -- Use the cached value
end

-- 6. Return module
return M
```

## Key Examples

### lua/plugins/diffview.lua

This file demonstrates:
1. **Safe require pattern**: Uses `pcall` to gracefully handle missing dependencies
2. **Synchronous initialization**: Uses `vim.system(...):wait()` for git commands since plugin is lazy-loaded
3. **Caching**: Stores `default_branch` at module level to avoid repeated git calls
4. **Minimal processing**: Keeps `stdout` trimming minimal (removed unnecessary `gsub`)
5. **Direct API usage**: Calls `diffview.open(branch)` instead of `vim.cmd`

Key pattern:
```lua
local function get_default_branch()
    if default_branch then
        return default_branch  -- Return cached value
    end

    -- Synchronous call on first use (acceptable since plugin is lazy-loaded)
    local obj = vim.system({ "git", "symbolic-ref", "refs/remotes/origin/HEAD", "--short" }, { text = true }):wait()

    if obj.code == 0 then
        default_branch = vim.trim(obj.stdout)  -- Cache result
    end

    return default_branch
end
```

### lua/plugins/git.lua

Demonstrates:
1. **Inline function keybindings**: Using anonymous functions in `keys` table
2. **Nested local functions**: `map()` helper inside `on_attach`
3. **Mode-specific mappings**: Using `mode = { "n", "v" }` for multi-mode bindings

### lua/plugins/navigation.lua

Shows:
1. **Complex keybinding patterns**: Multiple FzfLua pickers with different configurations
2. **Custom options per keybinding**: Using inline function calls with specific parameters
3. **Dynamic configuration**: Using `config` function to register custom UI-select behavior

## Conventions

### Keybindings
- Use function wrappers: `function() require("module").action() end`
- Always include `desc` field for documentation
- Use `mode = { "n", "v" }` for multi-mode bindings

### Git Commands
- Use `vim.system()` for running git commands
- Always use table format for command + args: `{ "git", "command", "args" }`
- Use `:wait()` for synchronous execution when inside lazy-loaded plugins
- Check `obj.code == 0` for success
- Use `vim.trim()` on stdout to remove trailing newlines

### Error Handling
- Use `pcall()` for optional dependencies
- Early return pattern when dependencies missing
- Graceful degradation when git commands fail (return nil or fallback value)

### Caching Pattern
```lua
local cached_result = nil

local function get_result()
    if cached_result then
        return cached_result
    end

    cached_result = expensive_operation()
    return cached_result
end
```

### Comments
- Use inline comments for non-obvious logic
- Use section comments for grouping related functionality
- Include TODO comments for future improvements

## File Organization

```
lua/
├── plugins/
│   ├── coding.lua       # Completion, treesitter, language support
│   ├── colorscheme.lua  # Theme configuration
│   ├── conform.lua      # Formatting
│   ├── context.lua      # Treesitter context
│   ├── diffview.lua     # Custom git diff functionality
│   ├── editor.lua       # Editor behavior
│   ├── git.lua          # Git integrations (neogit, gitsigns, gitportal)
│   ├── linting.lua      # Linting configuration
│   ├── lsp.lua          # LSP configuration
│   └── navigation.lua   # File pickers and navigation (fzf-lua, snacks, oil)
```

## Plugin Preferences

- **Picker**: fzf-lua (telescope disabled)
- **Git UI**: neogit + diffview
- **Completion**: blink.cmp
- **File explorer**: oil.nvim
- **UI enhancements**: snacks.nvim (minimal - only input enabled)
- **Window management**: smart-splits.nvim

## LazyVim Integration

This config uses lazy.nvim for plugin management:
- Plugins are defined as return tables
- Each file in `lua/plugins/` is automatically loaded
- Use `enabled = false` to disable plugins
- Use `lazy = false` to load plugins immediately
- Default is lazy-loading based on events/keys
