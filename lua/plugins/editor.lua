return {
  -- Snacks.nvim utilities (bigfile detection, bufdelete, etc.)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = {
        enabled = true,
        notify = true,
        size = 1.5 * 1024 * 1024,
        line_length = 1000,
        setup = function(ctx)
          vim.cmd "NoMatchParen"
          vim.wo.foldmethod = "manual"
          vim.wo.statuscolumn = ""
          vim.wo.conceallevel = 0
          vim.b.minianimate_disable = true
          vim.schedule(function()
            vim.bo[ctx.buf].syntax = ctx.ft
          end)
        end,
      },
    },
  },

  -- Treesitter: syntax highlighting and structural editing
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css", "javascript", "typescript", "tsx",
        "python", "go", "rust", "c", "cpp",
        "bash", "json", "yaml", "markdown", "markdown_inline",
      },
      highlight = {
        enable = true,
        use_languagetree = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Show context (function/class) at top of buffer
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = {
      enable = true,
      max_lines = 0,
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20,
      trim_scope = "outer",
      mode = "cursor",
      zindex = 50,
    },
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = function()
      return require "configs.conform"
    end,
  },

  -- FZF native sorter for Telescope
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    lazy = true,
  },

  -- Zen mode
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      window = {
        backdrop = 0.95,
        width = 0.8,
        height = 1,
        options = {
          signcolumn = "no",
          number = false,
          relativenumber = false,
          cursorline = false,
          foldcolumn = "0",
          list = false,
        },
      },
    },
  },

  -- Rainbow bracket matching
  {
    "HiPhish/rainbow-delimiters.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "BufReadPost",
    config = function()
      local rd = require "rainbow-delimiters"
      require("rainbow-delimiters.setup").setup {
        strategy = {
          [""] = rd.strategy["global"],
          vim = rd.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterRed", "RainbowDelimiterYellow", "RainbowDelimiterBlue",
          "RainbowDelimiterOrange", "RainbowDelimiterGreen", "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },

  -- Render markdown nicely
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "Avante" },
    opts = {
      file_types = { "markdown", "Avante" },
    },
  },

  -- Better vim.ui.select / vim.ui.input
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
  },

  -- Enhanced f/F/t/T motions
  {
    "rhysd/clever-f.vim",
    event = "BufReadPost",
    init = function()
      vim.g.clever_f_intelligent_case = 1
      vim.g.clever_f_fix_key_direction = 1
      vim.g.clever_f_show_prompt = 1
      vim.g.clever_f_mark_char = 1
    end,
  },

  -- Prompt builder for context-aware AI prompts
  {
    "kylesnowschwartz/prompt-tower.nvim",
    cmd = { "PromptTower", "PromptTowerSelect", "PromptTowerGenerate", "PromptTowerClear" },
    config = function()
      require("prompt-tower").setup {}
    end,
  },

  -- Auto-close inactive buffers
  {
    "chrisgrieser/nvim-early-retirement",
    event = "VeryLazy",
    opts = {
      retirementAgeMins = 0,
      minimumBufferNum = 6,
      notificationOnAutoClose = true,
    },
  },

  -- Diagnostics list, symbol browser, LSP navigation
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {
      modes = {
        preview_float = {
          mode = "diagnostics",
          preview = {
            type = "float",
            relative = "editor",
            border = "rounded",
            title = "Preview",
            title_pos = "center",
            position = { 0, -2 },
            size = { width = 0.3, height = 0.3 },
            zindex = 200,
          },
        },
      },
    },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                    desc = "Diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",       desc = "Buffer diagnostics" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",            desc = "Symbols" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP refs/defs" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                        desc = "Location list" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                         desc = "Quickfix list" },
    },
  },

  -- Inline diagnostics (replaces virtual_text)
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup()
    end,
  },
}
