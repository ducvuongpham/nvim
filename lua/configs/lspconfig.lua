require("nvchad.configs.lspconfig").defaults()

local servers = {
  -- Web development
  "html",
  "cssls",
  "ts_ls",
  "angularls",
  "cssmodules_ls",

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
  "jsonls",
  "bashls",
  "yamlls",

  -- C/C++ development
  "cmake",
  "clangd",
}
vim.lsp.enable(servers)
-- local nvlsp = require "nvchad.configs.lspconfig"
-- local lspconfig = require "lspconfig"
--
-- nvlsp.defaults() -- loads nvchad's defaults
--
-- local servers = { "html", "cssls", "ts_ls" }
--
-- -- lsps with default config
-- for _, lsp in ipairs(servers) do
--   lspconfig[lsp].setup {
--     on_attach = nvlsp.on_attach,
--     on_init = nvlsp.on_init,
--     capabilities = nvlsp.capabilities,
--   }
-- end
