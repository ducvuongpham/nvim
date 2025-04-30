require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map("n", "gr", "<cmd> lua vim.lsp.buf.references() <cr>", { desc = "LSP go to references" })

map("n", "<leader>fr", "<cmd> Telescope resume <CR>", { desc = "telescope resume last search" })

-- Open current file in VSCode
map("n", "<leader>ox", function()
  local file_path = vim.fn.expand("%:p")
  if file_path ~= "" then
    vim.fn.system('code --goto "' .. file_path .. ':' .. vim.fn.line(".") .. '"')
  else
    vim.notify("No file is open", vim.log.levels.WARN)
  end
end, { desc = "Open current file in eXternal VSCode" })

-- -- LazyGit with file focus
-- map("n", "<leader>gf", function()
--   local current_file = vim.fn.expand("%:p")
--   if current_file ~= "" then
--     vim.cmd("terminal lazygit -f " .. vim.fn.shellescape(current_file))
--   else
--     vim.cmd("terminal lazygit")
--   end
--   vim.cmd("startinsert")
-- end, { desc = "LazyGit focus on current file" })

-- -- Regular LazyGit
-- map("n", "<leader>gg", function()
--   vim.cmd("terminal lazygit")
--   vim.cmd("startinsert")
-- end, { desc = "Open LazyGit" })
