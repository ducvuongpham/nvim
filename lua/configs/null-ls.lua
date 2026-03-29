local null_ls = require "null-ls"

local sources = {}

-- Add Prettier formatting (not diagnostics - prettier doesn't have diagnostic builtin)
-- Prettier in null-ls only supports formatting, not diagnostics
local has_prettier_executable = vim.fn.executable "prettier" == 1
  or vim.fn.filereadable(vim.fn.stdpath "data" .. "/mason/bin/prettier") == 1

if has_prettier_executable then
  -- Add prettier as a formatter
  table.insert(
    sources,
    null_ls.builtins.formatting.prettier.with {
      prefer_local = "node_modules/.bin",
      condition = function(utils)
        return utils.root_has_file {
          ".prettierrc",
          ".prettierrc.json",
          ".prettierrc.yml",
          ".prettierrc.yaml",
          ".prettierrc.js",
          ".prettierrc.cjs",
          ".prettierrc.mjs",
          "prettier.config.js",
          "prettier.config.cjs",
          "prettier.config.mjs",
          "package.json",
        }
      end,
    }
  )

  -- Create a custom diagnostic source that shows when formatting is needed
  local prettier_diagnostic = {
    method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
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
    generator = null_ls.generator {
      fn = function(params)
        -- Check if file needs formatting by running prettier --check
        local prettier_cmd = vim.fn.executable "prettier" == 1 and "prettier"
          or vim.fn.stdpath "data" .. "/mason/bin/prettier"

        local result = vim.fn.system(prettier_cmd .. " --check " .. vim.fn.shellescape(params.bufname))

        if vim.v.shell_error ~= 0 then
          -- File needs formatting
          return {
            {
              row = 1,
              col = 1,
              message = "File needs prettier formatting (use <leader>fm)",
              severity = vim.diagnostic.severity.HINT,
              source = "prettier",
            },
          }
        end

        return {}
      end,
      on_output = function(params, done)
        return done(params)
      end,
    },
  }

  -- Only add the diagnostic if we have a prettier config
  table.insert(sources, prettier_diagnostic)
end

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
