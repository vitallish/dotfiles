local indent = 2

local opt = vim.opt

opt.number = true

-- https://medium.com/@shaikzahid0713/2bc6b878682
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = indent -- Size of an indent
opt.smartindent = true -- Insert indents automatically
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.tabstop = indent -- Number of spaces tabs count for


-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

vim.g.python3_host_prog = '/Users/vitalydruker/.virtualenvs/nvim/bin/python3'

