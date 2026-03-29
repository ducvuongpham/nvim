return {
  {
    "echasnovski/mini.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      -- Enhanced text objects (vai, viq, vat, etc.)
      require("mini.ai").setup { n_lines = 500 }

      -- Surround pairs: sa{motion}{char}, sd{char}, sr{old}{new}
      require("mini.surround").setup()

      -- Extended f/F/t/T with repeat
      require("mini.jump").setup {
        mappings = {
          forward = "f",
          backward = "F",
          forward_till = "t",
          backward_till = "T",
          repeat_jump = "", -- ; is used for command mode
        },
      }

      -- Jump anywhere with <CR> + 2 chars
      require("mini.jump2d").setup {
        mappings = { start_jumping = "<CR>" },
      }

      -- Highlight TODO/FIXME/HACK/NOTE and hex colors
      local hipatterns = require "mini.hipatterns"
      hipatterns.setup {
        highlighters = {
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      }

      -- Animated indent scope indicator
      require("mini.indentscope").setup {
        symbol = "│",
        draw = {
          delay = 50,
          animation = require("mini.indentscope").gen_animation.none(),
        },
      }

      -- Highlight word under cursor
      require("mini.cursorword").setup()

      -- Split/join arguments with gS
      require("mini.splitjoin").setup()

      -- Text operators: g= evaluate, gx exchange, gm multiply, gR replace, gs sort
      require("mini.operators").setup {
        replace = { prefix = "gR" }, -- avoid conflict with gr (LSP references)
      }

      -- Tabline showing open buffers
      require("mini.tabline").setup()
    end,
  },

  -- Auto-close/rename HTML/JSX tags
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    ft = { "html", "xml", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "svelte", "php" },
    opts = {},
  },

  -- Enhanced % matching for tags, if/else, etc.
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    init = function()
      vim.g.matchup_matchparen_offscreen = {}
    end,
    config = function()
      require("nvim-treesitter.configs").setup {
        matchup = { enable = true },
      }
    end,
  },
}
