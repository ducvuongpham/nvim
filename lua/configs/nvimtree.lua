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
  end, { buffer = bufnr })

  -- Open folder/file in system file manager (Finder on macOS)
  vim.keymap.set("n", "o", function()
    local node = api.tree.get_node_under_cursor()
    if node then
      local path = node.absolute_path
      if node.type == "directory" then
        -- Open folder in Finder
        vim.fn.system('open "' .. path .. '"')
      else
        -- Open file with default application
        vim.fn.system('open "' .. path .. '"')
      end
    end
  end, { buffer = bufnr, desc = "Open in system file manager" })
end

-- Get default options from NvChad
local nvchad_opts = require "nvchad.configs.nvimtree"

-- Override with custom options
return vim.tbl_deep_extend("force", nvchad_opts, {
  on_attach = my_on_attach,
})

