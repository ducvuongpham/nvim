return {
  -- Session management
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
          load_on_setup = true,
          theme_conf = { border = true },
          previewer = false,
        },
      }
    end,
  },

  -- Open files from terminal in parent Neovim instance
  {
    "willothy/flatten.nvim",
    lazy = false,
    opts = function()
      local saved_terminal
      local saved_lazygit = {}

      return {
        window = { open = "smart" },
        hooks = {
          should_block = function(argv)
            return vim.tbl_contains(argv, "-b")
          end,
          pre_open = function()
            local ok, term = pcall(require, "toggleterm.terminal")
            if ok then
              local termid = term.get_focused_id()
              saved_terminal = term.get(termid)
            end
            saved_lazygit = {}
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local b = vim.api.nvim_win_get_buf(win)
              local ft = vim.api.nvim_buf_get_option(b, "filetype")
              if ft == "lazygit" then
                table.insert(saved_lazygit, { win = win, buf = b })
                pcall(vim.api.nvim_win_close, win, true)
              end
            end
          end,
          post_open = function(bufnr, winnr, ft, is_blocking)
            if type(bufnr) == "table" and (bufnr.bufnr or bufnr.buffer or bufnr.win or bufnr.winnr) then
              local ctx = bufnr
              bufnr = ctx.bufnr or ctx.buffer or vim.api.nvim_get_current_buf()
              winnr = ctx.winnr or ctx.win or ctx.window or winnr
              ft = ctx.ft or ctx.filetype or ft
              is_blocking = ctx.is_blocking or ctx.blocking or is_blocking
            end
            if type(bufnr) ~= "number" then
              bufnr = vim.api.nvim_get_current_buf()
            end
            if is_blocking then
              if saved_terminal then
                saved_terminal:close()
              end
            else
              local target = nil
              if type(winnr) == "number" and vim.api.nvim_win_is_valid(winnr) then
                target = winnr
              else
                local buf_win = -1
                if type(bufnr) == "number" then
                  local ok_id, id = pcall(vim.fn.bufwinid, bufnr)
                  if ok_id then buf_win = id end
                end
                if buf_win ~= -1 and vim.api.nvim_win_is_valid(buf_win) then
                  target = buf_win
                end
              end
              if target then
                pcall(vim.api.nvim_set_current_win, target)
              end
            end
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
            vim.schedule(function()
              if saved_terminal then
                saved_terminal:open()
                saved_terminal = nil
              end
              if saved_lazygit and #saved_lazygit > 0 then
                pcall(vim.cmd, "LazyGit")
                saved_lazygit = {}
              end
            end)
          end,
        },
      }
    end,
  },

  -- Snow effect (fun)
  {
    "marcussimonsen/let-it-snow.nvim",
    cmd = "LetItSnow",
    opts = {},
  },

  -- Walking cat/duck Easter egg
  {
    "tamton-aquib/duck.nvim",
    keys = {
      { "<leader>dd", function() require("duck").hatch "🐈" end, desc = "Hatch a cat" },
      { "<leader>dk", function() require("duck").cook() end,    desc = "Cook a cat" },
      { "<leader>da", function() require("duck").cook_all() end, desc = "Cook all cats" },
    },
  },
}
