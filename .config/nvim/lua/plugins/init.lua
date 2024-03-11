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
          -- make the vertical window seperator white
          vim.cmd([[hi WinSeparator guifg=#ffffff]])
        end
  },
  {
    'godlygeek/tabular', 
    -- Tabularize command is required by vim-markdown
    -- however it doesn't work onless tabular is loaded alread
    -- I think this needs to be done by loading this 
    -- in the config file or something?
     lazy = false
  },
  {
  'preservim/vim-markdown',
  -- for some reason plugin does not automatically load with filetim
  enabled = true,
  ft = "markdown",
  config = function()
	  -- https://github.com/preservim/vim-markdown?tab=readme-ov-file#options
	vim.cmd([[let g:vim_markdown_folding_disabled = 0]])
	vim.cmd([[let g:vim_markdown_folding_level = 2]])
	vim.cmd([[let g:vim_markdown_math = 1]])
	end,

  branch = 'master',
  require = {'godlygeek/tabular'}
},
--{
  --'chrisbra/csv.vim',
  --lazy = false,
  --branch = 'master'}

}

