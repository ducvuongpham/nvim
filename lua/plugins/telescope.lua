return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope-smart-history.nvim",
    "kkharji/sqlite.lua",
    "nvim-telescope/telescope-fzf-native.nvim",
  },
  config = function()
    local telescope = require "telescope"
    local actions = require "telescope.actions"

    -- Ensure history DB directory exists
    local history_dir = vim.fn.expand "~/.local/share/nvim/databases"
    if vim.fn.isdirectory(history_dir) == 0 then
      vim.fn.mkdir(history_dir, "p")
    end

    telescope.setup {
      defaults = {
        prompt_prefix = "   ",
        selection_caret = " ",
        entry_prefix = " ",
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
          },
          n = {
            ["q"] = actions.close,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
          },
        },
        history = {
          path = history_dir .. "/telescope_history.sqlite3",
          limit = 500,
        },
      },
    }

    telescope.load_extension "smart_history"
    telescope.load_extension "fzf"
  end,
}
