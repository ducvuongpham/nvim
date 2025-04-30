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

-- Override with custom options
return vim.tbl_deep_extend("force", nvchad_opts, {
  on_attach = my_on_attach,
})