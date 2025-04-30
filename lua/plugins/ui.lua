-- UI related plugins
return {
  -- {
  --   "Bekaboo/dropbar.nvim",
  --   lazy = false,
  --   -- optional, but required for fuzzy finder support
  --   dependencies = {
  --     "nvim-telescope/telescope-fzf-native.nvim",
  --     "nvim-tree/nvim-web-devicons", -- for file icons
  --   },
  --   config = function()
  --     local dropbar_api = require('dropbar.api')

  --     -- Set up keybindings
  --     vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
  --     vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
  --     vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })

  --     -- Use the correct LSP client function based on Neovim version
  --     local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients

  --     -- Configure dropbar to show relative paths and line info
  --     require('dropbar').setup({
  --       icons = {
  --         kinds = {
  --           use_devicons = true,
  --           symbols = {
  --             File = "󰈙 ",
  --             Module = " ",
  --             Namespace = "󰌗 ",
  --             Package = " ",
  --             Class = "󰌗 ",
  --             Method = "󰆧 ",
  --             Property = " ",
  --             Field = " ",
  --             Constructor = " ",
  --             Enum = "󰕘",
  --             Interface = "󰕘",
  --             Function = "󰊕 ",
  --             Variable = "󰆧 ",
  --             Constant = "󰏿 ",
  --             String = "󰀬 ",
  --             Number = "󰎠 ",
  --             Boolean = "◩ ",
  --             Array = "󰅪 ",
  --             Object = "󰅩 ",
  --             Key = "󰌋 ",
  --             Null = "󰟢 ",
  --             EnumMember = "󰊍 ",
  --             Struct = "󰌗 ",
  --             Event = " ",
  --             Operator = "󰆕 ",
  --             TypeParameter = "󰊄 ",
  --           },
  --         },
  --         ui = {
  --           bar = {
  --             separator = " > ",
  --             extends = "…",
  --           },
  --         },
  --       },
  --       bar = {
  --         enable = true, -- Moved from general.enable to bar.enable as per deprecation warning
  --         sources = function(buf, _)
  --           local sources = require('dropbar.sources')
  --           local utils = require('dropbar.utils')

  --           -- Always include file path source
  --           local path_source = sources.path

  --           -- Include LSP symbols source if available, using the proper clients function
  --           local has_lsp = #get_clients({ bufnr = buf }) > 0
  --           if has_lsp then
  --             return {
  --               path_source,
  --               sources.lsp,
  --             }
  --           else
  --             -- Fallback to treesitter when no LSP
  --             return {
  --               path_source,
  --               sources.treesitter,
  --             }
  --           end
  --         end,
  --       },
  --     })
  --   end
  -- },

  -- Commented out breadcrumbs.nvim since we're using dropbar.nvim instead
  -- {
  --   "LunarVim/breadcrumbs.nvim",
  --   lazy = false,
  --   dependencies = {
  --     { "SmiteshP/nvim-navic" },
  --   },
  --   config = function()
  --     require("breadcrumbs").setup()
  --   end
  -- },

  -- Commented out barbecue since it's archived
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    lazy = false,
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      -- configurations go here
    },
  },
}
