-- Override nvim-cmp mappings with Copilot priority
local M = {}

M.setup = function()
  local cmp = require "cmp"

  -- Override the Tab mapping to prioritize Copilot suggestions
  local mapping = require("nvchad.configs.cmp").mapping
  mapping["<Tab>"] = cmp.mapping(function(fallback)
    -- First check if Copilot has a suggestion
    local copilot_keys = vim.fn["copilot#Accept"] ""
    if copilot_keys ~= "" then
      -- If Copilot has a suggestion, use it
      vim.api.nvim_feedkeys(copilot_keys, "i", true)
    elseif cmp.visible() then
      -- Otherwise, if cmp menu is visible, navigate to next item
      cmp.select_next_item()
    elseif require("luasnip").expand_or_jumpable() then
      -- If we can expand or jump in a snippet, do it
      require("luasnip").expand_or_jump()
    else
      -- Nothing special to do, let the original Tab key work
      fallback()
    end
  end, { "i", "s" })

  -- Apply our modified mapping to the cmp configuration
  require("cmp").setup {
    mapping = mapping,
  }
end

return M

