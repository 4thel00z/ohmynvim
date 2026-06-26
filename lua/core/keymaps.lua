-- lua/core/keymaps.lua
-- Global keybindings
-- Plugin-specific keybindings are defined in their respective plugin specs

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Clear search highlighting with Esc in normal mode
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- Better window navigation (Ctrl+hjkl to move between splits)
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Window management
keymap("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
keymap("n", "<leader>wh", "<C-w>s", { desc = "Split window horizontally" })
keymap("n", "<leader>wq", "<C-w>q", { desc = "Close window" })
keymap("n", "<leader>wo", "<C-w>o", { desc = "Close other windows" })

-- Buffer navigation
keymap("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Quit
keymap("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", "<cmd>quitall<CR>", { desc = "Quit all" })

-- Save
keymap("n", "<C-s>", "<cmd>write<CR>", opts)
keymap("i", "<C-s>", "<Esc><cmd>write<CR>", opts)

-- Better indenting (stay in visual mode)
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down in visual mode
keymap("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Keep cursor centered when jumping
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

-- Paste without yanking replaced text
keymap("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })

-- Delete without yanking (on <leader>D so <leader>d stays the Debug prefix)
keymap("n", "<leader>D", '"_d', { desc = "Delete without yanking" })
keymap("v", "<leader>D", '"_d', { desc = "Delete without yanking" })

-- Run group (<leader>r)
-- Softwrap toggle
keymap("n", "<leader>rw", function()
  vim.wo.wrap = not vim.wo.wrap
  vim.wo.linebreak = vim.wo.wrap
  vim.wo.breakindent = vim.wo.wrap
  vim.notify("Softwrap " .. (vim.wo.wrap and "ON" or "OFF"))
end, { desc = "Toggle softwrap" })

-- Run current file
keymap("n", "<leader>rc", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("No file", vim.log.levels.WARN)
    return
  end
  local runners = {
    python = function()
      local ok, venv = pcall(require, "venv-selector")
      local python = ok and venv.python() or "python3"
      if not python or python == "" then python = "python3" end
      return python .. " " .. file:gsub('"', '\\"')
    end,
    lua = function() return "lua " .. file:gsub('"', '\\"') end,
    javascript = function() return "node " .. file:gsub('"', '\\"') end,
    typescript = function() return "npx tsx " .. file:gsub('"', '\\"') end,
    sh = function() return "bash " .. file:gsub('"', '\\"') end,
    bash = function() return "bash " .. file:gsub('"', '\\"') end,
    zsh = function() return "zsh " .. file:gsub('"', '\\"') end,
    go = function() return "go run " .. file:gsub('"', '\\"') end,
    rust = function() return "cargo run" end,
  }
  local ft = vim.bo.filetype
  local runner = runners[ft]
  if not runner then
    vim.notify("No runner for filetype: " .. ft, vim.log.levels.WARN)
    return
  end
  vim.cmd('TermExec cmd="' .. runner() .. '"')
end, { desc = "Run current file" })

-- Arbitrary shell command (uses toggleterm's TermExec)
keymap("n", "<leader>re", function()
  vim.ui.input({ prompt = "Shell command: " }, function(cmd)
    if not cmd or cmd == "" then return end
    vim.cmd('TermExec cmd="' .. cmd:gsub('"', '\\"') .. '"')
  end)
end, { desc = "Run shell command" })

-- Bang command runner (`:!<subcmd>`, output in cmdline)
keymap("n", "<leader>rr", function()
  vim.ui.input({ prompt = ":! " }, function(cmd)
    if not cmd or cmd == "" then return end
    vim.cmd("! " .. cmd)
  end)
end, { desc = "Run :! command" })


-- Plugin-specific keymaps are defined in their plugin specs:
-- - Telescope: <leader>f, <leader>g, <leader>b, <leader>s*
-- - nvim-tree: <leader>e
-- - toggleterm: <leader>t
-- - LSP: <leader>l*, gd, gr, K
-- - Debug: <leader>d*
-- - Trouble: <leader>x*
-- - Glow: <leader>mp
-- - Run: <leader>r*
