-- LSP stack: lazy-loaded on first real buffer open.
-- All LSP plugins are on the rtp (added by packs.lua) — we just defer setup.

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  once = true,
  callback = function()
    if not pcall(require, "mason") then return end  -- not installed yet

    -- Mason: install servers/tools
    require("mason").setup()
    local registry = require "mason-registry"
    registry.refresh(function()
      for _, tool in ipairs {
        "prettier", "typescript-language-server",
        "html-lsp", "css-lsp", "json-lsp", "eslint-lsp",
        "gopls", "goimports", "gofumpt", "golangci-lint",
        "clangd", "clang-format",
        "pyright", "black", "isort", "ruff",
        "rust-analyzer", "rustfmt",
        "lua-language-server", "stylua",
        "yaml-language-server", "marksman", "shellcheck", "shfmt",
      } do
        local ok, p = pcall(registry.get_package, tool)
        if ok and not p:is_installed() then p:install() end
      end
    end)

    -- LSP server configuration (vim.lsp.config + vim.lsp.enable)
    require "configs.lspconfig"

    -- none-ls: extra diagnostics / formatting sources
    require("null-ls").setup(require "configs.null-ls")

    -- Navbuddy: symbol navigation (auto-attaches via LSP)
    require("nvim-navbuddy").setup { lsp = { auto_attach = true } }

    -- DAP debugging UI
    local dap    = require "dap"
    local dapui  = require "dapui"
    dapui.setup()
    dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end

    -- Inline diagnostics (replaces virtual_text)
    require("tiny-inline-diagnostic").setup()
  end,
})
