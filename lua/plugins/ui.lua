-- ── Theme ─────────────────────────────────────────────────────────────────────
require("catppuccin").setup {
  flavour = "mocha",
  highlight_overrides = {
    mocha = function(_)
      return {
        Comment = { style = { "italic" } },
        ["@comment"] = { style = { "italic" } },
        Visual = { bg = "#45475a" },
        TelescopeSelection = { bg = "#45475a" },
      }
    end,
  },
}
vim.cmd.colorscheme "catppuccin"

-- ── Statusline ────────────────────────────────────────────────────────────────
require("lualine").setup {
  options = {
    theme = "catppuccin-mocha",
    disabled_filetypes = { statusline = { "dashboard", "alpha" } },
  },
}

-- ── Breadcrumbs ───────────────────────────────────────────────────────────────
require("barbecue").setup {}
