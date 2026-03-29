local map = vim.keymap.set

-- ── General ──────────────────────────────────────────────────────────────────
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear search highlights" })
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR>")

-- Save without formatting
vim.api.nvim_create_user_command("W", function()
  vim.cmd "noautocmd write"
end, { desc = "Save without formatting" })

-- ── Window navigation ─────────────────────────────────────────────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })

-- ── Buffer navigation ─────────────────────────────────────────────────────────
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprev<CR>", { desc = "Prev buffer" })
map("n", "<leader>x", function()
  require("snacks").bufdelete()
end, { desc = "Close buffer" })

-- ── File tree ─────────────────────────────────────────────────────────────────
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "Focus NvimTree" })

-- ── Telescope ─────────────────────────────────────────────────────────────────
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>", { desc = "Find all files" })
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Fuzzy find in buffer" })
map("n", "<leader>fk", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Git commits" })
map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Git status" })

-- ── LSP (buffer-local, set in on_attach; these handle the gr* defaults) ───────
-- gr* default mappings are deleted inside lspconfig on_attach to avoid conflicts

-- ── Auto-session ──────────────────────────────────────────────────────────────
map("n", "<leader>fs", function()
  require("auto-session.session-lens").search_session()
end, { noremap = true, desc = "Search session" })
map("n", "<leader>ws", "<cmd>AutoSession save<CR>", { desc = "Save session" })
map("n", "<leader>wr", "<cmd>AutoSession restore<CR>", { desc = "Restore session" })
map("n", "<leader>wd", "<cmd>AutoSession delete<CR>", { desc = "Delete session" })

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

-- ── Formatting ────────────────────────────────────────────────────────────────
map("n", "<leader>fm", function()
  require("conform").format { async = true, lsp_fallback = true }
end, { desc = "Format file" })

map("v", "<leader>fm", function()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  local range_client = nil
  for _, client in ipairs(clients) do
    if client.server_capabilities.documentRangeFormattingProvider then
      range_client = client
      break
    end
  end
  if range_client then
    vim.lsp.buf.format { async = true }
    vim.notify("Formatted with LSP range formatting", vim.log.levels.INFO)
  else
    local choice = vim.fn.confirm(
      "Range formatting not reliably supported.\nPrettier will format entire file.",
      "&Format entire file\n&Cancel",
      1
    )
    if choice == 1 then
      require("conform").format { async = true, lsp_fallback = true }
      vim.notify("Formatted entire file", vim.log.levels.INFO)
    end
  end
end, { desc = "Format selection" })

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

-- ── Change without yank ───────────────────────────────────────────────────────
map({ "n", "x" }, "c", '"_c', { noremap = true, desc = "Change without yank" })
map({ "n", "x" }, "C", '"_C', { noremap = true, desc = "Change to EOL without yank" })
map("n", "cc", '"_cc', { noremap = true, desc = "Change line without yank" })
map("n", "s", '"_s', { noremap = true, desc = "Substitute without yank" })
map("n", "S", '"_S', { noremap = true, desc = "Substitute line without yank" })

-- ── Diagnostics ───────────────────────────────────────────────────────────────
map("n", "dx", function()
  vim.diagnostic.open_float(nil, {
    focusable = true,
    border = "rounded",
    source = true,
    prefix = "",
    scope = "line",
  })
end, { desc = "Show diagnostic at cursor" })
