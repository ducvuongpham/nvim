-- Coding related plugins (AI assistants, completion, etc.)
return {
  {
    "github/copilot.vim",
    lazy = false,
    config = function()
      vim.b.workspace_folder = vim.fn.expand "%:p:h"
      vim.g.copilot_workspace_folders = "~/Program/aircloset/"
      vim.api.nvim_buf_set_var(0, "workspace_folder", vim.fn.getcwd())
      vim.g.copilot_node_command = '~/.local/share/mise/installs/node/latest/bin/node'
    end,
  },
  -- {
  --   "yetone/avante.nvim",
  --   event = "VeryLazy",
  --   version = false, -- Never set this value to "*"
  --   build = "make", -- Add build step to generate templates
  --   behaviour = {
  --     --- ... existing behaviours
  --     enable_cursor_planning_mode = true, -- enable cursor planning mode!
  --   },
  --   opts = {
  --     -- Configure to use GitHub Copilot as the AI provider
  --     provider = "copilot", -- Changed from "openai" to "copilot"
  --     copilot = {
  --       -- No specific configuration needed for Copilot
  --       -- It will use your existing Copilot authentication
  --     },
  --     keymap = {
  --       prefix = "<leader>a", -- Keep the same prefix
  --     },
  --     window = {
  --       -- Adding explicit window configuration to fix E5108 error
  --       width = 0.8, -- Width as a percentage of the editor width
  --       height = 0.8, -- Height as a percentage of the editor height
  --       border = "rounded",
  --       winblend = 0, -- Transparency (0 for opaque, 100 for transparent)
  --     },
  --     sidebar = {
  --       -- Adding explicit sidebar configuration to fix window handling issues
  --       enabled = true,
  --       width = 40, -- Fixed width in columns
  --       position = "right", -- Position of the sidebar
  --     },
  --   },
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim",
  --     "MunifTanjim/nui.nvim",
  --     "github/copilot.vim", -- Ensure copilot.vim is listed as a dependency
  --   },
  -- },
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
    },
    opts = {
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "gemini-2.5-pro",
              },
            },
          })
        end,
      },
      display = {
        chat = {
          window = {
            width = 0.3,
            height = 0.3,
            border = "rounded",
            opts = {
              breakindent = true,
              linebreak = true,
              wrap = true,
              signcolumn = "no",
            }
          },
          sidebar = {
            width = 40,
            position = "right",
          },
        },
      },
    },
  },
}
