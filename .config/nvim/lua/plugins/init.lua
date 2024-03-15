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
    enabled = false,
    ft = "markdown",
    config = function()
      --   https://github.com/preservim/vim-markdown?tab=readme-ov-file#options
      vim.cmd([[let g:vim_markdown_folding_disabled = 0]])
      vim.cmd([[let g:vim_markdown_folding_level = 2]])
      vim.cmd([[let g:vim_markdown_math = 1]])
    end,

    branch = 'master',
    dependencies = {'godlygeek/tabular'}
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  {
    'stevearc/aerial.nvim',
    opts = {},
    config = function() 
      require("aerial").setup({
        backends = {
          ['_'] = {"treesitter", "lsp"},
          rmd = {"lsp", "treesitter"},
        },
        filter_kind = {
          ['_'] = {"Class",
            "Constructor",
            "Enum",
            "Function",
            "Interface",
            "Module",
            "Method",
            "Struct",
          },
          rmd = false,
        }

      })
      vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle!<CR>")
    end,

  },
  -- Optional dependencies
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons"
  },
  {
    "hedyhli/outline.nvim",
    enabled = false,
    config = function()
      -- Example mapping to toggle outline
      vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>",
        { desc = "Toggle Outline" })

      require("outline").setup {
        -- Your setup opts here (leave empty to use defaults)
      }
    end,
  },
}

