-- LSP setup for Neovim 0.12
-- Follows NvChad v2.5 pattern: LspAttach for keymaps, vim.lsp.config("*") for globals,
-- nvim-lspconfig lsp/<name>.lua provides cmd/filetypes/root_dir automatically.

local map = vim.keymap.set

-- ── Keymaps via LspAttach (cleaner than per-server on_attach) ─────────────────

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local function opts(desc)
      return { buffer = bufnr, silent = true, desc = desc }
    end

    map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
    map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
    map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
    map("n", "gr", vim.lsp.buf.references, opts "Go to references")
    map("n", "K", vim.lsp.buf.hover, opts "Hover docs")
    map("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Signature help")
    map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Type definition")
    map("n", "<leader>ra", function()
      require "nvchad.lsp.renamer"()
    end, opts "Rename symbol")
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")

    -- NvChad LSP signature (auto-shows signature help on trigger chars)
    if client then
      pcall(require("nvchad.lsp.signature").setup, client, bufnr)
    end

    -- Remove Neovim 0.11 default gr* mappings that conflict
    pcall(vim.keymap.del, "n", "grr", { buffer = bufnr })
    pcall(vim.keymap.del, "n", "gri", { buffer = bufnr })
    pcall(vim.keymap.del, "n", "gra", { buffer = bufnr })
    pcall(vim.keymap.del, "n", "grn", { buffer = bufnr })
    pcall(vim.keymap.del, "n", "grt", { buffer = bufnr })
  end,
})

-- ── Global config (applied to every server) ───────────────────────────────────

local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("cmp_nvim_lsp").default_capabilities()
)

-- nvim-ufo: tell servers we support foldingRange so they send fold regions
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

vim.lsp.config("*", {
  capabilities = capabilities,
  -- Disable semantic tokens — treesitter handles highlighting
  on_init = function(client, _)
    if client:supports_method "textDocument/semanticTokens" then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})

-- ── Enable servers (nvim-lspconfig lsp/*.lua provides cmd/filetypes/root_dir) ─

vim.lsp.enable {
  "gopls",
  "pyright",
  "lua_ls",
  "bashls",
  "clangd",
  "rust_analyzer",
  "dockerls",
  "terraformls",
  "yamlls",
  "marksman",
  "vtsls",
  "cssls",
  "jsonls",
  "html",
  "eslint",
}

-- ── Per-server overrides (only what differs from nvim-lspconfig defaults) ──────

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim", "Snacks" } },
      workspace = {
        library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" },
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

-- Node servers: override cmd to use a fixed, modern node (not the per-project one).
-- mason bin scripts use #!/usr/bin/env node and may pick up an old system node.
local function find_lsp_node()
  -- Prefer mise's `latest` symlink — always points to the newest installed version
  local latest = vim.fn.expand "~/.local/share/mise/installs/node/latest/bin/node"
  if vim.fn.executable(latest) == 1 then
    return latest
  end
  -- Fallback: ask mise directly
  local r = vim.system({ "mise", "x", "node@latest", "--", "node", "--print-exe-path" }):wait()
  if r and r.code == 0 then
    return vim.trim(r.stdout)
  end
  return "node"
end

local node_bin = find_lsp_node()
local mason_bin = vim.fn.stdpath "data" .. "/mason/bin/"
local mason_pkg = vim.fn.stdpath "data" .. "/mason/packages/"

local function node_cmd(script, max_mb)
  return { node_bin, "--max-old-space-size=" .. (max_mb or 256), mason_bin .. script, "--stdio" }
end

local function find_bun()
  for _, c in ipairs {
    vim.fn.expand "~/.local/share/mise/installs/bun/latest/bin/bun",
    vim.fn.expand "~/.bun/bin/bun",
    "bun",
  } do
    if vim.fn.executable(c) == 1 then
      return c
    end
  end
end

local bun_bin = find_bun()

local function bun_cmd(script, max_mb)
  if bun_bin then
    return { bun_bin, "--max-old-space-size=" .. (max_mb or 256), mason_bin .. script, "--stdio" }
  end
  return node_cmd(script, max_mb)
end

-- Disable formatting for node servers — Prettier/conform handles it
local function no_format(client)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    if vim.tbl_contains({ "vtsls", "cssls", "jsonls", "html" }, client.name) then
      no_format(client)
    end
    if client.name == "eslint" then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.code_action { context = { only = { "source.fixAll.eslint" } }, apply = true }
        end,
      })
    end
  end,
})

-- vtsls: VS Code-compatible TS server (handles vue + ts/js as fallback)
local vtsls_js = mason_pkg .. "vtsls/node_modules/@vtsls/language-server/bin/vtsls.js"
vim.lsp.config("vtsls", {
  cmd = (bun_bin and vim.fn.filereadable(vtsls_js) == 1)
      and { bun_bin, "--max-old-space-size=2048", vtsls_js, "--stdio" }
    or node_cmd("vtsls", 2048),
  filetypes = { "vue" },
  settings = {
    vtsls = { enableMoveToFileCodeAction = true, autoUseWorkspaceTsdk = true },
    typescript = {
      preferences = { quoteStyle = "single" },
      inlayHints = { parameterNames = { enabled = "literals" } },
      suggest = { completeFunctionCalls = false },
      tsserver = { maxTsServerMemory = 2048 },
    },
    javascript = {
      preferences = { quoteStyle = "single" },
    },
  },
})
local function vscode_ls_cmd(pkg, entry, max_mb)
  local js = mason_pkg .. pkg .. "/node_modules/vscode-langservers-extracted/lib/" .. entry
  if bun_bin and vim.fn.filereadable(js) == 1 then
    return { bun_bin, "--max-old-space-size=" .. (max_mb or 256), js, "--stdio" }
  end
  return bun_cmd(pkg:gsub("-lsp$", ""):gsub("^", "vscode-") .. "-language-server", max_mb)
end

vim.lsp.config("cssls", { cmd = vscode_ls_cmd("css-lsp", "css-language-server/cssServer.js") })
vim.lsp.config("jsonls", { cmd = vscode_ls_cmd("json-lsp", "json-language-server/jsonServer.js") })
vim.lsp.config("html", { cmd = vscode_ls_cmd("html-lsp", "html-language-server/htmlServer.js") })
vim.lsp.config("eslint", { cmd = vscode_ls_cmd("eslint-lsp", "eslint-language-server/eslintServer.js") })

-- ── Diagnostics display ───────────────────────────────────────────────────────

vim.diagnostic.config {
  virtual_text = false,
  virtual_lines = { current_line = true }, -- show below current line (Neovim 0.12 built-in)
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
