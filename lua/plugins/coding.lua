-- Coding related plugins (AI assistants, completion, etc.)
return {
  {
    "github/copilot.vim",
    lazy = false,
    config = function()
      vim.b.workspace_folder = vim.fn.expand "%:p:h"
      vim.g.copilot_workspace_folders = "~/Program/aircloset/"
      vim.api.nvim_buf_set_var(0, "workspace_folder", vim.fn.getcwd())
      vim.g.copilot_node_command = "~/.local/share/mise/installs/node/latest/bin/node"
    end,
  },
  {
    "olimorris/codecompanion.nvim", -- The KING of AI programming
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "MunifTanjim/nui.nvim",
      "github/copilot.vim",
      "j-hui/fidget.nvim",
      { "echasnovski/mini.pick", config = true },
      { "ibhagwan/fzf-lua", config = true },
      -- AI enhancement plugins
      { "Davidyz/VectorCode", lazy = true },
      { "ravitemer/mcphub.nvim", lazy = true },
    },
    opts = function()
      return require "configs.codecompanion"
    end,
  },
  {
    "coder/claudecode.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
    },
    config = function()
      require("claudecode").setup {}
    end,
  },
}
