-- ── Copilot (VimL — already sourced via packs.lua load=true) ─────────────────
vim.b.workspace_folder = vim.fn.expand "%:p:h"
vim.g.copilot_workspace_folders = "~/Program/aircloset/"
vim.api.nvim_buf_set_var(0, "workspace_folder", vim.fn.getcwd())
vim.g.copilot_node_command = "~/.local/share/mise/installs/node/latest/bin/node"

-- ── Completion (lazy: load on InsertEnter) ────────────────────────────────────
vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    require("luasnip.loaders.from_vscode").lazy_load()
    require "configs.cmp"
  end,
})

-- ── CodeCompanion ────────────────────────────────────────────────────────────
require("codecompanion").setup(require "configs.codecompanion")

-- ── Claude Code ──────────────────────────────────────────────────────────────
require("claudecode").setup {}
