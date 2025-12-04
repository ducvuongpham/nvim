-- Mini.nvim modules
-- Each module can be configured independently
-- See: https://github.com/echasnovski/mini.nvim for full documentation
return {
  {
    "echasnovski/mini.nvim",
    version = "*", -- Use stable version
    event = "VeryLazy",
    config = function()
      -- ============================================
      -- TEXT EDITING MODULES
      -- ============================================

      -- mini.ai - Enhanced text objects (around/inside)
      -- Examples: vai (select around indent), viq (select inside quote), vat (around tag)
      require("mini.ai").setup {
        n_lines = 500, -- Search within 500 lines (default is 50)
      }

      -- mini.surround - Add/delete/change surrounding pairs
      -- sa{motion}{char} - add surrounding
      -- sd{char} - delete surrounding
      -- sr{old}{new} - replace surrounding
      -- saiw t - add html tag around word
      require("mini.surround").setup()

      -- mini.pairs - Auto-pairs for brackets/quotes
      -- Automatically inserts closing pair
      require("mini.pairs").setup {
        modes = { insert = true, command = false, terminal = false },
      }

      -- mini.comment - Better commenting
      -- gc{motion} - toggle comment, gcc - comment line
      require("mini.comment").setup()

      -- ============================================
      -- NAVIGATION MODULES
      -- ============================================

      -- mini.bracketed - Navigate using [ and ] brackets
      -- [b/]b - buffer, [c/]c - comment, [d/]d - diagnostic
      -- [f/]f - file, [q/]q - quickfix, [t/]t - treesitter
      require("mini.bracketed").setup()

      -- mini.jump - Extended f, F, t, T motions
      -- Highlights possible targets and allows repeat with f/F/t/T
      -- Disabled ; and , mappings to preserve custom ; mapping for command mode
      require("mini.jump").setup {
        mappings = {
          forward = "f",
          backward = "F",
          forward_till = "t",
          backward_till = "T",
          repeat_jump = "", -- Disable ; (use your custom ; for command mode)
        },
      }

      -- mini.jump2d - Jump anywhere with 2-character search
      -- <CR> to start, then type 2 chars to jump
      require("mini.jump2d").setup {
        mappings = {
          start_jumping = "<CR>",
        },
      }

      -- ============================================
      -- VISUAL MODULES
      -- ============================================

      -- mini.hipatterns - Highlight patterns (TODO, FIXME, colors)
      local hipatterns = require "mini.hipatterns"
      hipatterns.setup {
        highlighters = {
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
          -- Highlight hex colors
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      }

      -- mini.indentscope - Animated indentation scope
      require("mini.indentscope").setup {
        symbol = "│",
        draw = {
          delay = 50,
          animation = require("mini.indentscope").gen_animation.none(),
        },
      }

      -- mini.cursorword - Highlight word under cursor
      require("mini.cursorword").setup()

      -- ============================================
      -- MISC MODULES
      -- ============================================

      -- mini.splitjoin - Split/join arguments
      -- gS to toggle between single-line and multi-line
      require("mini.splitjoin").setup()

      -- mini.move - Move lines/selections with Alt+hjkl
      require("mini.move").setup()

      -- mini.operators - Text operators (evaluate, exchange, multiply, replace, sort)
      -- g= evaluate, gx exchange, gm multiply, gr replace, gs sort
      require("mini.operators").setup()
    end,
  },

  -- nvim-ts-autotag for HTML/JSX tag auto-closing and renaming
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    ft = { "html", "xml", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "svelte", "php" },
    opts = {},
  },

  -- vim-matchup - Enhanced % matching for HTML tags, if/else, etc.
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    init = function()
      -- Don't highlight matching pairs (optional, remove if you want highlights)
      -- vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
    config = function()
      -- Enable treesitter integration for better matching
      require("nvim-treesitter.configs").setup {
        matchup = {
          enable = true,
        },
      }
    end,
  },
}
