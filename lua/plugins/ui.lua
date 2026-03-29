-- ── Theme ─────────────────────────────────────────────────────────────────────
require("catppuccin").setup {
  flavour = "mocha",
  highlight_overrides = {
    mocha = function(c)
      return {
        Comment            = { style = { "italic" } },
        ["@comment"]       = { style = { "italic" } },
        Visual             = { bg = "#45475a" },
        TelescopeSelection = { bg = "#45475a" },
        -- Fold column: subtle arrow color like VSCode's gutter
        FoldColumn         = { fg = c.overlay1, bg = "NONE" },
        -- Folded line background: slightly highlighted like VSCode
        Folded             = { fg = c.text, bg = c.surface0, style = { "italic" } },
        -- ufo ellipsis ("⋯ N lines") — matches VSCode's dimmed fold hint
        UfoFoldedEllipsis  = { fg = c.overlay2, bg = "NONE" },
      }
    end,
  },
}
vim.cmd.colorscheme "catppuccin"

-- ── Base46 (NvChad theming engine — generates highlight cache) ────────────────
-- Must run AFTER colorscheme to avoid highlights being wiped by ColorScheme event
pcall(function()
  require("base46").load_all_highlights()
end)

-- ── Statusline ────────────────────────────────────────────────────────────────
require("lualine").setup {
  options = {
    theme = "catppuccin-mocha",
    disabled_filetypes = { statusline = { "dashboard", "alpha" } },
  },
}

-- ── Breadcrumbs ───────────────────────────────────────────────────────────────
require("barbecue").setup {}

-- ── Which-key ─────────────────────────────────────────────────────────────────
require("which-key").setup {}

-- ── NvChad UI (tabufline + colorify) ──────────────────────────────────────────
pcall(function()
  require("nvchad").setup {
    tabufline = { enabled = true, lazyload = false },
    statusline = { enabled = false },
  }
  require("nvchad.colorify").setup()
end)
