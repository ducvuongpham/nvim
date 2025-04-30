-- This file serves as the entry point for all plugin configurations
-- It collects all plugin specifications from the subdirectories and returns them as a flat list

-- Local utility function to require plugin modules and flatten them
local function get_plugins(modules)
  local plugins = {}
  for _, module in ipairs(modules) do
    local ok, mod_plugins = pcall(require, "plugins." .. module)
    if ok then
      for _, plugin in ipairs(mod_plugins) do
        table.insert(plugins, plugin)
      end
    else
      vim.notify("Failed to load module: " .. module, vim.log.levels.ERROR)
    end
  end
  return plugins
end

-- List all plugin modules
local plugin_modules = {
  "editor", -- Editor enhancements (treesitter, telescope, etc.)
  "ui", -- UI components (statusline, bufferline, etc.)
  "lsp", -- LSP configurations (nvim-lspconfig, mason, etc.)
  "coding", -- Code related plugins (completion, formatting)
  "git", -- Git related plugins
  "util", -- Utility plugins (sessions, etc.)
}

-- Combine all plugins into a flat list
return get_plugins(plugin_modules)
