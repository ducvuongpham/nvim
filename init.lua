vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"

require "packs"    -- install all plugins via vim.pack (adds to rtp)

require "options"
require "autocmds"

-- Plugin setup (dependency order matters — deps before dependents)
require "plugins.ui"      -- catppuccin, lualine, barbecue
require "plugins.mini"    -- mini.nvim modules, vim-matchup, nvim-ts-autotag
require "plugins.git"     -- gitsigns, lazygit, blame
require "plugins.util"    -- auto-session, flatten, snow, duck
require "plugins.coding"  -- copilot (VimL), cmp, codecompanion, claudecode
require "plugins.editor"  -- snacks, treesitter, telescope, conform, nvimtree, trouble…
require "plugins.lsp"     -- LSP + mason + none-ls (lazy on BufReadPre)

vim.schedule(function()
  require "mappings"
end)
