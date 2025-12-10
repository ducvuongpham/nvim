require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

-- Spell checking settings
vim.opt.spell = true
vim.opt.spelllang = "en_us,cjk"

-- -- Enable spell checking for all text (including code identifiers)
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "*",
--   callback = function()
--     vim.opt_local.spelloptions = "camel" -- Check camelCase words separately
--     -- Add @Spell to all syntax items to enable spell checking everywhere
--     vim.cmd "syntax match SpellCheckAll /\\<\\w\\+\\>/ contains=@Spell"
--   end,
-- })

-- Colored underline for misspelled words
-- Apply highlights after colorscheme loads to prevent being overwritten
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, sp = "#ff5555" })
    vim.api.nvim_set_hl(0, "SpellCap", { undercurl = true, sp = "#ffb86c" })
    vim.api.nvim_set_hl(0, "SpellRare", { undercurl = true, sp = "#8be9fd" })
    vim.api.nvim_set_hl(0, "SpellLocal", { undercurl = true, sp = "#50fa7b" })
  end,
})
-- Also apply immediately
vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, sp = "#ff5555" })
vim.api.nvim_set_hl(0, "SpellCap", { undercurl = true, sp = "#ffb86c" })
vim.api.nvim_set_hl(0, "SpellRare", { undercurl = true, sp = "#8be9fd" })
vim.api.nvim_set_hl(0, "SpellLocal", { undercurl = true, sp = "#50fa7b" })
