-- R.nvim configuration - Updated for latest best practices
-- See: https://github.com/R-nvim/R.nvim
return {
  {
    "R-nvim/R.nvim",
    -- R.nvim is still young; pin to minor version for stability
    -- version = "~0.99.0",
    lazy = true,
    ft = { "r", "rmd", "quarto", "rnoweb", "rhelp" },
    config = function()
      ---@type RConfigUserOpts
      local opts = {
        R_args = { "--quiet", "--no-save" },
        -- Options to use radian
        R_app = "radian",
        R_cmd = "R",
        bracketed_paste = true,
        hook = {
          -- Renamed from after_config to on_filetype in newer versions
          on_filetype = function()
            vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
            vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})
          end,
        },
        min_editor_width = 72,
        rconsole_width = 78,
        -- Object browser mappings - run R commands on objects
        objbr_mappings = {
          c = "class",
          ["<localleader>gg"] = "head({object}, n = 15)",
          v = function()
            require("r.browser").toggle_view()
          end,
        },
        disable_cmds = {
          "RClearConsole",
          "RCustomStart",
          "RSPlot",
          "RSaveClose",
        },
        -- Automatically quit R when you quit Neovim
        auto_quit = false,
      }
      -- Check if the environment variable "R_AUTO_START" exists.
      -- If using fish shell, you could put in your config.fish:
      -- alias r "R_AUTO_START=true nvim"
      if vim.env.R_AUTO_START == "true" then
        opts.auto_start = "on startup"
        opts.objbr_auto_start = true
      end
      require("r").setup(opts)
    end,
  },

  -- NOTE: cmp-r is deprecated. R.nvim now has a built-in language server
  -- for autocompletion. The rnvimserver provides completions directly.
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
    },
    lazy = false,
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = {
            i = cmp.mapping.confirm({ select = true }),
          },
        }),
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = lspkind.cmp_format({
            mode = "symbol",
            maxwidth = 50,
            ellipsis_char = "...",
            before = function(entry, item)
              local menu_icon = {
                nvim_lsp = "",
                vsnip = "",
                path = "",
              }
              item.menu = menu_icon[entry.source.name]
              return item
            end,
          }),
        },
        sources = {
          { name = "nvim_lsp" }, -- R.nvim built-in LSP + other LSPs
          { name = "path", option = { trailing_slash = true } },
        },
      })
    end,
  },

  -- Tree-sitter - Required for R.nvim functionality
  -- Using nvim-treesitter "main" branch (the "master" branch is archived and
  -- incompatible with newer Neovim treesitter core API changes).
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    },
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts_langs = {
        "r",
        "rnoweb",
        "csv",
        "markdown",
        "markdown_inline",
        "bash",
        "yaml",
        "lua",
        "vim",
        "vimdoc",
        "latex",
        "html",
        "css",
        "javascript",
        "mermaid",
      }

      require("nvim-treesitter").install(ts_langs)

      -- Highlighting and (experimental) indent are provided by Neovim core /
      -- nvim-treesitter main branch and must be enabled explicitly per filetype.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = ts_langs,
        callback = function()
          vim.treesitter.start()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })

      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        },
      })

      local select = require("nvim-treesitter-textobjects.select")
      vim.keymap.set({ "x", "o" }, "af", function() select.select_textobject("@function.outer", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "if", function() select.select_textobject("@function.inner", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "ac", function() select.select_textobject("@class.outer", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "ic", function() select.select_textobject("@class.inner", "textobjects") end)

      local move = require("nvim-treesitter-textobjects.move")
      vim.keymap.set({ "n", "x", "o" }, "]m", function() move.goto_next_start("@function.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "]]", function() move.goto_next_start("@class.inner", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "]M", function() move.goto_next_end("@function.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "][", function() move.goto_next_end("@class.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[m", function() move.goto_previous_start("@function.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[[", function() move.goto_previous_start("@class.inner", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[M", function() move.goto_previous_end("@function.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[]", function() move.goto_previous_end("@class.outer", "textobjects") end)
      -- Note: `incremental_selection` (gnn/grn/grc/grm) was dropped from
      -- nvim-treesitter's main-branch rewrite and has no built-in replacement.
    end,
  },

  {
    "eigenfoo/stan-vim",
    lazy = false,
  },

  -- LSP Setup
  -- NOTE: R.nvim has a built-in language server for autocompletion.
  -- The external r_language_server can still be used for diagnostics,
  -- formatting, and other LSP features, but using both for completion
  -- is not recommended. If you want to use r_language_server, you may
  -- need to disable R.nvim's built-in completion.
  {
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    {
      "neovim/nvim-lspconfig",
      config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
          -- Remove r_language_server if using R.nvim's built-in LSP for completion
          -- Or keep it for additional features like diagnostics
          ensure_installed = {},
        })
        -- Uncomment below if you want r_language_server for diagnostics/formatting
        -- Note: Using both r_language_server and R.nvim for completion may cause issues
        -- require("lspconfig").r_language_server.setup({})
      end,
    },
  },
}
