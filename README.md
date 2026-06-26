<div align="center">

![OhMyNvim Logo](logo.png)

# OhMyNvim

### ✨ A modern, blazing-fast Neovim configuration for polyglot developers ✨

[![Neovim](https://img.shields.io/badge/Neovim-0.10+-green.svg?style=for-the-badge&logo=neovim)](https://neovim.io)
[![Lua](https://img.shields.io/badge/Lua-5.1+-blue.svg?style=for-the-badge&logo=lua)](http://www.lua.org)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)

[Features](#-features) • [Installation](#-installation) • [Keybindings](#-keybindings) • [Languages](#-language-support)

</div>

---

## ✨ Features

<div align="center">

| Category | Features |
|----------|----------|
| 🎨 **Beautiful UI** | Tokyonight theme • Lualine statusline • Bufferline • Alpha dashboard |
| 🔍 **Smart Search** | Telescope fuzzy finder • Live grep • File explorer with git |
| 💡 **IDE Features** | LSP for 10+ languages • Auto-completion • Snippets • Code actions |
| 🐛 **Debugging** | DAP support • Visual debugger • Python, Rust, Go, C/C++, JS/TS |
| ⚡ **Performance** | <50ms startup • Lazy loading • Optimized for speed |
| 🎯 **Syntax** | Treesitter highlighting • Text objects • Auto-indentation |
| 🔧 **Developer Tools** | Auto-formatting • Linting • Git integration • Terminal |

</div>

---

## 📦 Installation

### Prerequisites

Before installing OhMyNvim, ensure you have:

- **Neovim 0.10.0+** (0.12.1 recommended)
  ```bash
  nvim --version
  ```

- **Git**
  ```bash
  git --version
  ```

- **A Nerd Font** (Required for icons)
  - Download from [Nerd Fonts](https://www.nerdfonts.com/)
  - Recommended: **JetBrains Mono Nerd Font**
  - **Important:** Configure your terminal emulator to use the Nerd Font

- **Optional but recommended:**
  - [ripgrep](https://github.com/BurntSushi/ripgrep) - for faster searching
  - [fd](https://github.com/sharkdp/fd) - for faster file finding
  - Node.js - for TypeScript/JavaScript LSP
  - Python 3 - for Python LSP
  - `pynvim` + `jupyter_client` - for molten-nvim code execution (`pip install pynvim jupyter_client`)
  - Bun - for Node.js package management

### Quick Install

```bash
# Backup your existing Neovim configuration
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup

# Clone OhMyNvim
git clone https://github.com/4thel00z/ohmynvim.git ~/.config/nvim

# Start Neovim
nvim
```

**That's it!** 🎉

On first launch:
1. Lazy.nvim will automatically install
2. All plugins will install automatically (be patient, this takes a few minutes)
3. Restart Neovim after installation completes

### Post-Installation

**Install LSP servers and formatters:**
```vim
:Mason
```

LSP servers will also auto-install when you open files of supported types.

**Verify everything is working:**
```vim
:checkhealth
```

**Update plugins anytime:**
```vim
:Lazy sync
```

---

## ⌨️ Keybindings

<div align="center">

### Leader Key: `Space`

</div>

### 📁 Files & Navigation

| Key | Action |
|-----|--------|
| `<leader>ff` | 🔍 Find files |
| `<leader>fg` | 🔎 Live grep (search in files) |
| `<leader>fb` | 📋 List buffers |
| `<leader>fr` | 🕐 Recent files |
| `<leader>ee` | 📂 Toggle file tree |
| `<leader>ef` | 🎯 Focus file tree |
| `<leader>ei` | 📍 Find current file in tree |

### 💡 LSP (Code Intelligence)

| Key | Action |
|-----|--------|
| `gd` | 🎯 Go to definition |
| `gr` | 🔗 Find references |
| `K` | 📖 Hover documentation |
| `<leader>la` | ⚡ Code actions (normal + visual range) |
| `<leader>lr` | ✏️ Rename symbol |
| `<leader>lf` | 🎨 Format buffer (visual: format selection) |
| `<leader>lh` | 💡 Toggle inlay hints |
| `<leader>lc` | 🔎 Run code lens |
| `<leader>lI` / `<leader>lO` | 📞 Incoming / outgoing calls |
| `<leader>lt` | 🚦 Toggle diagnostics |
| `<leader>lq` / `<leader>lQ` | 📋 Diagnostics to loclist / quickfix |
| `[d` / `]d` | ⬆️⬇️ Previous/next diagnostic |

### ✂️ Editing

| Key | Action |
|-----|--------|
| `gcc` | 💬 Toggle line comment |
| `gbc` | 💭 Toggle block comment |
| `<C-s>` | 💾 Save file |
| `<leader>p` | 📋 Paste without yanking |
| `<leader>D` | 🗑️ Delete without yanking |
| `<` / `>` | ⬅️➡️ Indent left/right (visual mode) |
| `J` / `K` | ⬆️⬇️ Move lines up/down (visual mode) |

### 🪟 Windows & Buffers

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | ⬅️⬇️⬆️➡️ Navigate between splits |
| `<leader>wv` | ↔️ Split vertically |
| `<leader>wh` | ↕️ Split horizontally |
| `<leader>bn` / `<leader>bp` | ⬅️➡️ Next/previous buffer |
| `<leader>bd` | ❌ Close buffer |

### 🖥️ Terminal

| Key | Action |
|-----|--------|
| `<leader>tt` | 🔲 Toggle terminal |
| `<leader>tf` | 💫 Floating terminal |
| `<C-\>` | 🔀 Quick toggle (insert mode) |

### 🐛 Debug

| Key | Action |
|-----|--------|
| `<leader>db` | 🔴 Toggle breakpoint |
| `<leader>dc` | ▶️ Continue |
| `<leader>di` | ⤵️ Step into |
| `<leader>do` | ⤴️ Step over |
| `<leader>dt` | 🎛️ Toggle debug UI |

---

## 🌐 Language Support

### Rust 🦀

- Full rust-analyzer integration with inlay hints
- Cargo.toml dependency management
- Clippy linting
- CodeLLDB debugger

**Keybindings:**
- `<leader>rr` - Rust runnables
- `<leader>re` - Expand macro
- `<leader>ct` - Toggle crate info

### Go 🐹

- gopls LSP with auto-imports
- Test integration and coverage
- Struct tag generation
- Delve debugger

**Keybindings** (under the LSP `<leader>lg` Go sub-group):
- `<leader>lgt` - Run tests
- `<leader>lgi` - Implement interface
- `<leader>lgf` - Fill struct
- `<leader>lgj` - Add JSON tags

### Python 🐍

- Pyright LSP with type checking
- Automatic venv detection
- Ruff formatting and linting
- debugpy debugger

**Keybindings:**
- `<leader>vs` - Select virtual environment
- `<leader>dpm` - Debug test method

### TypeScript/JavaScript ⚡

- TypeScript LSP (ts_ls)
- Prettier formatting
- package.json management
- Node debugger

**Keybindings:**
- `<leader>nt` - Toggle package versions
- `<leader>nu` - Update package
- `<leader>ni` - Install package

### Also Supported

- **C/C++** - clangd LSP, clang-format, CodeLLDB
- **Lua** - lua_ls LSP, stylua formatting
- **HTML/CSS** - Language servers and formatters
- **JSON/YAML** - Formatting and validation

---

## 📝 Orgmode

OhMyNvim ships with [`nvim-orgmode`](https://github.com/nvim-orgmode/orgmode) pre-configured:
agenda, capture, TODOs, and journaling live under `<leader>o*`.

### Setup

By default, `~/org/` is used. Override with either:

```bash
export OHMYNVIM_ORG_DIR=~/Documents/org
```

or in your `init.lua` before plugins load:

```lua
vim.g.ohmynvim_org_dir = "~/Documents/org"
```

First time you press `<leader>oa`, OhMyNvim will offer to scaffold three starter files:
`inbox.org`, `todo.org`, `journal.org`.

### Keybindings

| Key | Action |
|-----|--------|
| `<leader>oa` | 📅 Agenda |
| `<leader>oc` | 📥 Capture |
| `<leader>of` | 🔍 Find headline (telescope) |
| `<leader>or` | 📦 Refile target (telescope) |
| `<leader>oj` | 📓 Journal (today's entry) |
| `<leader>ot` | ✅ Todo file |
| `<leader>oi` | 📬 Inbox file |
| `<leader>os` | 🌱 `:OrgScaffold` (idempotent init) |

### Code Execution (molten-nvim)

OhMyNvim includes [`molten-nvim`](https://github.com/benlubas/molten-nvim) for running
code blocks inside `.org` files (and any other buffer) via Jupyter kernels.

**Prerequisite:** `pip install pynvim jupyter_client`

| Key | Action |
|-----|--------|
| `<leader>ok` | 🔌 Kernel init |
| `<leader>oK` | ⏏️ Kernel deinit |
| `<leader>ox` | ▶️ Execute org source block |
| `<leader>oX` | ▶️ Execute visual selection |
| `<leader>ol` | ▶️ Execute line |
| `<leader>oh` | 🙈 Hide output |
| `<leader>on` | ⏭️ Next cell |
| `<leader>op` | ⏮️ Prev cell |
| `<leader>od` | 🗑️ Delete cell |

Disable with `vim.g.ohmynvim_notebook_enabled = false`.

### Configuration

```lua
-- All optional; set before plugins load
vim.g.ohmynvim_org_dir = "~/org"
vim.g.ohmynvim_org_agenda_files = nil  -- nil = glob org_dir/**/*.org
vim.g.ohmynvim_org_todo_keywords = { "TODO(t)", "NEXT(n)", "WAITING(w)", "|", "DONE(d)", "CANCELLED(c)" }
vim.g.ohmynvim_org_capture_templates = nil  -- nil = use defaults
vim.g.ohmynvim_org_bullets = { "◉", "○", "✸", "✿" }
vim.g.ohmynvim_org_enabled = true  -- escape hatch to disable entire module
```

---

## 📦 Included Plugins

<details>
<summary><strong>UI & Appearance</strong></summary>

- [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) - Beautiful night theme
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) - Statusline
- [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) - Buffer/tab line
- [alpha-nvim](https://github.com/goolord/alpha-nvim) - Dashboard
- [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) - Indent guides
- [nvim-colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua) - Color highlighting
- [neoscroll.nvim](https://github.com/karb94/neoscroll.nvim) - Smooth scrolling

</details>

<details>
<summary><strong>Editor Enhancement</strong></summary>

- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Syntax highlighting
- [nvim-autopairs](https://github.com/windwp/nvim-autopairs) - Auto-close brackets
- [nvim-surround](https://github.com/kylechui/nvim-surround) - Surround text objects
- [Comment.nvim](https://github.com/numToStr/Comment.nvim) - Toggle comments
- [which-key.nvim](https://github.com/folke/which-key.nvim) - Keybinding hints
- [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) - Highlight TODOs
- [auto-session](https://github.com/rmagatti/auto-session) - Session management
- [molten-nvim](https://github.com/benlubas/molten-nvim) - Jupyter code execution
- [image.nvim](https://github.com/3rd/image.nvim) - Inline image rendering (kitty/WezTerm)

</details>

<details>
<summary><strong>LSP & Completion</strong></summary>

- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP configurations
- [mason.nvim](https://github.com/williamboman/mason.nvim) - LSP installer
- [none-ls.nvim](https://github.com/nvimtools/none-ls.nvim) - Formatters & linters
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - Completion engine
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip) - Snippet engine
- [trouble.nvim](https://github.com/folke/trouble.nvim) - Diagnostics viewer

</details>

<details>
<summary><strong>Navigation</strong></summary>

- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finder
- [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) - File explorer
- [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) - Terminal
- [glow.nvim](https://github.com/ellisonleao/glow.nvim) - Markdown preview

</details>

<details>
<summary><strong>Debug</strong></summary>

- [nvim-dap](https://github.com/mfussenegger/nvim-dap) - Debug adapter protocol
- [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) - Debug UI
- [nvim-dap-virtual-text](https://github.com/theHamsta/nvim-dap-virtual-text) - Inline debug info

</details>

---

## 🎨 Customization

### Change Theme

Edit `lua/plugins/ui.lua`:

```lua
style = "night",  -- Options: night, storm, moon, day
```

### Add LSP Server

Edit `lua/plugins/lsp.lua`:

```lua
ensure_installed = {
  "lua_ls",
  "your_lsp_here",
}
```

### Modify Keybindings

- **Global:** Edit `lua/core/keymaps.lua`
- **Plugin-specific:** Edit respective plugin files in `lua/plugins/`

---

## 🗂️ Project Structure

```
~/.config/nvim/
├── init.lua                 # Entry point
├── lua/
│   ├── core/                # Core configuration
│   │   ├── options.lua      # Neovim options
│   │   ├── keymaps.lua      # Global keybindings
│   │   └── autocmds.lua     # Autocommands
│   └── plugins/             # Plugin configurations
│       ├── init.lua         # Lazy.nvim bootstrap
│       ├── ui.lua           # UI plugins
│       ├── editor.lua       # Editor enhancements
│       ├── lsp.lua          # LSP configuration
│       ├── completion.lua   # Completion engine
│       ├── navigation.lua   # Navigation tools
│       ├── debug.lua        # Debug adapters
│       ├── orgmode.lua      # Orgmode integration
│       ├── notebook.lua     # Jupyter code execution (molten-nvim)
│       └── lang/            # Language-specific
│           ├── rust.lua
│           ├── go.lua
│           ├── python.lua
│           └── typescript.lua
└── docs/                    # Documentation
```

---

## 🐛 Troubleshooting

### Icons not displaying
- Install a Nerd Font from [nerdfonts.com](https://www.nerdfonts.com/)
- Configure your terminal to use the Nerd Font

### LSP not starting
- Run `:Mason` and check if language server is installed
- Run `:LspInfo` to see LSP status
- Check `:checkhealth` for issues

### Slow startup
- Run `:Lazy profile` to identify slow plugins
- Disable unused language-specific plugins

### Formatter not working
- Ensure formatter is installed via `:Mason`
- Check `:LspInfo` for active formatters

---

## 📝 Contributing

Contributions are welcome! Feel free to:

- 🐛 Report bugs
- 💡 Suggest features
- 🔧 Submit pull requests

---

## 📄 License

MIT License - feel free to use and modify!

---

<div align="center">

### 💙 Built with Love using Neovim

**[⬆ Back to Top](#ohmynvim)**

</div>
