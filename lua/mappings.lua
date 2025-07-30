require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map("n", "gr", "<cmd> lua vim.lsp.buf.references() <cr>", { desc = "LSP go to references" })

-- Telescope mappings
map("n", "<leader>fr", "<cmd> Telescope resume <CR>", { desc = "telescope resume last search" })

-- Auto-session mappings
map("n", "<leader>fs", function()
  require("auto-session.session-lens").search_session()
end, { noremap = true, desc = "search session" })
map("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "save session" })
map("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "restore session" })
map("n", "<leader>wd", "<cmd>SessionDelete<CR>", { desc = "delete session" })

-- Copilot mappings
map("i", "<C-V>", "<Plug>(copilot-accept-word)", { desc = "copilot accept word" })

-- Open current file in VSCode
map("n", "<leader>ox", function()
  local file_path = vim.fn.expand "%:p"
  if file_path ~= "" then
    vim.fn.system('code --goto "' .. file_path .. ":" .. vim.fn.line "." .. '"')
  else
    vim.notify("No file is open", vim.log.levels.WARN)
  end
end, { desc = "Open current file in eXternal VSCode" })

-- Format entire file (normal mode)
map("n", "<leader>fm", function()
  require("conform").format { async = true, lsp_fallback = true }
end, { desc = "Format file" })

-- Format selection (visual mode)
map("v", "<leader>fm", function()
  -- First try LSP range formatting
  local clients = vim.lsp.get_active_clients { bufnr = 0 }
  local range_client = nil

  for _, client in ipairs(clients) do
    if client.server_capabilities.documentRangeFormattingProvider then
      range_client = client
      break
    end
  end

  if range_client then
    -- Use LSP range formatting (more reliable)
    vim.lsp.buf.format { async = true }
    vim.notify("Formatted with LSP range formatting", vim.log.levels.INFO)
  else
    -- Fallback: Inform user and ask
    local choice = vim.fn.confirm(
      "Range formatting not reliably supported by Prettier.\nPrettier will format entire file.",
      "&Format entire file\n&Cancel",
      1
    )

    if choice == 1 then
      require("conform").format { async = true, lsp_fallback = true }
      vim.notify("Formatted entire file", vim.log.levels.INFO)
    end
  end
end, { desc = "Format selection (with fallback)" })

-- DiffFormat: Format only git hunks
map("n", "<leader>fh", function()
  require("configs.diff-format").format_hunks()
end, { desc = "Format git hunks (range method)" })

map("n", "<leader>fH", function()
  require("configs.diff-format").format_hunks_simple()
end, { desc = "Format git hunks (simple method)" })

map("n", "<leader>fv", function()
  require("configs.diff-format").show_hunks()
end, { desc = "View git hunks" })

map("n", "<leader>ft", function()
  require("configs.diff-format").test()
end, { desc = "Test DiffFormat (debug)" })

map("n", "<leader>fg", function()
  require("configs.diff-format").git_status()
end, { desc = "Check git status" })

-- Uncomment if you want to use these dropbar mappings
-- map('n', '<Leader>;', function() require('dropbar.api').pick() end, { desc = 'pick symbols in winbar' })
-- map('n', '[;', function() require('dropbar.api').goto_context_start() end, { desc = 'go to start of current context' })
-- map('n', '];', function() require('dropbar.api').select_next_context' end, { desc = 'select next context' })
