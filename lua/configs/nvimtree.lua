local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"
  -- Default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- Left click to open node
  vim.keymap.set("n", "<LeftRelease>", function()
    local node = api.tree.get_node_under_cursor()
    if node ~= nil then
      api.node.open.edit()
    end
  end, { buffer = bufnr })

  -- Open in system file manager (Finder on macOS)
  vim.keymap.set("n", "o", function()
    local node = api.tree.get_node_under_cursor()
    if node then
      vim.fn.system('open "' .. node.absolute_path .. '"')
    end
  end, { buffer = bufnr, desc = "Open in Finder" })
end

return {
  on_attach = my_on_attach,
  disable_netrw = true,
  hijack_cursor = true,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  filters = {
    dotfiles = false,
    git_clean = false,
    no_buffer = false,
    custom = { ".DS_Store" },
  },
  git = {
    enable = true,
    ignore = true,
    show_on_dirs = true,
    show_on_open_dirs = true,
    timeout = 400,
  },
  view = {
    width = 30,
    side = "left",
    preserve_window_proportions = false,
  },
  renderer = {
    root_folder_label = false,
    highlight_git = true,
    indent_markers = { enable = true },
    icons = {
      glyphs = {
        default = "󰈚",
        folder = {
          default    = "",
          empty      = "",
          empty_open = "",
          open       = "",
          symlink    = "",
        },
        git = { unmerged = "" },
      },
    },
  },
  actions = {
    open_file = {
      quit_on_open = false,
      resize_window = true,
    },
  },
}
