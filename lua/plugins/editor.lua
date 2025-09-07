-- Editor enhancement plugins
return {
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = false,
    config = function()
      require("treesitter-context").setup {
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 50, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      }
    end,
  },

  {
    "folke/zen-mode.nvim",
    lazy = false,
    config = function()
      require("zen-mode").setup {
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
        plugins = {
          options = {
            enabled = true,
            ruler = false,
            showcmd = false,
          },
        },
      }
    end,
  },

  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = function()
      if vim.fn.filereadable(vim.fn.stdpath "config" .. "/lua/configs/conform.lua") == 1 then
        return require "configs.conform"
      end
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "python",
        "go",
        "rust",
        "c",
        "cpp",
        "bash",
        "json",
        "yaml",
        "markdown",
        "markdown_inline",
      },
      highlight = {
        enable = true,
        use_languagetree = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
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
  },

  {
    "HiPhish/rainbow-delimiters.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "BufRead",
    config = function()
      local rainbow_delimiters = require "rainbow-delimiters"

      require("rainbow-delimiters.setup").setup {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        priority = {
          [""] = 110,
          lua = 210,
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = {
        "markdown",
        "Avante", -- Add Avante filetype for markdown rendering
      },
    },
    ft = {
      "markdown",
      "Avante",
    },
  },

  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
  },

  {
    "rhysd/clever-f.vim",
    event = "BufRead",
    config = function()
      -- Enable clever-f
      vim.g.clever_f_intelligent_case = 1
      vim.g.clever_f_fix_key_direction = 1
      vim.g.clever_f_show_prompt = 1
      vim.g.clever_f_mark_char = 1
    end,
  },

  {
    "kylesnowschwartz/prompt-tower.nvim",
    cmd = { "PromptTower", "PromptTowerSelect", "PromptTowerGenerate", "PromptTowerClear" },
    config = function()
      require("prompt-tower").setup {
        -- You can customize these options if needed
        -- ignore_patterns = { "*.git/*", "node_modules/*" },
        -- format = "xml", -- Options: "xml", "markdown", "minimal"
        -- include_tree = true,
      }
    end,
  },

  {
    "chrisgrieser/nvim-early-retirement",
    event = "VeryLazy",
    config = function()
      require("early-retirement").setup {
        -- Maximum number of buffers to keep open
        retirementAgeMins = 0, -- Retire buffers after 10 minutes of inactivity

        -- Filetypes to never retire
        ignoredFiletypes = {},

        -- Retire buffers when you have more than this many open
        minimumBufferNum = 6, -- Only start retiring when you have more than 10 buffers

        -- Don't retire modified buffers
        deleteBufferWhenFileDeleted = false,

        -- Custom notification when a buffer is retired
        notificationOnAutoClose = true,
      }
    end,
  },
}
