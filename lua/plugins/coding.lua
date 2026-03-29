-- ── Copilot ───────────────────────────────────────────────────────────────────
require("copilot").setup {
  suggestion = {
    enabled      = true,
    auto_trigger = true,
    keymap       = { accept = false },  -- Tab handled in cmp mapping below
  },
  panel = { enabled = false },
  copilot_node_command = vim.fn.expand "~/.local/share/mise/installs/node/latest/bin/node",
  workspace_folders    = { vim.fn.expand "~/Program/aircloset/" },
}

-- ── Completion (lazy: load on InsertEnter) ────────────────────────────────────
vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    local ls = require "luasnip"

    -- Load snippets (vscode, snipmate, lua formats)
    require("luasnip.loaders.from_vscode").lazy_load { exclude = vim.g.vscode_snippets_exclude or {} }
    require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.vscode_snippets_path or "" }
    require("luasnip.loaders.from_snipmate").load()
    require("luasnip.loaders.from_snipmate").lazy_load { paths = vim.g.snipmate_snippets_path or "" }
    require("luasnip.loaders.from_lua").load()
    require("luasnip.loaders.from_lua").lazy_load { paths = vim.g.lua_snippets_path or "" }

    -- Fix luasnip session cleanup on InsertLeave (#258)
    vim.api.nvim_create_autocmd("InsertLeave", {
      callback = function()
        if ls.session.current_nodes[vim.api.nvim_get_current_buf()] and not ls.session.jump_active then
          ls.unlink_current()
        end
      end,
    })

    require "configs.cmp"
  end,
})

-- ── CodeCompanion ────────────────────────────────────────────────────────────
require("codecompanion").setup(require "configs.codecompanion")

-- ── Claude Code ──────────────────────────────────────────────────────────────
require("claudecode").setup {}
