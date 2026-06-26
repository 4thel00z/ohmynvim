# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**OhMyNvim** — A modern, lazy-loaded Neovim configuration written entirely in Lua. Targets Neovim 0.10+ with <50ms startup. Uses lazy.nvim for plugin management with ~60 plugins.

## Architecture

Entry point is `init.lua`, which loads four modules in order:

1. `core.options` — Neovim settings (leader=Space, localleader=Comma)
2. `core.keymaps` — Global keybindings
3. `core.autocmds` — Autocommands (hybrid line numbers, yank highlight, filetype indentation, format-on-save)
4. `plugins` — lazy.nvim bootstrap + all plugin specs

### Plugin Organization

All plugins lazy-load by default (`lazy = true`). Specs are split by category under `lua/plugins/`:

| File | Scope |
|------|-------|
| `ui.lua` | Theme (tokyonight-night), statusline, bufferline, dashboard, indent guides |
| `editor.lua` | Treesitter, autopairs, surround, comments, which-key, todo-comments, auto-session |
| `lsp.lua` | Mason, lspconfig, none-ls (formatters/linters), trouble, lsp_signature |
| `completion.lua` | nvim-cmp with LSP, LuaSnip, buffer, path sources |
| `navigation.lua` | Telescope (ripgrep+fd), nvim-tree, toggleterm, glow |
| `debug.lua` | nvim-dap with UI, virtual text; adapters for Python/Rust/Go/JS |
| `orgmode.lua` | nvim-orgmode with bullets (disable: `vim.g.ohmynvim_org_enabled = false`) |
| `notebook.lua` | molten-nvim for Jupyter execution (disable: `vim.g.ohmynvim_notebook_enabled = false`) |
| `lang/rust.lua` | rust-tools.nvim, crates.nvim |
| `lang/go.lua` | go.nvim with gopls, delve |
| `lang/python.lua` | venv-selector.nvim, nvim-dap-python |
| `lang/typescript.lua` | package-info.nvim |

### LSP Setup Pattern

LSP uses Neovim 0.11+ APIs: servers are configured via `vim.lsp.config()` + `vim.lsp.enable()` (not the older `lspconfig[server].setup()` pattern). Keybindings attach via `LspAttach` autocmd. Mason auto-installs servers and formatters.

Installed servers: `lua_ls`, `ts_ls`, `pyright`, `gopls`, `rust_analyzer`, `clangd`, `html`, `cssls`, `jsonls`, `yamlls`.

Formatters via none-ls: `prettier`, `stylua`, `ruff`, `rustfmt`, `gofmt`, `clang_format`.

### Keymap Namespace Conventions

All leader-key groups follow a consistent prefix pattern:

- `<leader>e` Explorer (nvim-tree)
- `<leader>f` Find files (Telescope)
- `<leader>s` Search (Telescope pickers)
- `<leader>g` Git (Telescope)
- `<leader>b` Buffers
- `<leader>l` LSP actions (includes `<leader>lg` Go sub-group and `<leader>lw` Workspace folders)
- `<leader>d` Debug (DAP)
- `<leader>w` Windows/splits
- `<leader>x` Trouble (diagnostics)
- `<leader>t` Terminal (toggleterm)
- `<leader>o` Org-mode
- `<leader>r` Rust
- `<leader>c` Crates (Rust)
- `<leader>v` Venv (Python)
- `<leader>n` Node/package-info (TypeScript)
- `<leader>m` Mason

### Core Module: `lua/core/org.lua`

Manages org directory scaffolding. Resolution order: `$OHMYNVIM_ORG_DIR` → `vim.g.ohmynvim_org_dir` → `~/org`. Provides `:OrgScaffold` and `:OrgDir` commands.

## Conventions

- **Indentation:** 2 spaces for Lua files; the config sets 4-space defaults with autocmd overrides per filetype
- **Plugin specs** use the lazy.nvim table format with `event`, `cmd`, `ft`, or `keys` for lazy-loading triggers
- **All keybindings** include a `desc` field for which-key discoverability
- **Feature escape hatches:** Optional modules (orgmode, notebook) check `vim.g.ohmynvim_*_enabled` globals before loading

## Validation

There is no test suite. To validate changes:

```bash
# Check for Lua syntax errors
nvim --headless -c "lua print('ok')" -c "q"

# Open Neovim and run :checkhealth
nvim +checkhealth

# Verify plugin state
nvim +"Lazy health" +"Lazy sync"

# Check for LSP/Mason status
nvim +"Mason" +"LspInfo"
```
