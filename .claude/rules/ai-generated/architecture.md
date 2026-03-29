# Architecture

## Background

This Neovim config runs on Neovim 0.12 and uses the built-in `vim.pack` plugin manager instead of lazy.nvim. Lazy loading is implemented manually via autocmds rather than through a plugin manager's declarative API. All binaries (node, nvim, bun) are managed via `mise`.

## Rules

- This config uses `vim.pack` (Neovim 0.12 built-in), NOT lazy.nvim — never suggest lazy.nvim-specific syntax like `event =`, `keys =`, or `cmd =` in plugin specs
- Lazy loading is done manually with `vim.api.nvim_create_autocmd` and `once = true` in the plugin setup files — follow this pattern when adding new plugins
- All Node.js tooling (including `nvim` itself) is managed via `mise` — the LSP node binary is resolved from `~/.local/share/mise/installs/node/latest/bin/node`
- `ts_ls` (TypeScript language server) runs via `bun` when available, falling back to node with `--max-old-space-size=512` — do not change the runtime without considering this memory cap
- `copilot.lua` (`zbirenbaum/copilot.lua`) is used instead of `github/copilot.vim` — it is loaded lazily on `BufReadPost` and uses the Lua LSP client, not the VimL plugin
- The copilot `workspace_folders` is hardcoded to `~/Program/aircloset/` — this is intentional for the user's primary project
- Semantic tokens are disabled globally (treesitter handles highlighting) via `on_init` in `vim.lsp.config("*", ...)`
- Formatting for `ts_ls`, `cssls`, `jsonls`, and `html` servers is disabled at `LspAttach` — conform/prettier handles formatting
