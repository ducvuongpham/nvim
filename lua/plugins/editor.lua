-- ── Snacks (eager — bigfile detection must run before any buffer opens) ────────
require("snacks").setup {
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
}

-- ── Dressing (eager — overrides vim.ui before any prompts appear) ─────────────
require("dressing").setup {}

-- ── Clever-f (VimL — already sourced via packs.lua load=true) ────────────────
vim.g.clever_f_intelligent_case = 1
vim.g.clever_f_fix_key_direction = 1
vim.g.clever_f_show_prompt = 1
vim.g.clever_f_mark_char = 1

-- ── Treesitter (new API — nvim-treesitter was fully rewritten for Neovim 0.12)
-- The old `nvim-treesitter.configs` module no longer exists.
-- Setup only accepts `install_dir`; highlighting is a Neovim built-in.
pcall(function()
  -- Optional: only needed if you want a custom install_dir
  -- require("nvim-treesitter").setup {}

  -- Install parsers async (no-op if already installed)
  require("nvim-treesitter").install {
    "vim", "lua", "vimdoc",
    "html", "css", "javascript", "typescript", "tsx",
    "python", "go", "rust", "c", "cpp",
    "bash", "json", "yaml", "markdown", "markdown_inline",
  }

  require("treesitter-context").setup {
    enable = true, max_lines = 0, min_window_height = 0,
    line_numbers = true, multiline_threshold = 20,
    trim_scope = "outer", mode = "cursor", zindex = 50,
  }

  local rd = require "rainbow-delimiters"
  require("rainbow-delimiters.setup").setup {
    strategy = {
      [""] = rd.strategy["global"],
      vim = rd.strategy["local"],
    },
    query = { [""] = "rainbow-delimiters", lua = "rainbow-blocks" },
    highlight = {
      "RainbowDelimiterRed", "RainbowDelimiterYellow", "RainbowDelimiterBlue",
      "RainbowDelimiterOrange", "RainbowDelimiterGreen", "RainbowDelimiterViolet",
      "RainbowDelimiterCyan",
    },
  }
end)

-- Enable treesitter highlighting for all file types (Neovim 0.11+ built-in)
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- ── Telescope ────────────────────────────────────────────────────────────────
local telescope = require "telescope"
local actions   = require "telescope.actions"

local history_dir = vim.fn.expand "~/.local/share/nvim/databases"
if vim.fn.isdirectory(history_dir) == 0 then
  vim.fn.mkdir(history_dir, "p")
end

telescope.setup {
  defaults = {
    prompt_prefix   = "   ",
    selection_caret = " ",
    entry_prefix    = " ",
    sorting_strategy = "ascending",
    layout_config = {
      horizontal = { prompt_position = "top", preview_width = 0.55 },
      width = 0.87, height = 0.80,
    },
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
      },
      n = {
        ["q"]     = actions.close,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
      },
    },
    history = {
      path  = history_dir .. "/telescope_history.sqlite3",
      limit = 500,
    },
  },
}
telescope.load_extension "smart_history"
telescope.load_extension "fzf"

-- ── NvimTree (lazy: toggle command) ──────────────────────────────────────────
require("nvim-tree").setup(require "configs.nvimtree")

-- ── Conform ───────────────────────────────────────────────────────────────────
pcall(function()
  require("conform").setup(require "configs.conform")
end)

-- ── Render Markdown ───────────────────────────────────────────────────────────
pcall(function()
  require("render-markdown").setup {
    file_types = { "markdown", "Avante" },
  }
end)

-- ── Trouble ───────────────────────────────────────────────────────────────────
require("trouble").setup {
  modes = {
    preview_float = {
      mode = "diagnostics",
      preview = {
        type = "float", relative = "editor", border = "rounded",
        title = "Preview", title_pos = "center",
        position = { 0, -2 }, size = { width = 0.3, height = 0.3 }, zindex = 200,
      },
    },
  },
}

-- ── Early retirement ──────────────────────────────────────────────────────────
require("early-retirement").setup {
  retirementAgeMins = 0,
  minimumBufferNum = 6,
  notificationOnAutoClose = true,
}
