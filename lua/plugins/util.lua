-- Utility plugins
return {
  {
    "rmagatti/auto-session",
    lazy = false,
    config = function()
      require("auto-session").setup {
        log_level = vim.log.levels.ERROR,
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/", "~/Desktop" },
        root_dir = vim.fn.stdpath "data" .. "/tmp/sessions/",
        auto_session_use_git_branch = false,
        auto_restore_enabled = true,
        auto_save_enabled = true,

        pre_save_cmds = { "tabdo NvimTreeClose" },
        session_lens = {
          -- If load_on_setup is set to false, one needs to eventually call `require("auto-session").setup_session_lens()` if they want to use session-lens.
          buftypes_to_ignore = {}, -- list of buffer types what should not be deleted from current session
          load_on_setup = true,
          theme_conf = { border = true },
          previewer = false,
        },
      }

      vim.keymap.set("n", "<leader>fs", require("auto-session.session-lens").search_session, {
        noremap = true,
        desc = "Search Session",
      })
      vim.keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", {
        desc = "Save Session",
      })
      vim.keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", {
        desc = "Restore Session",
      })
      vim.keymap.set("n", "<leader>wd", "<cmd>SessionDelete<CR>", {
        desc = "Delete Session",
      })
    end,
  },

  {
    "willothy/flatten.nvim",
    lazy = false,
    opts = function()
      ---@type Terminal?
      local saved_terminal

      return {
        window = {
          open = "smart",
        },
        hooks = {
          should_block = function(argv)
            -- Note that argv contains all the parts of the CLI command, including
            -- Neovim's path, commands, options and files.
            -- See: :help v:argv

            -- In this case, we would block if we find the `-b` flag
            -- This allows you to use `nvim -b file1` instead of
            -- `nvim --cmd 'let g:flatten_wait=1' file1`
            return vim.tbl_contains(argv, "-b")

            -- Alternatively, we can block if we find the diff-mode option
            -- return vim.tbl_contains(argv, "-d")
          end,
          pre_open = function()
            -- Check if toggleterm is available
            local ok, term = pcall(require, "toggleterm.terminal")
            if ok then
              local termid = term.get_focused_id()
              saved_terminal = term.get(termid)
            end
          end,
          post_open = function(bufnr, winnr, ft, is_blocking)
            if is_blocking and saved_terminal then
              -- Hide the terminal while it's blocking
              saved_terminal:close()
            else
              -- If it's a normal file, just switch to its window
              vim.api.nvim_set_current_win(winnr)
            end

            -- If the file is a git commit, create one-shot autocmd to delete its buffer on write
            if ft == "gitcommit" or ft == "gitrebase" then
              vim.api.nvim_create_autocmd("BufWritePost", {
                buffer = bufnr,
                once = true,
                callback = vim.schedule_wrap(function()
                  vim.api.nvim_buf_delete(bufnr, {})
                end),
              })
            end
          end,
          block_end = function()
            -- After blocking ends (for a git commit, etc), reopen the terminal
            vim.schedule(function()
              if saved_terminal then
                saved_terminal:open()
                saved_terminal = nil
              end
            end)
          end,
        },
      }
    end,
  },

  -- {
  --   "samjwill/nvim-unception",
  --   init = function()
  --       -- Optional settings go here!
  --       -- e.g.) vim.g.unception_open_buffer_in_new_tab = true
  --   end
  -- },
}

