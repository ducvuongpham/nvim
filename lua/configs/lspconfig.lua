local nvlsp = require "nvchad.configs.lspconfig"
local lspconfig = require "lspconfig"

nvlsp.defaults() -- loads nvchad's defaults

-- Common command prefix for Node.js-based LSP servers
local function get_mise_node_cmd(cmd_name)
  local mason_bin = vim.fn.stdpath "data" .. "/mason/bin/" .. cmd_name
  return { "mise", "x", "node@latest", "--", mason_bin, "--stdio" }
end

local servers = {
  -- Web development
  -- "html", -- Handle separately with mise
  -- "cssls", -- Handle separately with mise
  -- "ts_ls", -- Handle separately with mise
  -- "angularls", -- Handle separately with mise
  -- "cssmodules_ls", -- Handle separately with mise

  -- Backend development
  "gopls",
  "pyright",
  "sqls",
  "java_language_server",

  -- DevOps and Infrastructure
  "ansiblels",
  "dockerls",
  "docker_compose_language_service",
  "terraformls",

  -- Configuration and Scripting
  "nginx_language_server",
  "nixd",
  "lua_ls",
  -- "jsonls", -- Handle separately with mise
  "bashls",
  -- "yamlls",

  -- C/C++ development
  "cmake",
  "clangd",
}

-- Setup servers with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- Node.js-based servers that need mise for compatibility
local node_servers = {
  ts_ls = "typescript-language-server",
  cssls = "vscode-css-language-server",
  jsonls = "vscode-json-language-server",
  -- cssmodules_ls = "cssmodules-language-server",
  -- angularls = "@angular/language-server", -- Not for AngularJS (1.x)
  html = "vscode-html-language-server",
}

-- Setup Node.js-based servers with mise
for server, cmd_name in pairs(node_servers) do
  local config = {
    on_attach = function(client, bufnr)
      nvlsp.on_attach(client, bufnr)
      -- Disable formatting for these servers to let Prettier handle it
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    cmd = get_mise_node_cmd(cmd_name),
  }

  -- Special configuration for ts_ls to support AngularJS
  if server == "ts_ls" then
    config.init_options = {
      preferences = {
        -- Enable JavaScript support for .js files
        allowJs = true,
        checkJs = true,
      },
    }
    config.filetypes =
      { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
  end

  lspconfig[server].setup(config)
end

-- Setup ESLint LSP for diagnostics
-- ESLint language server is bundled with vscode-langservers-extracted packages
local function get_eslint_cmd()
  -- Try different possible locations for the ESLint language server
  local possible_paths = {
    vim.fn.stdpath "data"
      .. "/mason/packages/html-lsp/node_modules/vscode-langservers-extracted/bin/vscode-eslint-language-server",
    vim.fn.stdpath "data"
      .. "/mason/packages/css-lsp/node_modules/vscode-langservers-extracted/bin/vscode-eslint-language-server",
    vim.fn.stdpath "data"
      .. "/mason/packages/json-lsp/node_modules/vscode-langservers-extracted/bin/vscode-eslint-language-server",
  }

  for _, path in ipairs(possible_paths) do
    if vim.fn.filereadable(path) == 1 then
      return { "mise", "x", "node@latest", "--", path, "--stdio" }
    end
  end

  -- Fallback to system eslint_d if available
  if vim.fn.executable "eslint_d" == 1 then
    return { "eslint_d", "--stdin", "--stdin-filename", "$FILENAME", "--format", "json" }
  end

  return nil
end

local eslint_cmd = get_eslint_cmd()
if eslint_cmd then
  lspconfig.eslint.setup {
    on_attach = function(client, bufnr)
      nvlsp.on_attach(client, bufnr)

      -- Enable ESLint auto-fix on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.cmd "EslintFixAll"
        end,
      })
    end,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    cmd = eslint_cmd,
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
    settings = {
      eslint = {
        enable = true,
        autoFixOnSave = true,
        codeActionsOnSave = {
          mode = "all",
          rules = { "!debugger", "!no-only-tests/*" },
        },
      },
    },
    root_dir = function(fname)
      return lspconfig.util.root_pattern(
        ".eslintrc",
        ".eslintrc.js",
        ".eslintrc.cjs",
        ".eslintrc.yaml",
        ".eslintrc.yml",
        ".eslintrc.json",
        "eslint.config.js",
        "eslint.config.mjs",
        "eslint.config.cjs",
        "package.json"
      )(fname)
    end,
  }
end

-- Setup Prettier as a formatting-only "LSP" (efm-langserver approach)
-- This gives you Prettier diagnostics by showing formatting differences
local efm_config = {
  on_attach = function(client, bufnr)
    nvlsp.on_attach(client, bufnr)
    -- Only enable formatting, not other LSP features
    client.server_capabilities.documentFormattingProvider = true
    client.server_capabilities.documentRangeFormattingProvider = true
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.completionProvider = nil
  end,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = get_mise_node_cmd "prettier",
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "css",
    "scss",
    "less",
    "html",
    "json",
    "jsonc",
    "yaml",
    "yml",
    "markdown",
    "mdx",
    "vue",
    "svelte",
    "astro",
  },
  root_dir = function(fname)
    return lspconfig.util.root_pattern(
      ".prettierrc",
      ".prettierrc.json",
      ".prettierrc.yml",
      ".prettierrc.yaml",
      ".prettierrc.js",
      ".prettierrc.cjs",
      "prettier.config.js",
      "prettier.config.cjs",
      "package.json"
    )(fname)
  end,
  settings = {},
}

-- Only setup if prettier is available
local prettier_available = vim.fn.executable "prettier" == 1
  or vim.fn.filereadable(vim.fn.stdpath "data" .. "/mason/bin/prettier") == 1

if prettier_available then
  -- Note: We'll let conform.nvim handle the actual formatting
  -- This is just for reference - Prettier works best as a formatter, not LSP
end

-- Additional diagnostics configuration
-- Disable default virtual_text since tiny-inline-diagnostic will handle it
vim.diagnostic.config {
  virtual_text = false, -- Disable default virtual text to use tiny-inline-diagnostic
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
