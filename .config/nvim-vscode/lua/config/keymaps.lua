-- https://medium.com/@shaikzahid0713/keyboard-shortcuts-in-neovim-d04cd7f551a7
print("loading keymaps...")
print("VSCODE Variable is:", vim.g.vscode)
local opts = {
    noremap = true,
    silent = true
}

local term_opts = {
    silent = true
}

-- Shorten function name
local keymap = vim.keymap.set
-- Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = "\\"
vim.g.maplocalleader = " "

if vim.g.vscode then
    print("loading vscode stuff")
    local vscode = require('vscode-neovim')

    keymap({"n", "v"}, "<CR>", function()
        vscode.action('r.runSelection')
    end, opts)

else

    print("not loading vscode stuff")
    -- navigate buffers
    keymap("n", "<tab>", ":bnext<cr>", opts) -- Next Tab 
    keymap("n", "<s-tab>", ":bprevious<cr>", opts) -- Previous tab

end
