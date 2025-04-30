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
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    },
    config = function()
      -- Configure lazygit.nvim to work with flatten.nvim
      vim.g.lazygit_use_neovim_remote = false -- We don't need nvr since flatten.nvim handles this
      vim.env.GIT_EDITOR = "nvim" -- Use regular nvim as the editor
    end,
  },

  {
    "f-person/git-blame.nvim",
    lazy = false,
    config = function()
      vim.cmd('highlight default link gitblame SpecialComment') -- change this to whatever highlight group you want
      vim.g.gitblame_enabled = 1 -- git blame is off by default
      vim.g.gitblame_message_template = '             <author> • <date> • <summary>' -- change this to whatever you want
    end
  },

  -- Uncomment if you want to use gitsigns
  -- {
  --   "lewis6991/gitsigns.nvim",
  --   lazy = false,
  --   config = function()
  --     require('gitsigns').setup()
  --   end
  -- },
}
