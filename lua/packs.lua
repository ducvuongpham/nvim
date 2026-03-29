-- ── Build steps (must be registered BEFORE vim.pack.add) ─────────────────────
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local spec, kind, path = ev.data.spec, ev.data.kind, ev.data.path
    if spec.name == "telescope-fzf-native.nvim" and kind ~= "delete" then
      vim.system({ "make" }, { cwd = path }):wait()
    end
  end,
})

-- ── Lua plugins ───────────────────────────────────────────────────────────────
-- load = false (default during init.lua): added to rtp but plugin/ not sourced.
-- Pure-Lua plugins work fine with just require("plugin").setup() below.
vim.pack.add({
  -- Core deps
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/kkharji/sqlite.lua" },

  -- UI
  { src = "https://github.com/catppuccin/nvim",             name = "catppuccin" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/SmiteshP/nvim-navic" },
  { src = "https://github.com/utilyre/barbecue.nvim" },
  { src = "https://github.com/NvChad/base46" },
  { src = "https://github.com/NvChad/ui" },

  -- Editor
  { src = "https://github.com/folke/which-key.nvim" },
  { src = "https://github.com/folke/snacks.nvim" },
  { src = "https://github.com/stevearc/dressing.nvim" },
  { src = "https://github.com/folke/zen-mode.nvim" },
  { src = "https://github.com/chrisgrieser/nvim-early-retirement" },
  { src = "https://github.com/folke/trouble.nvim" },
  { src = "https://github.com/kylesnowschwartz/prompt-tower.nvim" },
  { src = "https://github.com/stevearc/conform.nvim" },

  -- Treesitter
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
  { src = "https://github.com/HiPhish/rainbow-delimiters.nvim" },
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
  { src = "https://github.com/windwp/nvim-ts-autotag" },

  -- Telescope
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim",    name = "telescope-fzf-native.nvim" },
  { src = "https://github.com/nvim-telescope/telescope-smart-history.nvim" },

  -- Completion
  { src = "https://github.com/hrsh7th/nvim-cmp" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
  { src = "https://github.com/hrsh7th/cmp-buffer" },
  { src = "https://github.com/hrsh7th/cmp-path" },
  { src = "https://github.com/L3MON4D3/LuaSnip",                           name = "LuaSnip" },
  { src = "https://github.com/saadparwaiz1/cmp_luasnip" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },

  -- LSP
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/williamboman/mason.nvim" },
  { src = "https://github.com/nvimtools/none-ls.nvim" },
  { src = "https://github.com/nvimtools/none-ls-extras.nvim" },
  { src = "https://github.com/SmiteshP/nvim-navbuddy" },
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/rcarriga/nvim-dap-ui" },
  { src = "https://github.com/nvim-neotest/nvim-nio" },

  -- Git
  { src = "https://github.com/kdheepak/lazygit.nvim" },
  { src = "https://github.com/f-person/git-blame.nvim" },
  { src = "https://github.com/FabijanZulj/blame.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },

  -- Mini
  { src = "https://github.com/echasnovski/mini.nvim" },

  -- AI / coding
  { src = "https://github.com/zbirenbaum/copilot.lua" },
  { src = "https://github.com/olimorris/codecompanion.nvim" },
  { src = "https://github.com/coder/claudecode.nvim" },
  { src = "https://github.com/j-hui/fidget.nvim" },
  { src = "https://github.com/echasnovski/mini.pick",                       name = "mini.pick" },
  { src = "https://github.com/ibhagwan/fzf-lua" },
  { src = "https://github.com/ravitemer/mcphub.nvim" },

  -- Folding
  { src = "https://github.com/kevinhwang91/promise-async" },
  { src = "https://github.com/kevinhwang91/nvim-ufo" },

  -- Utilities
  { src = "https://github.com/rmagatti/auto-session" },
  { src = "https://github.com/willothy/flatten.nvim" },
  { src = "https://github.com/marcussimonsen/let-it-snow.nvim" },
  { src = "https://github.com/tamton-aquib/duck.nvim" },

  -- File tree
  { src = "https://github.com/nvim-tree/nvim-tree.lua" },

  -- VimL plugins (need load = true so their plugin/*.vim files are sourced)
  { src = "https://github.com/rhysd/clever-f.vim" },
  { src = "https://github.com/andymass/vim-matchup" },
}, { confirm = false, load = true })
