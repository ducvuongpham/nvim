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
    end,
  },

  {
    "willothy/flatten.nvim",
    lazy = false,
    opts = function()
      local saved_terminal
      local saved_lazygit = {}

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
            -- Capture any LazyGit windows (filetype 'lazygit') so we can hide them
            saved_lazygit = {}
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local b = vim.api.nvim_win_get_buf(win)
              local ft = vim.api.nvim_buf_get_option(b, "filetype")
              if ft == "lazygit" then
                table.insert(saved_lazygit, { win = win, buf = b })
                -- Close the window (will hide LazyGit interface)
                pcall(vim.api.nvim_win_close, win, true)
              end
            end
          end,
          post_open = function(bufnr, winnr, ft, is_blocking)
            -- Support newer flatten versions that may pass a single context table
            if type(bufnr) == "table" and (bufnr.bufnr or bufnr.buffer or bufnr.win or bufnr.winnr) then
              local ctx = bufnr
              bufnr = ctx.bufnr or ctx.buffer or vim.api.nvim_get_current_buf()
              winnr = ctx.winnr or ctx.win or ctx.window or winnr
              ft = ctx.ft or ctx.filetype or ft
              is_blocking = ctx.is_blocking or ctx.blocking or is_blocking
            end
            -- Validate bufnr
            if type(bufnr) ~= "number" then
              bufnr = vim.api.nvim_get_current_buf()
            end
            if is_blocking then
              if saved_terminal then
                -- Hide the terminal while it's blocking
                saved_terminal:close()
              end
            else
              -- If it's a normal file, attempt to switch to its window safely
              -- Defensive: flatten sometimes passes a non-numeric winnr; validate before using
              local target = nil
              if type(winnr) == "number" and vim.api.nvim_win_is_valid(winnr) then
                target = winnr
              else
                -- Fallback: find a window displaying this buffer
                local buf_win = -1
                if type(bufnr) == "number" then
                  local ok_id, id = pcall(vim.fn.bufwinid, bufnr)
                  if ok_id then
                    buf_win = id
                  end
                end
                if buf_win ~= -1 and vim.api.nvim_win_is_valid(buf_win) then
                  target = buf_win
                end
              end
              if target then
                pcall(vim.api.nvim_set_current_win, target)
              end
            end

            -- If the file is a git commit, create one-shot autocmd to delete its buffer on write
            if ft == "gitcommit" or ft == "gitrebase" then
              vim.api.nvim_create_autocmd("BufWritePost", {
                buffer = bufnr,
                once = true,
                callback = vim.schedule_wrap(function()
                  if vim.api.nvim_buf_is_valid(bufnr) then
                    vim.api.nvim_buf_delete(bufnr, {})
                  end
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
              -- Restore LazyGit interface if it was open before
              if saved_lazygit and #saved_lazygit > 0 then
                -- Reopen LazyGit (simplest is to call the command)
                -- Only reopen if user still has a terminal environment (avoid surprise if they closed nvim quickly)
                pcall(vim.cmd, "LazyGit")
                saved_lazygit = {}
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
