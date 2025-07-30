local options = {
  formatters_by_ft = {
    lua = { "stylua" },

    -- JavaScript/TypeScript
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },

    -- Web technologies
    html = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    less = { "prettier" },

    -- Data formats
    json = { "prettier" },
    jsonc = { "prettier" },
    yaml = { "prettier" },
    yml = { "prettier" },

    -- Documentation
    markdown = { "prettier" },
    mdx = { "prettier" },

    -- Other supported formats
    graphql = { "prettier" },
    handlebars = { "prettier" },
    vue = { "prettier" },
    svelte = { "prettier" },
    astro = { "prettier" },

    -- Additional web formats
    xml = { "prettier" },
    svg = { "prettier" },
  },

  -- Configure prettier
  formatters = {
    prettier = {
      -- Note: Prettier's --range-start/--range-end have known issues
      -- For now, we'll let conform handle range formatting internally
      cwd = require("conform.util").root_file {
        -- Prettier config files
        ".prettierrc",
        ".prettierrc.json",
        ".prettierrc.yml",
        ".prettierrc.yaml",
        ".prettierrc.json5",
        ".prettierrc.js",
        ".prettierrc.cjs",
        ".prettierrc.mjs",
        "prettier.config.js",
        "prettier.config.cjs",
        "prettier.config.mjs",
        "package.json",
      },
    },
  },

  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

return options
