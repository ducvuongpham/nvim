local null_ls = require "null-ls"

local sources = {}

-- Safely check and add Prettier diagnostics
local has_prettier_executable = vim.fn.executable "prettier" == 1
  or vim.fn.filereadable(vim.fn.stdpath "data" .. "/mason/bin/prettier") == 1

-- Check if prettier diagnostic is available in null-ls builtins
local has_prettier_diagnostic = false
if null_ls.builtins and null_ls.builtins.diagnostics and null_ls.builtins.diagnostics.prettier then
  has_prettier_diagnostic = true
end

if has_prettier_executable and has_prettier_diagnostic then
  table.insert(
    sources,
    null_ls.builtins.diagnostics.prettier.with {
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
      diagnostics_format = "#{m} (prettier)",
      runtime_condition = function(params)
        -- Only show diagnostics if the file actually needs formatting
        return true
      end,
    }
  )
elseif has_prettier_executable then
  -- Prettier is available but diagnostic isn't - try alternative approach
  -- Try to use prettier from none-ls-extras if available
  local ok, prettier_extra = pcall(require, "none-ls.diagnostics.prettier")
  if ok then
    table.insert(
      sources,
      prettier_extra.with {
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
        diagnostics_format = "#{m} (prettier)",
      }
    )
  end
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
