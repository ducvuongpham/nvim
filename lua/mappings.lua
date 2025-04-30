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
map("n", "<leader>fs", function() require("auto-session.session-lens").search_session() end, 
    { noremap = true, desc = "search session" })
map("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "save session" })
map("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "restore session" })
map("n", "<leader>wd", "<cmd>SessionDelete<CR>", { desc = "delete session" })

-- Copilot mappings
map("i", "<C-V>", "<Plug>(copilot-accept-word)", { desc = "copilot accept word" })

-- Open current file in VSCode
map("n", "<leader>ox", function()
  local file_path = vim.fn.expand("%:p")
  if file_path ~= "" then
    vim.fn.system('code --goto "' .. file_path .. ':' .. vim.fn.line(".") .. '"')
  else
    vim.notify("No file is open", vim.log.levels.WARN)
  end
end, { desc = "Open current file in eXternal VSCode" })

-- Uncomment if you want to use these dropbar mappings
-- map('n', '<Leader>;', function() require('dropbar.api').pick() end, { desc = 'pick symbols in winbar' })
-- map('n', '[;', function() require('dropbar.api').goto_context_start() end, { desc = 'go to start of current context' })
-- map('n', '];', function() require('dropbar.api').select_next_context() end, { desc = 'select next context' })
