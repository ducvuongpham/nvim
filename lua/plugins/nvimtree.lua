-- NvimTree configuration for NvChad
return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = function()
    local function my_on_attach(bufnr)
      local api = require "nvim-tree.api"
      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- custom mappings
      vim.keymap.set("n", "<LeftRelease>", function()
        local node = api.tree.get_node_under_cursor()
        if node ~= nil then
          api.node.open.edit()
        end
      end, {})
    end

    -- Get default options from NvChad
    local nvchad_opts = require "nvchad.configs.nvimtree"

    -- Override with your custom options
    return vim.tbl_deep_extend("force", nvchad_opts, {
      on_attach = my_on_attach,
    })
  end,
}
