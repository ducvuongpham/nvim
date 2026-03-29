-- ── Mini modules ─────────────────────────────────────────────────────────────
require("mini.ai").setup { n_lines = 500 }
require("mini.surround").setup()
require("mini.jump").setup {
  mappings = {
    forward = "f", backward = "F",
    forward_till = "t", backward_till = "T",
    repeat_jump = "", -- ; is used for command mode
  },
}
require("mini.jump2d").setup { mappings = { start_jumping = "<CR>" } }

local hipatterns = require "mini.hipatterns"
hipatterns.setup {
  highlighters = {
    fixme    = { pattern = "%f[%w]()FIXME()%f[%W]",  group = "MiniHipatternsFixme" },
    hack     = { pattern = "%f[%w]()HACK()%f[%W]",   group = "MiniHipatternsHack" },
    todo     = { pattern = "%f[%w]()TODO()%f[%W]",   group = "MiniHipatternsTodo" },
    note     = { pattern = "%f[%w]()NOTE()%f[%W]",   group = "MiniHipatternsNote" },
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
}

require("mini.indentscope").setup {
  symbol = "│",
  draw = {
    delay = 50,
    animation = require("mini.indentscope").gen_animation.none(),
  },
}

require("mini.cursorword").setup()
require("mini.splitjoin").setup()
require("mini.operators").setup { replace = { prefix = "gR" } }
require("mini.tabline").setup()

-- ── HTML/JSX tag auto-close ───────────────────────────────────────────────────
require("nvim-ts-autotag").setup()

-- ── Enhanced % matching ───────────────────────────────────────────────────────
-- vim-matchup is a VimL plugin (loaded via packs.lua load=true).
-- Disable its offscreen popup and enable treesitter integration.
vim.g.matchup_matchparen_offscreen = {}
-- Treesitter integration is enabled inside plugins/editor.lua treesitter setup.
