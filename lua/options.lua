local o = vim.o

-- Editor
o.laststatus = 3
o.showmode = false
o.clipboard = "unnamedplus"
o.cursorline = true
o.cursorlineopt = "number"

-- Indenting
o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.tabstop = 2
o.softtabstop = 2

-- UI
o.termguicolors = true
o.fillchars = "eob: "
o.ignorecase = true
o.smartcase = true
o.mouse = "a"

-- Line numbers
o.number = true
o.numberwidth = 2
o.relativenumber = false
o.ruler = false

-- Splits
o.splitbelow = true
o.splitright = true

-- Misc
o.shortmess = o.shortmess .. "sI"
o.signcolumn = "yes"
o.timeoutlen = 400
o.undofile = true
o.updatetime = 250
o.scrolloff = 8

-- Session options (required by auto-session for correct filetype/highlight restore)
o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Spell checking
vim.opt.spell = true
vim.opt.spelllang = "en_us,cjk"

-- Colored underline for misspelled words
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, sp = "#ff5555" })
    vim.api.nvim_set_hl(0, "SpellCap", { undercurl = true, sp = "#ffb86c" })
    vim.api.nvim_set_hl(0, "SpellRare", { undercurl = true, sp = "#8be9fd" })
    vim.api.nvim_set_hl(0, "SpellLocal", { undercurl = true, sp = "#50fa7b" })
  end,
})
-- Apply immediately as well
vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, sp = "#ff5555" })
vim.api.nvim_set_hl(0, "SpellCap", { undercurl = true, sp = "#ffb86c" })
vim.api.nvim_set_hl(0, "SpellRare", { undercurl = true, sp = "#8be9fd" })
vim.api.nvim_set_hl(0, "SpellLocal", { undercurl = true, sp = "#50fa7b" })
