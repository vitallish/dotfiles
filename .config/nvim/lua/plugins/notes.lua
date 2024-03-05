return {
  "epwalsh/obsidian.nvim",
  version = "*",  -- recommended, use latest release instead of latest commit
  lazy = true,
  --ft = "markdown",
   event = {
     -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
     -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
     "BufReadPre " .. vim.fn.expand "~" .. "/Notes/personal/**.md",
     "BufNewFile " .. vim.fn.expand "~" .. "/Notes/personal/**.md",
   },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp", -- for completion of note references
    "nvim-telescope/telescope.nvim" -- For quick pick of files

  },

  config = function() 
    vim.opt.conceallevel = 2 
    local wk = require("which-key")
    wk.register({
      o = {
        name = "obsidian",
        s = { "<cmd>ObsidianQuickSwitch<cr>", "QuickSwitch"},
      }
    }, { 
      prefix = "<localleader>"
  })

    -- do this here instead of as described in documentation
    -- this allows for more flexibility during configuration I think?
    -- If I didn't include it here, the the plugin didn't load correctly
    -- For example, the plugin commands didn't load - i dunno
    local opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/Notes/personal",
        },
      },
      daily_notes = {
        folder = "daily",
        template = "Daily Template.md",
      },
      templates = {
        subdir = "templates",
      }

    }


    require("obsidian").setup(opts)

  end,
}
