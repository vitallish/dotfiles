return {
  {
    "junegunn/fzf.vim", 
    lazy = false,
    dependencies = "junegunn/fzf"},
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
          -- load the colorscheme here
          vim.cmd([[colorscheme catppuccin]])
        end
  },
}

