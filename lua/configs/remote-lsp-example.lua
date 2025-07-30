-- Remote LSP Configuration Example
-- This is a complete example showing how to use LSP servers on a remote machine via SSH
-- Based on your current lspconfig.lua but modified for remote usage

local nvlsp = require "nvchad.configs.lspconfig"
local lspconfig = require "lspconfig"

nvlsp.defaults() -- loads nvchad's defaults

-- ============================================================================
-- REMOTE CONFIGURATION
-- ============================================================================

-- Set this to your remote host (e.g., "user@192.168.1.100" or "myuser@dev-server")
-- Set to nil to use local servers
local REMOTE_HOST = "user@remote-server" -- CHANGE THIS TO YOUR REMOTE HOST

-- SSH options for better performance (connection reuse)
local SSH_OPTS = {
  "-o",
  "ControlMaster=auto",
  "-o",
  "ControlPath=/tmp/nvim-lsp-%r@%h:%p",
  "-o",
  "ControlPersist=10m",
  "-o",
  "ServerAliveInterval=60",
}

-- ============================================================================
-- COMMAND BUILDERS
-- ============================================================================

-- Local command prefix for Node.js-based LSP servers
local function get_local_mise_node_cmd(cmd)
  return { "mise", "exec", "node@latest", "--", cmd, "--stdio" }
end

-- Remote command prefix via SSH
local function get_remote_mise_node_cmd(host, cmd)
  local ssh_cmd = { "ssh" }
  vim.list_extend(ssh_cmd, SSH_OPTS)
  vim.list_extend(ssh_cmd, { host, "mise", "exec", "node@latest", "--", cmd, "--stdio" })
  return ssh_cmd
end

-- Helper to get the appropriate command based on REMOTE_HOST
local function get_lsp_cmd(cmd)
  if REMOTE_HOST then
    return get_remote_mise_node_cmd(REMOTE_HOST, cmd)
  else
    return get_local_mise_node_cmd(cmd)
  end
end

-- ============================================================================
-- SERVER CONFIGURATION
-- ============================================================================

-- Non-Node.js servers (these typically don't need mise)
local servers = {
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
  "bashls",
  "yamlls",

  -- C/C++ development
  "cmake",
  "clangd",
}

-- Setup non-Node.js servers
for _, lsp in ipairs(servers) do
  local cmd = nil

  -- For remote setup, wrap all commands with SSH
  if REMOTE_HOST then
    local ssh_cmd = { "ssh" }
    vim.list_extend(ssh_cmd, SSH_OPTS)
    vim.list_extend(ssh_cmd, { REMOTE_HOST, lsp, "--stdio" })
    cmd = ssh_cmd
  end

  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
    cmd = cmd, -- nil means use default command
  }
end

-- Node.js-based servers that need mise for compatibility
local node_servers = {
  ts_ls = "typescript-language-server",
  cssls = "vscode-css-language-server",
  jsonls = "vscode-json-language-server",
  html = "vscode-html-language-server",
  -- cssmodules_ls = "cssmodules-language-server",
  -- angularls = "@angular/language-server",
}

-- Setup Node.js-based servers
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
    cmd = get_lsp_cmd(cmd_name),
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

-- Prettier LSP for formatting
lspconfig.prettier.setup {
  on_attach = function(client, bufnr)
    nvlsp.on_attach(client, bufnr)
    -- Set Prettier as the primary formatter
    client.server_capabilities.documentFormattingProvider = true
    client.server_capabilities.documentRangeFormattingProvider = true
  end,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = get_lsp_cmd "prettier-language-server",
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "json",
    "jsonc",
    "html",
    "css",
    "scss",
    "less",
    "yaml",
    "markdown",
    "markdown.mdx",
    "graphql",
    "handlebars",
  },
  -- No settings specified - Prettier will use its defaults and respect
  -- project-specific config files (.prettierrc, .prettierrc.json, etc.)
}

-- ============================================================================
-- FILE SYNCHRONIZATION
-- ============================================================================

-- Rsync configuration for automatic file syncing
local SYNC_ENABLED = true -- Set to false to disable auto-sync
local LOCAL_PROJECT_ROOT = vim.fn.getcwd() -- or set specific path
local REMOTE_PROJECT_ROOT = "/home/user/projects/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

