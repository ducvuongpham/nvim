return {
  adapters = {
    http = {
      copilot = function()
        return require("codecompanion.adapters").extend("copilot", {
          schema = {
            model = {
              default = "gemini-2.5-pro",
            },
          },
        })
      end,
    },
  },
  display = {
    chat = {
      window = {
        width = 0.3,
        height = 0.3,
        border = "rounded",
        opts = {
          breakindent = true,
          linebreak = true,
          wrap = true,
          signcolumn = "no",
        },
      },
      sidebar = {
        width = 40,
        position = "right",
      },
    },
  },
  strategies = {
    chat = {
      tools = {
        groups = {
          ["full_stack_dev"] = {
            enabled = true,
            -- opts = {
            --   collapse_tools = false,
            -- },
          },
          ["files"] = {
            enabled = true,
            opts = {
              collapse_tools = false,
            },
          },
        },
      },
    },
  },
  tools = {
    -- ["vectorcode"] = {
    --   module = "vectorcode.codecompanion",
    --   description = "VectorCode context retrieval for better AI understanding",
    --   enabled = true,
    -- },
    ["mcp_tools"] = {
      module = "mcphub.codecompanion",
      description = "MCP server tools integration",
      enabled = true,
    },
  },
}
