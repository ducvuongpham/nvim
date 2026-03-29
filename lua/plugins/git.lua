-- ── Lazygit ───────────────────────────────────────────────────────────────────
vim.g.lazygit_use_neovim_remote = false
vim.env.GIT_EDITOR = "nvim"
vim.g.lazygit_floating_window_scaling_factor = 0.97
vim.g.lazygit_floating_window_border_chars = { "", "", "", "", "", "", "", "" }

-- ── Inline blame ─────────────────────────────────────────────────────────────
vim.cmd "highlight default link gitblame SpecialComment"
vim.g.gitblame_enabled = 1
vim.g.gitblame_message_template = "             <author> • <date> • <summary>"

-- ── Blame with stack navigation ───────────────────────────────────────────────
require("blame").setup {
  date_format = "%Y-%m-%d",
  merge_consecutive = true,
  commit_detail_view = "vsplit",
}

-- ── Gitsigns ─────────────────────────────────────────────────────────────────
require("gitsigns").setup {
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
    map("v", "<leader>hr", function()
      gs.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
    end, { desc = "Reset hunk" })
    map("n", "<leader>hb", function()
      gs.blame_line { full = true }
    end, { desc = "Blame line (popup)" })
    map("n", "<leader>hB", gs.blame, { desc = "Blame buffer" })
  end,
}
