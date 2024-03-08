return {
  {
    "R-nvim/R.nvim",
    config = function ()
      -- Create a table with the options to be passed to setup()
      local opts = {
        R_args = {"--quiet", "--no-save"},
        -- Options to use radian
        R_app = "radian",
        R_cmd = "R",
        --R_hl_term = 0,
        bracketed_paste = true,
        -- stop options for radian
        --rconsole_width = 50,
        --min_editor_width = 20,
        hook = {
          after_config = function ()
            -- This function will be called at the FileType event
            -- of files supported by R.nvim. This is an
            -- opportunity to create mappings local to buffers.
            if vim.o.syntax ~= "rbrowser" then
              vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
              vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})
            end
          end
        },
        min_editor_width = 72,
        rconsole_width = 78,
        disable_cmds = {
          "RClearConsole",
          "RCustomStart",
          "RSPlot",
          "RSaveClose",
        },
      }
      -- Check if the environment variable "R_AUTO_START" exists.
      -- If using fish shell, you could put in your config.fish:
      -- alias r "R_AUTO_START=true nvim"
      if vim.env.R_AUTO_START == "true" then
        opts.auto_start = 1
        opts.objbr_auto_start = true
      end
      require("r").setup(opts)
    end,
    lazy = false
  },
  "R-nvim/cmp-r",
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-path",
    },
    lazy = false,
    config = function()
      local cmp = require("cmp")
      local lspkind = require('lspkind')

      cmp.setup {
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = {
            i = cmp.mapping.confirm({ select = true }),
          },
        }),

        formatting = {
          fields = {'abbr', 'kind', 'menu'},
          format = lspkind.cmp_format({
            mode = 'symbol', -- show only symbol annotations
            maxwidth = 50, -- prevent the popup from showing more than provided characters
            ellipsis_char = '...', -- the truncated part when popup menu exceed maxwidth
            before = function(entry, item)
              local menu_icon = {
                nvim_lsp = '',
                vsnip = '',
                path = '',
                --cmp_zotcite = 'z',
                cmp_r = 'R'
              }
              item.menu = menu_icon[entry.source.name]
              return item
            end,
          })


        },
        sources = {
          { name = 'cmp_r' },
          { name = 'path', option = { trailing_slash = true } },
          { name = 'nvim_lsp' },
        }
      }
      require("cmp_r").setup({
        filetypes = {"r", "rmd", "quarto", "rhelp"},
        doc_width = 58
      })


    end

  },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects' },
    },
    lazy = false,
    run = ':TSUpdate',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        auto_install = true,
        ensure_installed = {
          'r',
          'markdown',
          'markdown_inline',
          'bash',
          'yaml',
          'lua',
          'vim',
          'vimdoc',
          'latex',
          'html',
          'css',
          'javascript',
          'mermaid',
        },
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
            init_selection = 'gnn',
            node_incremental = 'grn',
            scope_incremental = 'grc',
            node_decremental = 'grm',
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.inner',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.inner',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
        },
      }
    end,
  },
  {
    "eigenfoo/stan-vim",
    lazy = false,
  }

}
