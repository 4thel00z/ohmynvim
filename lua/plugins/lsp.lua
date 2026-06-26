-- lua/plugins/lsp.lua
-- LSP configuration: Mason, lspconfig, none-ls, formatters, linters, diagnostics

return {
  -- Mason (LSP/formatter/linter installer)
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>m", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },

  -- Mason-lspconfig (bridge between Mason and lspconfig)
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      -- Must be set up after mason and before lspconfig
      require("mason-lspconfig").setup({
        -- Automatically install these LSP servers
        ensure_installed = {
          "lua_ls",           -- Lua
          "ts_ls",            -- TypeScript/JavaScript
          "pyright",          -- Python
          "gopls",            -- Go
          "rust_analyzer",    -- Rust
          "clangd",           -- C/C++
          "html",             -- HTML
          "cssls",            -- CSS
          "jsonls",           -- JSON
          "yamlls",           -- YAML
        },
        automatic_installation = true,
      })
    end,
  },

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      -- LSP keybindings (set when LSP attaches)
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, silent = true }

        -- Keybinding helper
        local keymap = vim.keymap.set

        -- Navigation
        keymap("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
        keymap("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
        keymap("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
        keymap("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Show references" }))
        keymap("n", "gt", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Go to type definition" }))

        -- Documentation
        keymap("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
        keymap("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))

        -- Code actions
        keymap("n", "<leader>la", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code actions" }))
        keymap("x", "<leader>la", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action (range)" }))
        keymap("n", "<leader>lr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
        keymap("n", "<leader>lf", function() vim.lsp.buf.format({ async = false }) end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))
        keymap("x", "<leader>lf", function()
          local s = vim.api.nvim_buf_get_mark(0, "<")
          local e = vim.api.nvim_buf_get_mark(0, ">")
          vim.lsp.buf.format({
            bufnr = bufnr,
            async = false,
            range = { start = { s[1], s[2] }, ["end"] = { e[1], e[2] } },
          })
        end, vim.tbl_extend("force", opts, { desc = "Format selection" }))

        -- Diagnostics
        keymap("n", "<leader>ld", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Line diagnostics" }))
        keymap("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
        keymap("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
        keymap("n", "<leader>lq", vim.diagnostic.setloclist, vim.tbl_extend("force", opts, { desc = "Diagnostics to loclist" }))
        keymap("n", "<leader>lQ", vim.diagnostic.setqflist, vim.tbl_extend("force", opts, { desc = "Diagnostics to quickfix" }))
        keymap("n", "<leader>lt", function()
          vim.diagnostic.enable(not vim.diagnostic.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
        end, vim.tbl_extend("force", opts, { desc = "Toggle diagnostics" }))

        -- Workspace
        keymap("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, vim.tbl_extend("force", opts, { desc = "Add workspace folder" }))
        keymap("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", opts, { desc = "Remove workspace folder" }))
        keymap("n", "<leader>lwl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, vim.tbl_extend("force", opts, { desc = "List workspace folders" }))

        -- Call hierarchy (results land in the quickfix list)
        keymap("n", "<leader>lI", vim.lsp.buf.incoming_calls, vim.tbl_extend("force", opts, { desc = "Incoming calls" }))
        keymap("n", "<leader>lO", vim.lsp.buf.outgoing_calls, vim.tbl_extend("force", opts, { desc = "Outgoing calls" }))

        -- Inlay hints (toggle per buffer; is_enabled needs the bufnr filter or it reports global state)
        keymap("n", "<leader>lh", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
        end, vim.tbl_extend("force", opts, { desc = "Toggle inlay hints" }))

        -- Code lens (enable auto-refresh + run; only when the server provides it)
        if client and client:supports_method("textDocument/codeLens", bufnr) then
          vim.lsp.codelens.enable(true, { bufnr = bufnr })
          keymap("n", "<leader>lc", vim.lsp.codelens.run, vim.tbl_extend("force", opts, { desc = "Run code lens" }))
        end

        -- which-key: label the Workspace sub-group (buffer-local, only where LSP attaches)
        local ok_wk, wk = pcall(require, "which-key")
        if ok_wk then
          wk.add({ { "<leader>lw", group = "Workspace", buffer = bufnr } })
        end

        -- LSP info
        keymap("n", "<leader>li", "<cmd>LspInfo<cr>", vim.tbl_extend("force", opts, { desc = "LSP info" }))
        keymap("n", "<leader>lR", "<cmd>LspRestart<cr>", vim.tbl_extend("force", opts, { desc = "Restart LSP" }))
      end

      -- Capabilities (for nvim-cmp integration)
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Configure diagnostic display
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          source = "if_many",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      -- Diagnostic signs
      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      -- Configure LSP servers
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                library = {
                  "${3rd}/luv/library",
                  unpack(vim.api.nvim_get_runtime_file("", true)),
                },
              },
              completion = { callSnippet = "Replace" },
              diagnostics = { globals = { "vim" } },
              telemetry = { enable = false },
            },
          },
        },
        ts_ls = {},
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
              gofumpt = true,
            },
          },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = { command = "clippy" },
            },
          },
        },
        clangd = {},
        html = {},
        cssls = {},
        jsonls = {},
        yamlls = {},
      }

      -- Setup LSP servers using the new vim.lsp.config API (Neovim 0.11+)
      for server, config in pairs(servers) do
        config.capabilities = capabilities
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end

      -- Attach keybindings when an LSP client attaches to a buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          on_attach(client, bufnr)
        end,
        desc = "LSP on_attach keybindings",
      })
    end,
  },

  -- None-ls (formatters and linters via LSP)
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        border = "rounded",
        sources = {
          -- Formatters
          null_ls.builtins.formatting.prettier.with({
            filetypes = {
              "javascript",
              "javascriptreact",
              "typescript",
              "typescriptreact",
              "vue",
              "css",
              "scss",
              "less",
              "html",
              "json",
              "jsonc",
              "yaml",
              "markdown",
              "graphql",
            },
          }),
          null_ls.builtins.formatting.ruff,         -- Python
          null_ls.builtins.formatting.rustfmt,      -- Rust
          null_ls.builtins.formatting.gofmt,        -- Go
          null_ls.builtins.formatting.clang_format, -- C/C++
          null_ls.builtins.formatting.stylua,       -- Lua

          -- Linters
          null_ls.builtins.diagnostics.ruff,        -- Python
        },
      })

      -- Auto-format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
        desc = "Auto-format on save",
      })
    end,
  },

  -- Mason-null-ls (automatically install formatters/linters)
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = { "williamboman/mason.nvim", "nvimtools/none-ls.nvim" },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = {
          "prettier",      -- JS/TS/web formatter
          "stylua",        -- Lua formatter
          "ruff",          -- Python formatter/linter
          "rustfmt",       -- Rust formatter
          "gofmt",         -- Go formatter
          "clang_format",  -- C/C++ formatter
        },
        automatic_installation = true,
      })
    end,
  },

  -- LSP signature (show function signatures as you type)
  {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    config = function()
      require("lsp_signature").setup({
        bind = true,
        handler_opts = {
          border = "rounded",
        },
        hint_enable = true,
        hint_prefix = "󰏚 ",
        hi_parameter = "LspSignatureActiveParameter",
      })
    end,
  },

  -- Trouble (diagnostics viewer)
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "Trouble", "TroubleToggle" },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" },
      { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace diagnostics" },
      { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document diagnostics" },
      { "<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "Location list" },
      { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix list" },
      { "gR", "<cmd>TroubleToggle lsp_references<cr>", desc = "LSP references" },
    },
    config = function()
      require("trouble").setup({
        position = "bottom",
        height = 10,
        icons = true,
        mode = "workspace_diagnostics",
        fold_open = "",
        fold_closed = "",
        group = true,
        padding = true,
        action_keys = {
          close = "q",
          cancel = "<esc>",
          refresh = "r",
          jump = { "<cr>", "<tab>" },
          open_split = { "<c-x>" },
          open_vsplit = { "<c-v>" },
          open_tab = { "<c-t>" },
          jump_close = { "o" },
          toggle_mode = "m",
          toggle_preview = "P",
          hover = "K",
          preview = "p",
          close_folds = { "zM", "zm" },
          open_folds = { "zR", "zr" },
          toggle_fold = { "zA", "za" },
          previous = "k",
          next = "j",
        },
        indent_lines = true,
        auto_open = false,
        auto_close = false,
        auto_preview = true,
        auto_fold = false,
        use_diagnostic_signs = true,
      })
    end,
  },
}
