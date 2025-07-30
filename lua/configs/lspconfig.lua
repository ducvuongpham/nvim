local nvlsp = require "nvchad.configs.lspconfig"
local lspconfig = require "lspconfig"

nvlsp.defaults() -- loads nvchad's defaults

-- Common command prefix for Node.js-based LSP servers
local function get_mise_node_cmd(cmd)
  return { "mise", "x", "node@latest", "--", "/Users/pc391/.local/share/nvim/mason/bin/typescript-language-server", "--stdio" }
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