-- Setup automatic file synchronization on save
local function setup_auto_sync()
  if not SYNC_ENABLED or not REMOTE_HOST then
    return
  end

  local rsync_group = vim.api.nvim_create_augroup("RemoteLSPSync", { clear = true })

  -- Sync file to remote on save
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = rsync_group,
    pattern = "*",
    callback = function(ev)
      -- Only sync files within project root
      if not vim.startswith(ev.file, LOCAL_PROJECT_ROOT) then
        return
      end

      local relative_path = vim.fn.fnamemodify(ev.file, ":~:.")

      -- Quick sync single file
      local cmd = {
        "rsync",
        "-avz",
        "--relative",
        ev.file,
        REMOTE_HOST .. ":" .. REMOTE_PROJECT_ROOT,
      }

      vim.fn.jobstart(cmd, {
        on_exit = function(_, code)
          if code == 0 then
            vim.notify("✓ Synced to remote", vim.log.levels.INFO, { timeout = 1000 })
          else
            vim.notify("✗ Sync failed", vim.log.levels.ERROR)
          end
        end,
        stderr_buffered = true,
        on_stderr = function(_, data)
          if data and #data > 0 then
            vim.notify("Rsync error: " .. table.concat(data, "\n"), vim.log.levels.ERROR)
          end
        end,
      })
    end,
  })

  -- Command to sync entire project
  vim.api.nvim_create_user_command("SyncProject", function(opts)
    local direction = opts.args or "to"
    local cmd

    if direction == "to" then
      cmd = {
        "rsync",
        "-avz",
        "--delete",
        "--exclude=node_modules",
        "--exclude=.git",
        "--exclude=dist",
        "--exclude=build",
        LOCAL_PROJECT_ROOT .. "/",
        REMOTE_HOST .. ":" .. REMOTE_PROJECT_ROOT,
      }
    else
      cmd = {
        "rsync",
        "-avz",
        "--delete",
        "--exclude=node_modules",
        "--exclude=.git",
        "--exclude=dist",
        "--exclude=build",
        REMOTE_HOST .. ":" .. REMOTE_PROJECT_ROOT .. "/",
        LOCAL_PROJECT_ROOT,
      }
    end

    vim.notify("Syncing project " .. direction .. " remote...", vim.log.levels.INFO)

    vim.fn.jobstart(cmd, {
      on_exit = function(_, code)
        if code == 0 then
          vim.notify("✓ Project synced successfully", vim.log.levels.INFO)
        else
          vim.notify("✗ Project sync failed", vim.log.levels.ERROR)
        end
      end,
      on_stdout = function(_, data)
        if data and #data > 0 then
          print(table.concat(data, "\n"))
        end
      end,
    })
  end, {
    nargs = "?",
    complete = function()
      return { "to", "from" }
    end,
    desc = "Sync project to/from remote server",
  })

  -- Initial sync on startup
  vim.defer_fn(function()
    vim.cmd "SyncProject to"
  end, 100)
end

-- Call this after LSP setup
setup_auto_sync()

-- ============================================================================
-- USAGE INSTRUCTIONS
-- ============================================================================

--[[
HOW TO USE THIS CONFIGURATION:

1. SETUP SSH ACCESS:
   - Ensure you have SSH key authentication set up:
     ssh-keygen -t rsa -b 4096
     ssh-copy-id user@remote-server

2. INSTALL LSP SERVERS ON REMOTE:
   - SSH into your remote server
   - Install mise: https://mise.jdx.dev/
   - Install Node.js via mise: mise use node@latest
   - Install LSP servers:
     npm install -g typescript-language-server
     npm install -g vscode-css-language-server
     npm install -g vscode-html-language-server
     npm install -g @fsouza/prettierd prettier-language-server
     # etc...

3. CONFIGURE REMOTE_HOST:
   - Change REMOTE_HOST at the top of this file to your server
   - Example: "myuser@192.168.1.100" or "dev@my-dev-server"

4. USE THIS CONFIG:
   - Option 1: Replace your lspconfig.lua with this file
   - Option 2: In your init.lua, change:
     require("configs.lspconfig")
     to:
     require("configs.remote-lsp-example")

5. TEST CONNECTION:
   - Open a file that should trigger an LSP (e.g., .js, .ts, .lua)
   - Run :LspInfo to see if the server is running
   - Check :checkhealth for any issues

PERFORMANCE TIPS:
- The SSH ControlMaster options reuse connections for better performance
- First connection might be slow, subsequent ones will be faster
- Consider using a VPN or SSH tunnel for better security
- Mount your project directory on both machines or use rsync

TROUBLESHOOTING:
- If LSP fails to start, check SSH connection: ssh user@remote-server echo "OK"
- Check if LSP is installed: ssh user@remote-server which typescript-language-server
- Look at :LspLog for error messages
- Ensure file paths are accessible from both machines
--]]
