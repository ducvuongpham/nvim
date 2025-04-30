-- Get NvChad's telescope config
local nvchad_telescope = require "nvchad.configs.telescope"

-- Add our custom keymaps to the default config
nvchad_telescope.defaults.mappings = {
  i = {
    -- Navigate between results with Ctrl-j and Ctrl-k
    ["<C-j>"] = require("telescope.actions").move_selection_next,
    ["<C-k>"] = require("telescope.actions").move_selection_previous,

    -- Navigate between history entries with Ctrl-n and Ctrl-p
    ["<C-n>"] = require("telescope.actions").cycle_history_next,
    ["<C-p>"] = require("telescope.actions").cycle_history_prev,
  },
  n = {
    ["q"] = require("telescope.actions").close,
    ["<C-j>"] = require("telescope.actions").move_selection_next,
    ["<C-k>"] = require("telescope.actions").move_selection_previous,

    ["<C-n>"] = require("telescope.actions").cycle_history_next,
    ["<C-p>"] = require("telescope.actions").cycle_history_prev,
  },
}

nvchad_telescope.defaults.history = {
  path = "~/.local/share/nvim/databases/telescope_history.sqlite3",
  limit = 500,
}

-- Load the smart_history extension
require("telescope").load_extension "smart_history"
require("telescope").load_extension "fzf"

return nvchad_telescope
