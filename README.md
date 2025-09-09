# Neovim Configuration

A modern Neovim configuration built on top of [NvChad](https://nvchad.com/) with enhanced AI coding assistance, LSP support, and developer productivity features.

## ✨ Features

### AI-Powered Development

- **GitHub Copilot** - AI code completion and suggestions
- **CodeCompanion** - Advanced AI programming assistant with multi-model support
- **Claude Code** - Direct Claude integration for AI assistance

### Language Server Protocol (LSP)

- **Mason** - LSP server management with auto-installation
- **nvim-lspconfig** - Comprehensive LSP configurations
- **nvim-navbuddy** - Visual LSP symbol navigation
- **DAP** - Debug Adapter Protocol support with UI

### Editor Enhancements

- **Telescope** - Fuzzy finder with FZF native integration
- **Treesitter** - Advanced syntax highlighting and text objects
- **Treesitter Context** - Show function/class context at top of screen
- **Rainbow Delimiters** - Colorized bracket pairs
- **Zen Mode** - Distraction-free writing environment
- **Conform.nvim** - Code formatting with multiple formatter support

### Developer Productivity

- **Auto-session** - Automatic session management with git branch support
- **NvimTree** - File explorer with custom click handling
- **Early Retirement** - Smart buffer management
- **Flatten** - Better handling of nested Neovim instances
- **Clever-f** - Enhanced f/F motions
- **Prompt Tower** - Project context generation for AI tools
- **Tiny Inline Diagnostic** - Beautiful inline diagnostic display with git blame compatibility

## 🚀 Installation

### Prerequisites

1. **Neovim** (>= 0.11.0)

   ```bash
   # macOS
   brew install neovim

   # Ubuntu/Debian
   sudo apt install neovim

   # Arch Linux
   sudo pacman -S neovim
   ```

2. **mise** - Runtime version manager (recommended over manual installations)

   ```bash
   # Install mise
   curl https://mise.run | sh

   # Install required runtimes
   mise use -g node@latest
   mise use -g python@latest
   ```

3. **tmux** - Terminal multiplexer for split-pane workflows

   ```bash
   # macOS
   brew install tmux

   # Ubuntu/Debian
   sudo apt install tmux

   # Arch Linux
   sudo pacman -S tmux
   ```

4. **Claude CLI** - For AI assistance alongside Neovim

   ```bash
   # Install Claude CLI
   npm install -g @anthropic-ai/claude-cli
   # or via pip
   pip install claude-cli
   ```

5. **Git** for plugin management
6. **A Nerd Font** for icons (recommended: JetBrainsMono Nerd Font)

### Setup

1. **Backup existing config** (if any):

   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone this configuration**:

   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```

3. **Install dependencies**:

   ```bash
   # Open Neovim - plugins will auto-install
   nvim
   ```

4. **Install LSP servers and tools**:

   ```bash
   # In Neovim command mode - install all configured LSP servers/tools
   :MasonInstallAll

   # Or install individually
   :Mason
   # Then select and install: typescript-language-server, eslint-lsp, prettier, etc.
   ```

5. **Setup GitHub Copilot** (optional):
   ```bash
   # In Neovim command mode
   :Copilot setup
   ```

## 🔧 Configuration Structure

```
├── init.lua                 # Entry point - bootstraps Lazy.nvim and loads configs
├── lua/
│   ├── chadrc.lua          # NvChad configuration (theme: ayu_dark)
│   ├── options.lua         # Vim options and settings
│   ├── mappings.lua        # Custom keymaps and shortcuts
│   ├── configs/            # Plugin-specific configurations
│   │   ├── cmp.lua         # Completion with Copilot integration
│   │   ├── codecompanion.lua # AI assistant configuration
│   │   ├── conform.lua     # Code formatting settings
│   │   ├── lspconfig.lua   # LSP server configurations
│   │   └── ...
│   └── plugins/            # Plugin specifications
│       ├── init.lua        # Plugin loader and organization
│       ├── coding.lua      # AI and completion plugins
│       ├── editor.lua      # Editor enhancement plugins
│       ├── lsp.lua         # LSP and debugging plugins
│       ├── ui.lua          # UI and visual plugins
│       └── util.lua        # Utility plugins
```

## ⌨️ Key Mappings

### Basic Operations

| Key     | Action           | Mode                 |
| ------- | ---------------- | -------------------- |
| `jk`    | Exit insert mode | Insert               |
| `;`     | Command mode     | Normal               |
| `<C-s>` | Save file        | Normal/Insert/Visual |
| `gr`    | Go to references | Normal               |

### File Operations

| Key          | Action             |
| ------------ | ------------------ |
| `<leader>ff` | Find files         |
| `<leader>fg` | Live grep          |
| `<leader>fr` | Resume last search |
| `<leader>ox` | Open in VSCode     |

### Code Formatting

| Key          | Action                | Mode          |
| ------------ | --------------------- | ------------- |
| `<leader>fm` | Format file/selection | Normal/Visual |
| `<leader>fh` | Format git hunks      | Normal        |

### AI & Completion

| Key     | Action                                  | Mode   |
| ------- | --------------------------------------- | ------ |
| `<Tab>` | Accept Copilot suggestion (prioritized) | Insert |
| `<C-V>` | Accept Copilot word                     | Insert |

### Session Management

| Key          | Action          |
| ------------ | --------------- |
| `<leader>fs` | Search sessions |
| `<leader>ws` | Save session    |
| `<leader>wr` | Restore session |
| `<leader>wd` | Delete session  |

## 🚀 Recommended Workflow

### tmux + Claude CLI + Neovim Setup

This configuration is optimized for a split-screen workflow using tmux with Neovim and Claude CLI running side by side:

```bash
# Start a new tmux session
tmux new-session -d -s coding

# Split window vertically (Neovim on left, Claude CLI on right)
tmux split-window -h

# Start Neovim in the left pane
tmux send-keys -t coding:0.0 'nvim' Enter

# Start Claude CLI in the right pane
tmux send-keys -t coding:0.1 'claude' Enter

# Attach to the session
tmux attach -t coding
```

### Optimal Pane Layout

```
┌─────────────────────┬─────────────────────┐
│                     │                     │
│                     │    Claude CLI       │
│      Neovim         │                     │
│                     │  - AI assistance    │
│  - Code editing     │  - Code review      │
│  - File navigation  │  - Debugging help   │
│  - LSP features     │  - Architecture     │
│                     │    discussions      │
│                     │                     │
└─────────────────────┴─────────────────────┘
```

### tmux Key Bindings for Seamless Workflow

```bash
# Switch between panes
Ctrl-b + Arrow Keys    # Navigate between Neovim and Claude CLI

# Resize panes
Ctrl-b + Ctrl-Arrow   # Resize panes dynamically

# Copy mode for sharing context
Ctrl-b + [            # Enter copy mode to select and copy text
```

### Integration Benefits

- **Context Sharing**: Copy code snippets from Neovim to discuss with Claude CLI
- **Real-time Assistance**: Get AI help while coding without leaving terminal
- **Architecture Planning**: Use Claude CLI for high-level design discussions
- **Code Review**: Paste code blocks into Claude for review and suggestions
- **Debugging Help**: Share error messages and stack traces with Claude

## 🛠️ Customization

### Theme

Edit `lua/chadrc.lua` to change the colorscheme:

```lua
M.base46 = {
  theme = "your_theme_name", -- Try: onedark, catppuccin, etc.
}
```

### Plugin Configuration

- Add new plugins in `lua/plugins/*.lua` files
- Plugin-specific configs go in `lua/configs/`
- Custom keymaps in `lua/mappings.lua`

### LSP Servers

Configure additional LSP servers in `lua/configs/lspconfig.lua` and add them to Mason's `ensure_installed` list in `lua/plugins/lsp.lua`.

**Current Mason Configuration** (`lua/plugins/lsp.lua`):

```lua
opts = {
  ensure_installed = {
    "eslint-lsp",
    "prettier",
    "js-debug-adapter",
    "typescript-language-server",
    "html-lsp",
    "css-lsp",
  },
}
```

**Adding New Tools**:

1. Add tool name to `ensure_installed` list
2. Run `:MasonInstallAll` to install all configured tools
3. Configure the LSP server in `lua/configs/lspconfig.lua` if needed

### mise Integration

This config works seamlessly with mise-managed runtimes. The configuration automatically detects mise-installed tools:

```bash
# Set up project-specific runtimes
echo "node 20.0.0" > .mise.toml
echo "python 3.11.0" >> .mise.toml
mise install

# Neovim will automatically use mise-managed runtimes for:
# - LSP servers (TypeScript, Python, etc.)
# - Formatters (Prettier, Black, etc.)
# - Linters (ESLint, Ruff, etc.)
```

The Copilot configuration in `lua/plugins/coding.lua` is already configured to use the mise-managed Node.js installation:

```lua
vim.g.copilot_node_command = "~/.local/share/mise/installs/node/latest/bin/node"
```

## 🧩 Plugin Highlights

### CodeCompanion

Advanced AI programming assistant supporting multiple models:

- Copilot integration with Gemini 2.5 Pro
- File context tools
- Full-stack development tools
- MCP server integration

### Auto-Session

Intelligent session management:

- Git branch-based sessions
- Auto-save/restore
- Directory-specific sessions
- Integration with file explorers

### Conform.nvim

Multi-formatter support with intelligent formatting:

- Git hunk formatting
- Range formatting for selections
- LSP fallback support
- Format-on-save (configurable)

### Tiny Inline Diagnostic

Enhanced diagnostic display with git blame compatibility:

- ✨ **Modern inline diagnostics** - Beautiful diagnostic messages displayed inline next to code
- 🎨 **Multiple visual presets** - Choose from "modern", "classic", "minimal", "ghost", or "simple" styles
- 🔍 **Smart positioning** - Diagnostics wrap to avoid conflicts with git blame
- 📱 **Responsive design** - Messages wrap intelligently based on length and screen space
- 🎯 **Severity-based styling** - Different colors and icons for errors, warnings, info, and hints
- ⚡ **Performance optimized** - Throttled updates to prevent lag while typing
- 🚫 **Insert mode filtering** - Diagnostics hidden while actively typing for distraction-free coding
- 🔄 **Git blame compatibility** - Transparent background and lower priority ensures both work together

## 🐛 Troubleshooting

### Common Issues

1. **Plugins not loading**:

   ```bash
   # Reset and reinstall
   rm -rf ~/.local/share/nvim
   nvim --headless "+Lazy! sync" +qa
   ```

2. **LSP servers not working**:

   ```bash
   # Check Mason installations
   :Mason
   # Or reinstall specific server
   :MasonInstall typescript-language-server
   ```

3. **Copilot not working**:
   ```bash
   # Re-authenticate
   :Copilot auth
   ```

### Log Files

- Neovim logs: `~/.local/share/nvim/log/`
- Lazy plugin manager: `:Lazy` then `L` for logs

## 🤝 Contributing

Feel free to fork this configuration and make it your own! If you find bugs or have improvements, please open an issue or pull request.

## 📄 License

This configuration is provided as-is under the MIT License. Individual plugins maintain their own licenses.

---

**Note**: This configuration is optimized for development workflows with heavy AI assistance. Adjust plugin configurations in `lua/configs/` to match your preferences.
