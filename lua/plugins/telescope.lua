-- Custom Telescope configuration
return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope-smart-history.nvim",
    "kkharji/sqlite.lua",
  },
  cmd = "Telescope",
  opts = function()
    -- Load our custom telescope configuration from configs/telescope.lua
    return require "configs.telescope"
  end,
}
