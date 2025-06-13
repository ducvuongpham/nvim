-- LSP related plugins
return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- {
  --   "williamboman/mason.nvim",
  --   opts = {
  --     ensure_installed = {
  --       "eslint-lsp",
  --       "prettier",
  --       "js-debug-adapter",
  --       "typescript-language-server",
  --       "html-lsp",
  --       "css-lsp",
  --     },
  --   },
  -- },

  {
    "nvimtools/none-ls.nvim",
    autostart = true,
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    opts = function()
      -- The path needs to be adjusted for your configuration
      -- If you create a configs/null-ls.lua file, uncomment this:
      -- return require "configs.null-ls"

      -- Otherwise, you might need to define null-ls config directly here
      -- or adapt your configuration structure
    end,
  },

  {
    "SmiteshP/nvim-navbuddy",
    lazy = false,
    dependencies = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("nvim-navbuddy").setup {
        lsp = {
          auto_attach = true, -- Automatically attach to LSP clients
          preference = nil, -- List of preferred LSP clients to attach to
        },
      }
    end,
  },

  -- DAP (Debugging)
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"
      require("dapui").setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

  {
    "mfussenegger/nvim-dap",
    config = function()
      -- Adjust this path according to your configuration structure
      -- You might need to create this file or adapt the path
      -- return require "configs.dap-config"
    end,
  },
}
