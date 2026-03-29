return {
  -- Full-featured Git TUI
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
    config = function()
      vim.g.lazygit_use_neovim_remote = false
      vim.env.GIT_EDITOR = "nvim"
      vim.g.lazygit_floating_window_scaling_factor = 0.97
      vim.g.lazygit_floating_window_border_chars = { "", "", "", "", "", "", "", "" }
    end,
  },

  -- Inline git blame
  {
    "f-person/git-blame.nvim",
    lazy = false,
    config = function()
      vim.cmd "highlight default link gitblame SpecialComment"
      vim.g.gitblame_enabled = 1
      vim.g.gitblame_message_template = "             <author> • <date> • <summary>"
    end,
  },

  -- Blame with stack navigation (like GitHub's "view blame prior to change")
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

  -- Gutter signs + hunk navigation
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = function()
      require("gitsigns").setup {
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
          map("v", "<leader>hr", function()
            gs.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
          end, { desc = "Reset hunk" })
          map("n", "<leader>hb", function()
            gs.blame_line { full = true }
          end, { desc = "Blame line (popup)" })
          map("n", "<leader>hB", function()
            gs.blame()
          end, { desc = "Blame buffer" })
        end,
      }
    end,
  },
}
