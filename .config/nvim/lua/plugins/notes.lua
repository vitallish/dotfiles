return {
  "epwalsh/obsidian.nvim",
  version = "*",  -- recommended, use latest release instead of latest commit
  lazy = true,
  --ft = "markdown",
  enabled = true,
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
    "nvim-telescope/telescope.nvim", -- For quick pick of files
    -- overwrite anything vimwiki does - just in case
    -- "vimwiki/vimwiki",
    "nvim-treesitter/nvim-treesitter"
  },

  config = function() 
    print("loading obsidian...")
    vim.opt.conceallevel = 2 
    local map = vim.keymap.set

    map("n", "<localleader>os", "<cmd>ObsidianQuickSwitch<cr>", {desc = "QuickSwitch"})

    -- -- run this autocommand here so it's after the vimwiki plugin loads
    -- vim.cmd [[
    --     "augroup vimwiki
    --     "  autocmd!
    --     " I can't do this right now - task manager doesn[t work
    --     "augroup END
    --     augroup vitalyobsidian
    --       autocmd FileType vimwiki set ft=markdown
    --     augroup END
    --   ]]
    --

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
      },
      mappings = {}

    }


    require("obsidian").setup(opts)

  end,
}
