return {
  -- Completion engine
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require "configs.cmp"
    end,
  },

  -- Copilot AI completion
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

  -- CodeCompanion AI assistant
  {
    "olimorris/codecompanion.nvim",
    lazy = false,
    version = "v17.*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "MunifTanjim/nui.nvim",
      "github/copilot.vim",
      "j-hui/fidget.nvim",
      { "echasnovski/mini.pick", config = true },
      { "ibhagwan/fzf-lua", config = true },
      { "Davidyz/VectorCode", lazy = true },
      { "ravitemer/mcphub.nvim", lazy = true },
    },
    opts = function()
      return require "configs.codecompanion"
    end,
  },

  -- Claude Code integration
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
