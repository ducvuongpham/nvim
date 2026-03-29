local cmp     = require "cmp"
local luasnip  = require "luasnip"

-- Load NvChad cmp highlights from base46 cache
pcall(dofile, vim.g.base46_cache .. "cmp")

cmp.setup {
  completion = { completeopt = "menu,menuone" },

  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  mapping = {
    ["<C-p>"]     = cmp.mapping.select_prev_item(),
    ["<C-n>"]     = cmp.mapping.select_next_item(),
    ["<C-d>"]     = cmp.mapping.scroll_docs(-4),
    ["<C-f>"]     = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"]     = cmp.mapping.close(),

    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select   = true,
    },

    ["<Tab>"] = cmp.mapping(function(fallback)
      local copilot = require "copilot.suggestion"
      if copilot.is_visible() then
        copilot.accept()
      elseif cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },

  formatting = require("nvchad.cmp").formatting,
  window     = require("nvchad.cmp").window,

  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "nvim_lua" },
    { name = "path" },
  },
}
