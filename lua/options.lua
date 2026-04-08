local o = vim.o
local opt = vim.opt
local g = vim.g

-- Editor
o.laststatus = 3
o.showmode = false
o.clipboard = "unnamedplus"
o.cursorline = true
o.cursorlineopt = "number"
o.splitkeep = "screen"

-- Indenting
o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.tabstop = 2
o.softtabstop = 2

-- UI
o.termguicolors = true
-- opt.fillchars = { eob = " ", foldopen = "▾", foldclose = "▸", foldsep = "│", fold = " " }
opt.fillchars = "eob: ,fold: ,foldopen:,foldsep: ,foldinner: ,foldclose:"
-- opt.fillchars = 'eob: ,fold: ,foldopen:▾,foldsep: ,foldinner: ,foldclose:▸'
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

-- Folding (nvim-ufo: VSCode-like)
o.foldcolumn = "1"
o.foldlevel = 99 -- start with everything open
o.foldlevelstart = 99
o.foldenable = true

-- Misc
opt.shortmess:append "sI"
o.signcolumn = "yes"
o.timeoutlen = 400
o.undofile = true
o.updatetime = 250
o.scrolloff = 8

-- Allow h/l and arrow keys to wrap across lines
opt.whichwrap:append "<>[]hl"

-- Disable unused providers (speeds up startup)
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- Add mise shims + mason/bin to PATH so subprocesses (lazygit, GIT_EDITOR,
-- flatten.nvim, etc.) can find mise-managed binaries like nvim itself.
local sep   = vim.fn.has "win32" ~= 0 and "\\" or "/"
local delim = vim.fn.has "win32" ~= 0 and ";" or ":"
local mise_shims = vim.fn.expand "~/.local/share/mise/shims"
local node_bin   = vim.fn.expand "~/.local/share/mise/installs/node/latest/bin"
local mason_bin  = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep)
-- node_bin before mise_shims: the npm/node shims are a broken circular symlink (ELOOP)
vim.env.PATH = node_bin .. delim .. mise_shims .. delim .. mason_bin .. delim .. vim.env.PATH

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
