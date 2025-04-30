-- Coding related plugins (AI assistants, completion, etc.)
return {
  {
    "github/copilot.vim",
    lazy = false,
    config = function()
      vim.b.workspace_folder = vim.fn.expand "%:p:h"
      vim.g.copilot_workspace_folders = "~/Program/aircloset/"
      vim.api.nvim_buf_set_var(0, "workspace_folder", vim.fn.getcwd())
    end,
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"
    build = "make", -- Add build step to generate templates
    behaviour = {
      --- ... existing behaviours
      enable_cursor_planning_mode = true, -- enable cursor planning mode!
    },
    opts = {
      -- Configure to use GitHub Copilot as the AI provider
      provider = "copilot", -- Changed from "openai" to "copilot"
      copilot = {
        -- No specific configuration needed for Copilot
        -- It will use your existing Copilot authentication
      },
      keymap = {
        prefix = "<leader>a", -- Keep the same prefix
      },
      window = {
        -- Adding explicit window configuration to fix E5108 error
        width = 0.8, -- Width as a percentage of the editor width
        height = 0.8, -- Height as a percentage of the editor height
        border = "rounded",
        winblend = 0, -- Transparency (0 for opaque, 100 for transparent)
      },
      sidebar = {
        -- Adding explicit sidebar configuration to fix window handling issues
        enabled = true,
        width = 40, -- Fixed width in columns
        position = "right", -- Position of the sidebar
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
      "github/copilot.vim", -- Ensure copilot.vim is listed as a dependency
    },
  },
}
