-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("core.lazy")
require("core.utils")
require("config.options")
require("config.mappings")
require("core.lsp")
