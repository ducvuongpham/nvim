# Gotchas

## Background

Several subtle issues arise from the fact that `nvim` is managed by `mise` rather than installed globally, and from Neovim 0.11's introduction of default `gr*` keymaps that conflict with this config.

## Rules

- `nvim` is managed via `mise` and is NOT on the system PATH by default — subprocesses spawned by Neovim (lazygit `v` to open file, GIT_EDITOR, flatten.nvim) will not find `nvim` unless mise shims are prepended to `vim.env.PATH` at startup (this is done in `options.lua`)
- Neovim 0.11 introduced default `gr*` LSP keymaps (`grr`, `gri`, `gra`, `grn`, `grt`) that conflict with this config's `gr` mappings — these must be deleted with `pcall(vim.keymap.del, ...)` in the `LspAttach` autocmd
- `gopls` (Go LSP) already shares a daemon across Neovim instances automatically — no special config is needed; do not add socket or daemon logic for gopls
- Node-based LSP servers (`ts_ls`, `cssls`, `jsonls`, `html`, `eslint`) cannot be shared across Neovim instances — each instance correctly spawns its own server scoped to its project root
- Running `ts_ls` with bun saves memory, but the TypeScript compiler child process (`tsserver`) spawned inside `ts_ls` is controlled via `init_options.tsserver.maxTsServerMemory`, not by the bun runtime
