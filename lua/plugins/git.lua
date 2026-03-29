-- Git related plugins
return {
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
    config = function()
      -- Configure lazygit.nvim to work with flatten.nvim
      vim.g.lazygit_use_neovim_remote = false -- We don't need nvr since flatten.nvim handles this
      vim.env.GIT_EDITOR = "nvim" -- Use regular nvim as the editor
      -- Fullscreen lazygit
      vim.g.lazygit_floating_window_scaling_factor = 0.97
      vim.g.lazygit_floating_window_border_chars = { "", "", "", "", "", "", "", "" }
    end,
  },

  {
    "f-person/git-blame.nvim",
    lazy = false,
    config = function()
      vim.cmd "highlight default link gitblame SpecialComment" -- change this to whatever highlight group you want
      vim.g.gitblame_enabled = 1 -- git blame is off by default
      vim.g.gitblame_message_template = "             <author> • <date> • <summary>" -- change this to whatever you want
    end,
  },

  -- Blame with stack navigation (like GitHub's "View blame prior to this change")
  {
    "FabijanZulj/blame.nvim",
    lazy = false,
    keys = {
      { "<leader>gb", "<cmd>BlameToggle<cr>", desc = "Toggle git blame" },
    },
    config = function()
      require("blame").setup {
        date_format = "%Y-%m-%d",
        merge_consecutive = true,
        commit_detail_view = "vsplit",
      }
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = function()
      require("gitsigns").setup {
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          -- Keymaps
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Reset hunk
          map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
          map("v", "<leader>hr", function()
            gs.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
          end, { desc = "Reset hunk" })

          -- Blame line popup
          map("n", "<leader>hb", function()
            gs.blame_line { full = true }
          end, { desc = "Blame line (popup)" })

          -- Blame buffer (with block style ┍│┕)
          map("n", "<leader>hB", function()
            gs.blame()
          end, { desc = "Blame buffer (block style)" })
        end,
      }
    end,
  },
}
