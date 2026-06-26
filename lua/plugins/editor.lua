-- lua/plugins/editor.lua
-- Editor enhancement plugins: treesitter, autopairs, surround, comments, etc.

return {
  -- Treesitter (syntax highlighting, indentation, text objects)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
      if not status_ok then
        return
      end

      treesitter.setup({
        -- Install parsers for these languages
        ensure_installed = {
          "typescript",
          "tsx",
          "javascript",
          "python",
          "go",
          "rust",
          "c",
          "cpp",
          "lua",
          "vim",
          "vimdoc",
          "html",
          "css",
          "json",
          "yaml",
          "toml",
          "xml",
          "markdown",
          "markdown_inline",
          "bash",
          "org",
        },
        auto_install = true,  -- Auto-install missing parsers
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
            },
          },
        },
      })
    end,
  },

  -- Autopairs (auto-close brackets, quotes, etc.)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        check_ts = true,  -- Use treesitter
        ts_config = {
          lua = { "string" },
          javascript = { "template_string" },
        },
        disable_filetype = { "TelescopePrompt", "vim" },
        fast_wrap = {},
      })

      -- Integration with nvim-cmp (will be configured later)
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp_status, cmp = pcall(require, "cmp")
      if cmp_status then
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },

  -- Surround (add/change/delete surrounding pairs)
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Default keymaps:
        -- ys{motion}{char} - add surround
        -- cs{old}{new} - change surround
        -- ds{char} - delete surround
        -- Visual mode: S{char} - surround selection
      })
    end,
  },

  -- Comment (toggle comments)
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      require("Comment").setup({
        -- Default keymaps:
        -- gcc - toggle line comment
        -- gbc - toggle block comment
        -- gc{motion} - comment motion
        -- Visual mode: gc - comment selection
        padding = true,
        sticky = true,
        ignore = "^$",  -- Ignore empty lines
        toggler = {
          line = "gcc",
          block = "gbc",
        },
        opleader = {
          line = "gc",
          block = "gb",
        },
        extra = {
          above = "gcO",
          below = "gco",
          eol = "gcA",
        },
        mappings = {
          basic = true,
          extra = true,
        },
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
  },

  -- Context commentstring (for JSX/TSX comments)
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    config = function()
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
      })
    end,
  },

  -- Which-key (show keybindings popup)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({
        preset = "classic",
        delay = 300,
        plugins = {
          marks = true,
          registers = true,
          spelling = { enabled = false },
          presets = {
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true,
          },
        },
        win = {
          border = "rounded",
          padding = { 1, 2 },
        },
        layout = {
          height = { min = 4, max = 25 },
          width = { min = 20, max = 50 },
          spacing = 3,
          align = "left",
        },
        show_help = true,
      })

      -- Register leader key groups (v3 API)
      wk.add({
        { "<leader>e", group = "Explorer" },
        { "<leader>ee", desc = "Toggle file tree" },
        { "<leader>ef", desc = "Focus file tree" },
        { "<leader>ei", desc = "Find file in tree" },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>b", group = "Buffers" },
        { "<leader>l", group = "LSP" },
        { "<leader>d", group = "Debug" },
        { "<leader>w", group = "Windows" },
        { "<leader>x", group = "Trouble" },
        { "<leader>s", group = "Search" },
        { "<leader>o", group = "📝 Org" },
        { "<leader>oa", desc = "Agenda" },
        { "<leader>oc", desc = "Capture" },
        { "<leader>of", desc = "Find headline" },
        { "<leader>or", desc = "Refile target" },
        { "<leader>oj", desc = "Journal (today)" },
        { "<leader>ot", desc = "Todo file" },
        { "<leader>oi", desc = "Inbox file" },
        { "<leader>os", desc = "Scaffold org dir" },
        { "<leader>ok", desc = "Kernel init" },
        { "<leader>oK", desc = "Kernel deinit" },
        { "<leader>ox", desc = "Execute org src block" },
        { "<leader>oX", desc = "Execute selection" },
        { "<leader>ol", desc = "Execute line" },
        { "<leader>oh", desc = "Hide output" },
        { "<leader>on", desc = "Next cell" },
        { "<leader>op", desc = "Prev cell" },
        { "<leader>od", desc = "Delete cell" },
        { "<leader>ob", desc = "Insert src block" },
        { "<leader>oB", desc = "Insert src block (args)" },
        { "<leader>r", group = "Run" },
        { "<leader>rw", desc = "Toggle softwrap" },
        { "<leader>rc", desc = "Run current file" },
        { "<leader>re", desc = "Run shell command" },
        { "<leader>rr", desc = "Run :! command" },
      })
    end,
  },

  -- TODO comments (highlight and search todos)
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({
        signs = true,
        keywords = {
          FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "warning" },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
          TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        },
        highlight = {
          before = "",
          keyword = "wide",
          after = "fg",
          pattern = [[.*<(KEYWORDS)\s*:]],
          comments_only = true,
          max_line_len = 400,
          exclude = {},
        },
      })
    end,
  },

  -- Editorconfig support
  {
    "editorconfig/editorconfig-vim",
    event = "BufReadPre",
  },

  -- Auto-session (save/restore sessions per directory)
  {
    "rmagatti/auto-session",
    lazy = false,
    config = function()
      require("auto-session").setup({
        log_level = "error",
        auto_session_enable_last_session = false,
        auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
        auto_session_enabled = true,
        auto_save_enabled = true,
        auto_restore_enabled = true,
        auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
        auto_session_use_git_branch = false,
        bypass_session_save_file_types = { "alpha", "dashboard" },
      })
    end,
  },
}
