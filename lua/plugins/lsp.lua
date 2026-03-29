return {
  -- LSP server configurations
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Install and manage LSP servers, formatters, linters
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    opts = {
      ensure_installed = {
        -- JavaScript/TypeScript
        "prettier",
        "typescript-language-server",
        "html-lsp",
        "css-lsp",
        "json-lsp",
        "eslint-lsp",
        -- Go
        "gopls",
        "goimports",
        "gofumpt",
        "golangci-lint",
        -- C/C++
        "clangd",
        "clang-format",
        -- Python
        "pyright",
        "black",
        "isort",
        "ruff",
        -- Rust
        "rust-analyzer",
        "rustfmt",
        -- Lua
        "lua-language-server",
        "stylua",
        -- Other
        "yaml-language-server",
        "marksman",
        "shellcheck",
        "shfmt",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      -- Auto-install configured tools
      local registry = require "mason-registry"
      registry.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local ok, p = pcall(registry.get_package, tool)
          if ok and not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },

  -- Additional diagnostics and formatting sources
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    opts = function()
      return require "configs.null-ls"
    end,
  },

  -- Symbol navigation popup
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
        lsp = { auto_attach = true },
      }
    end,
  },

  -- Debugging UI
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
      dapui.setup()
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

  { "mfussenegger/nvim-dap" },
}
