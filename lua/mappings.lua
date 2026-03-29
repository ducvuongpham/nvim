local map = vim.keymap.set

-- ── General ──────────────────────────────────────────────────────────────────
map("n", "<Esc>", "<cmd>noh<CR>",  { desc = "Clear highlights" })
map("n", ";",     ":",             { desc = "CMD enter command mode" })
map("i", "jk",    "<ESC>")
map("n", "<C-s>", "<cmd>w<CR>",    { desc = "Save file" })
map("n", "<C-c>", "<cmd>%y+<CR>",  { desc = "Copy whole file" })

map("n", "<leader>n",  "<cmd>set nu!<CR>",  { desc = "Toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "Toggle relative number" })

vim.api.nvim_create_user_command("W", function()
  vim.cmd "noautocmd write"
end, { desc = "Save without formatting" })

-- ── Insert mode movement (NvChad) ─────────────────────────────────────────────
map("i", "<C-b>", "<ESC>^i",  { desc = "Move beginning of line" })
map("i", "<C-e>", "<End>",    { desc = "Move end of line" })
map("i", "<C-h>", "<Left>",   { desc = "Move left" })
map("i", "<C-l>", "<Right>",  { desc = "Move right" })
map("i", "<C-j>", "<Down>",   { desc = "Move down" })
map("i", "<C-k>", "<Up>",     { desc = "Move up" })

-- ── Window navigation ─────────────────────────────────────────────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })

-- ── Buffer navigation ─────────────────────────────────────────────────────────
map("n", "<Tab>",     "<cmd>bnext<CR>",  { desc = "Next buffer" })
map("n", "<S-Tab>",   "<cmd>bprev<CR>",  { desc = "Prev buffer" })
map("n", "<leader>b", "<cmd>enew<CR>",   { desc = "New buffer" })
map("n", "<leader>x", function()
  require("snacks").bufdelete()
end, { desc = "Close buffer" })

-- ── File tree ─────────────────────────────────────────────────────────────────
map("n", "<C-n>",    "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>",  { desc = "Focus NvimTree" })

-- ── Telescope ─────────────────────────────────────────────────────────────────
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>",                                              { desc = "Find files" })
map("n", "<leader>fa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",       { desc = "Find all files" })
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>",                                               { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>",                                                 { desc = "Find buffers" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>",                                                { desc = "Recent files" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>",                              { desc = "Fuzzy find in buffer" })
map("n", "<leader>fk", "<cmd>Telescope help_tags<CR>",                                               { desc = "Help tags" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>",                                                   { desc = "Find marks" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>",                                             { desc = "Git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>",                                              { desc = "Git status" })

-- ── Auto-session ──────────────────────────────────────────────────────────────
map("n", "<leader>fs", function()
  require("auto-session.session-lens").search_session()
end, { noremap = true, desc = "Search session" })
map("n", "<leader>ws", function() require("auto-session").save_session() end,    { desc = "Save session" })
map("n", "<leader>wr", function() require("auto-session").restore_session() end, { desc = "Restore session" })
map("n", "<leader>wd", function() require("auto-session").delete_session() end,  { desc = "Delete session" })

-- ── Formatting ────────────────────────────────────────────────────────────────
map({ "n", "x" }, "<leader>fm", function()
  require("conform").format { async = true, lsp_fallback = true }
end, { desc = "Format file" })

map("n", "<leader>fh", function() require("configs.diff-format").format_hunks() end,        { desc = "Format git hunks" })
map("n", "<leader>fH", function() require("configs.diff-format").format_hunks_simple() end, { desc = "Format git hunks (simple)" })
map("n", "<leader>fv", function() require("configs.diff-format").show_hunks() end,           { desc = "View git hunks" })

-- ── LSP ───────────────────────────────────────────────────────────────────────
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "Diagnostic loclist" })

-- ── Trouble ───────────────────────────────────────────────────────────────────
map("n", "<leader>xx", function() require("trouble").toggle "diagnostics" end,                                          { desc = "Diagnostics" })
map("n", "<leader>xX", function() require("trouble").toggle { mode = "diagnostics", filter = { buf = 0 } } end,        { desc = "Buffer diagnostics" })
map("n", "<leader>cs", function() require("trouble").toggle "symbols" end,                                              { desc = "Symbols" })
map("n", "<leader>cl", function() require("trouble").toggle "lsp" end,                                                  { desc = "LSP refs/defs" })
map("n", "<leader>xL", function() require("trouble").toggle "loclist" end,                                              { desc = "Location list" })
map("n", "<leader>xQ", function() require("trouble").toggle "qflist" end,                                               { desc = "Quickfix list" })

-- ── Comment toggle ────────────────────────────────────────────────────────────
map("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })
map("v", "<leader>/", "gc",  { desc = "Toggle comment", remap = true })

-- ── Zen mode ──────────────────────────────────────────────────────────────────
map("n", "<leader>z", function() require("zen-mode").toggle() end, { desc = "Toggle Zen mode" })

-- ── Git ───────────────────────────────────────────────────────────────────────
map("n", "<leader>lg", function() require("lazygit").lazygit() end, { desc = "LazyGit" })
map("n", "<leader>gb", function() require("blame").toggle() end,    { desc = "Toggle git blame" })

-- ── Copilot ───────────────────────────────────────────────────────────────────
map("i", "<C-V>", "<Plug>(copilot-accept-word)", { desc = "Copilot accept word" })

-- ── Open in VSCode ────────────────────────────────────────────────────────────
map("n", "<leader>ox", function()
  local file_path = vim.fn.expand "%:p"
  if file_path ~= "" then
    vim.fn.system('code --goto "' .. file_path .. ":" .. vim.fn.line "." .. '"')
  else
    vim.notify("No file is open", vim.log.levels.WARN)
  end
end, { desc = "Open current file in VSCode" })

-- ── Change without yank ───────────────────────────────────────────────────────
map({ "n", "x" }, "c",  '"_c',  { noremap = true, desc = "Change without yank" })
map({ "n", "x" }, "C",  '"_C',  { noremap = true, desc = "Change to EOL without yank" })
map("n",          "cc", '"_cc', { noremap = true, desc = "Change line without yank" })
map("n",          "s",  '"_s',  { noremap = true, desc = "Substitute without yank" })
map("n",          "S",  '"_S',  { noremap = true, desc = "Substitute line without yank" })

-- ── Which-key ─────────────────────────────────────────────────────────────────
map("n", "<leader>wK", "<cmd>WhichKey<CR>",  { desc = "WhichKey all keymaps" })
map("n", "<leader>wk", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "WhichKey query lookup" })

-- ── Diagnostics ───────────────────────────────────────────────────────────────
map("n", "dx", function()
  vim.diagnostic.open_float(nil, {
    focusable = true, border = "rounded",
    source = true, prefix = "", scope = "line",
  })
end, { desc = "Show diagnostic at cursor" })
