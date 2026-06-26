-- lua/plugins/lang/go.lua
-- Go-specific plugins: go.nvim

return {
  -- Go.nvim (enhanced Go support)
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
    config = function()
      require("go").setup({
        -- Disable diagnostic virtual text (handled by LSP)
        diagnostic = {
          virtual_text = false,
        },
        -- LSP configuration
        lsp_cfg = true, -- Use go.nvim's LSP config
        lsp_gofumpt = true, -- Use gofumpt for formatting
        lsp_on_attach = function(client, bufnr)
          -- Keybindings for Go-specific features (folded under the LSP group as <leader>lg*
          -- to avoid clashing with the global Git group on <leader>g)
          local opts = { buffer = bufnr, silent = true }
          local ok_wk, wk = pcall(require, "which-key")
          if ok_wk then
            wk.add({ { "<leader>lg", group = "Go", buffer = bufnr } })
          end
          vim.keymap.set("n", "<leader>lgt", "<cmd>GoTest<cr>", vim.tbl_extend("force", opts, { desc = "Go test" }))
          vim.keymap.set("n", "<leader>lgT", "<cmd>GoTestFunc<cr>", vim.tbl_extend("force", opts, { desc = "Go test function" }))
          vim.keymap.set("n", "<leader>lgc", "<cmd>GoCoverage<cr>", vim.tbl_extend("force", opts, { desc = "Go coverage" }))
          vim.keymap.set("n", "<leader>lgi", "<cmd>GoImpl<cr>", vim.tbl_extend("force", opts, { desc = "Go implement interface" }))
          vim.keymap.set("n", "<leader>lgI", "<cmd>GoIfErr<cr>", vim.tbl_extend("force", opts, { desc = "Go add if err" }))
          vim.keymap.set("n", "<leader>lgf", "<cmd>GoFillStruct<cr>", vim.tbl_extend("force", opts, { desc = "Go fill struct" }))
          vim.keymap.set("n", "<leader>lgj", "<cmd>GoAddTag json<cr>", vim.tbl_extend("force", opts, { desc = "Add json tags" }))
          vim.keymap.set("n", "<leader>lgy", "<cmd>GoAddTag yaml<cr>", vim.tbl_extend("force", opts, { desc = "Add yaml tags" }))
        end,
        -- Formatter
        lsp_inlay_hints = {
          enable = true,
        },
        -- DAP (debugger)
        dap_debug = true,
        dap_debug_gui = true,
        -- Test configuration
        test_runner = "go", -- Use go test
        run_in_floaterm = false,
        -- Icons
        icons = {
          breakpoint = "",
          currentpos = "",
        },
        -- Trouble integration
        trouble = true,
        -- Auto format on save
        lsp_document_formatting = true,
      })

      -- Auto-import packages on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          local client = vim.lsp.get_clients({ bufnr = 0, name = "gopls" })[1]
          if not client then
            return
          end
          local encoding = client.offset_encoding or "utf-16"
          -- Organize imports
          local params = vim.lsp.util.make_range_params(0, encoding)
          params.context = { only = { "source.organizeImports" } }
          local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
          for _, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
              if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, encoding)
              elseif r.command then
                client:exec_cmd(r.command)
              end
            end
          end
          -- Format
          vim.lsp.buf.format({ async = false })
        end,
        desc = "Go organize imports and format on save",
      })
    end,
  },

  -- Guihua (required by go.nvim for floating windows)
  {
    "ray-x/guihua.lua",
    build = "cd lua/fzy && make",
    lazy = true,
  },
}
