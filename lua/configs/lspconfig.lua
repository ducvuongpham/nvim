-- LSP setup using Neovim's built-in vim.lsp.config / vim.lsp.enable
-- No nvim-lspconfig wrapper needed — nvim-lspconfig is still used as a
-- server-definition library (provides default cmd, filetypes, root_dir).

local M = {}

-- Capabilities: merge base + nvim-cmp completion items
M.capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("cmp_nvim_lsp").default_capabilities()
)

-- Disable semantic tokens (reduces noise, keeps highlighting via treesitter)
M.on_init = function(client, _)
  if client:supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

-- Buffer-local LSP keymaps
M.on_attach = function(client, bufnr)
  local map = function(mode, lhs, rhs, opts)
    opts = vim.tbl_extend("force", { buffer = bufnr, silent = true }, opts or {})
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
  map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
  map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
  map("n", "K", vim.lsp.buf.hover, { desc = "Hover docs" })
  map("n", "<leader>sh", vim.lsp.buf.signature_help, { desc = "Signature help" })
  map("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "Type definition" })
  map("n", "<leader>ra", vim.lsp.buf.rename, { desc = "Rename symbol" })
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
  map("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })

  -- Remove Neovim 0.11 default gr* mappings that conflict with our mappings
  pcall(vim.keymap.del, "n", "grr", { buffer = bufnr })
  pcall(vim.keymap.del, "n", "gri", { buffer = bufnr })
  pcall(vim.keymap.del, "n", "gra", { buffer = bufnr })
  pcall(vim.keymap.del, "n", "grn", { buffer = bufnr })
  pcall(vim.keymap.del, "n", "grt", { buffer = bufnr })
end

-- ── Helper ────────────────────────────────────────────────────────────────────

local function get_mise_node_cmd(cmd_name)
  local mason_bin = vim.fn.stdpath "data" .. "/mason/bin/" .. cmd_name
  return { "mise", "x", "node@latest", "--", mason_bin, "--stdio" }
end

-- ── Standard servers ──────────────────────────────────────────────────────────

local servers = {
  "gopls", "pyright", "sqls", "java_language_server",
  "ansiblels", "dockerls", "docker_compose_language_service", "terraformls",
  "nginx_language_server", "nixd", "lua_ls", "bashls",
  "cmake", "clangd", "rust_analyzer",
}

for _, lsp in ipairs(servers) do
  local config = {
    on_attach = M.on_attach,
    on_init = M.on_init,
    capabilities = M.capabilities,
  }

  if lsp == "lua_ls" then
    config.settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim", "Snacks" } },
        workspace = {
          library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" },
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      },
    }
  end

  vim.lsp.config(lsp, config)
  vim.lsp.enable(lsp)
end

-- ── Node.js-based servers (via mise) ─────────────────────────────────────────

local node_servers = {
  ts_ls = "typescript-language-server",
  cssls = "vscode-css-language-server",
  jsonls = "vscode-json-language-server",
  html = "vscode-html-language-server",
}

for server, cmd_name in pairs(node_servers) do
  local config = {
    on_attach = function(client, bufnr)
      M.on_attach(client, bufnr)
      -- Let Prettier/conform handle formatting for these
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
    on_init = M.on_init,
    capabilities = M.capabilities,
    cmd = get_mise_node_cmd(cmd_name),
  }

  if server == "ts_ls" then
    config.init_options = {
      preferences = { allowJs = true, checkJs = true },
    }
    config.filetypes = {
      "javascript", "javascriptreact", "javascript.jsx",
      "typescript", "typescriptreact", "typescript.tsx",
    }
  end

  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end

-- ── ESLint LSP ────────────────────────────────────────────────────────────────

local function get_eslint_cmd()
  local mason_eslint = vim.fn.stdpath "data" .. "/mason/bin/vscode-eslint-language-server"
  if vim.fn.filereadable(mason_eslint) == 1 then
    return { "mise", "x", "node@latest", "--", mason_eslint, "--stdio" }
  end
  return nil
end

local eslint_cmd = get_eslint_cmd()
if eslint_cmd then
  vim.lsp.config("eslint", {
    on_attach = function(client, bufnr)
      M.on_attach(client, bufnr)
      -- Auto-fix on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.code_action {
            context = { only = { "source.fixAll.eslint" } },
            apply = true,
          }
        end,
      })
    end,
    on_init = M.on_init,
    capabilities = M.capabilities,
    cmd = eslint_cmd,
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "astro" },
    settings = {
      eslint = {
        enable = true,
        format = { enable = true },
        workingDirectories = { mode = "location" },
        validate = "on",
        run = "onType",
        autoFixOnSave = true,
      },
    },
    root_dir = function(fname)
      return vim.fs.root(fname, {
        ".eslintrc", ".eslintrc.js", ".eslintrc.json", ".eslintrc.yml", ".eslintrc.yaml",
        "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs", "package.json",
      })
    end,
  })
  vim.lsp.enable "eslint"
else
  vim.notify("ESLint LSP not found — install via Mason (eslint-lsp)", vim.log.levels.WARN)
end

-- ── Diagnostics display ───────────────────────────────────────────────────────

vim.diagnostic.config {
  virtual_text = false, -- tiny-inline-diagnostic.nvim handles inline display
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
}

return M
