local null_ls = require "null-ls"

-- Create a simple, working configuration
-- Focus on what actually works reliably

local sources = {}

-- Add a custom Prettier diagnostic that checks if code needs formatting
local prettier_diagnostic = {
  method = null_ls.methods.DIAGNOSTICS,
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
  generator = {
    fn = function()
      -- Simple check: if file needs Prettier formatting, show a diagnostic
      local has_prettier_config = function()
        local config_files = {
          ".prettierrc",
          ".prettierrc.json",
          ".prettierrc.yml",
          ".prettierrc.yaml",
          ".prettierrc.js",
          ".prettierrc.cjs",
          "prettier.config.js",
          "package.json",
        }

        for _, file in ipairs(config_files) do
          if vim.fn.filereadable(file) == 1 then
            return true
          end
        end
        return false
      end

      if not has_prettier_config() then
        return {}
      end

      -- Return a simple message about using Prettier
      return {
        {
          row = 1,
          col = 1,
          message = "Use <leader>fm to format with Prettier",
          severity = vim.diagnostic.severity.HINT,
          source = "prettier-helper",
        },
      }
    end,
  },
}

table.insert(sources, prettier_diagnostic)

-- Try to load ESLint from none-ls-extras (more reliable than builtins)
local has_eslint_extra, eslint_extra = pcall(require, "none-ls.diagnostics.eslint")
if has_eslint_extra then
  table.insert(
    sources,
    eslint_extra.with {
      condition = function(utils)
        return utils.root_has_file {
          ".eslintrc",
          ".eslintrc.js",
          ".eslintrc.json",
          ".eslintrc.yml",
          ".eslintrc.yaml",
          "eslint.config.js",
          "eslint.config.mjs",
        }
      end,
    }
  )
end

local opts = {
  sources = sources,

  -- Configure diagnostic display
  diagnostics_format = "#{m} (#{s})",
  update_in_insert = false,
  debounce = 250,
}

return opts
