-- https://medium.com/@shaikzahid0713/keyboard-shortcuts-in-neovim-d04cd7f551a7
local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = "\\"
vim.g.maplocalleader = " "


-- navigate buffers
-- This should just go into which key somehow as well?
keymap("n", "<tab>", ":bnext<cr>", opts) -- Next Tab
keymap("n", "<s-tab>", ":bprevious<cr>", opts) -- Previous tab

-- buffer management
vim.keymap.set("n", "<leader>bd", ":bdelete<cr>", { noremap = true, silent = true, desc = "Close buffer" })
vim.keymap.set("n", "<leader>bD", function()
  local buf = vim.api.nvim_get_current_buf()
  pcall(vim.cmd, "close")
  pcall(vim.api.nvim_buf_delete, buf, {})
end, { noremap = true, silent = true, desc = "Close buffer and window" })
vim.keymap.set("n", "<leader>bo", ":%bdelete|edit#|bdelete#<cr>", { noremap = true, silent = true, desc = "Close other buffers" })

-- Insert current date
local function insert_date()
  local date = os.date("%Y-%m-%d")
  vim.api.nvim_put({ date }, "c", true, true)
end
vim.keymap.set("n", "@@", insert_date, { noremap = true, silent = true, desc = "Insert current date" })
vim.keymap.set("i", "@@", function()
  insert_date()
  vim.cmd("startinsert!")
end, { noremap = true, silent = true, desc = "Insert current date" })
