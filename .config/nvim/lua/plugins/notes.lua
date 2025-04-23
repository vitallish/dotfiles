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
    map("n", "<localleader>ov", "<cmd>ObsidianPasteImg<cr>", {desc = "Paste Image"})

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
      new_notes_location = "0. Inbox",
      attachments = {
        -- The default folder to place images in via `:ObsidianPasteImg`.
        -- If this is a relative path it will be interpreted as relative to the vault root.
        -- You can always override this per image by passing a full path to the command instead of just a filename.
        img_folder = "zzz/attachments",  -- This is the default

        -- Optional, customize the default name or prefix when pasting images via `:ObsidianPasteImg`.
        ---@return string
        img_name_func = function()
          -- Prefix image names with timestamp.
          return string.format("%s-", os.time())
        end,

        -- A function that determines the text to insert in the note when pasting an image.
        -- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
        -- This is the default implementation.
        ---@param client obsidian.Client
        ---@param path obsidian.Path the absolute path to the image file
        ---@return string
        img_text_func = function(client, path)
          path = client:vault_relative_path(path) or path
          return string.format("![%s](%s)", path.name, path)
        end,
      },mappings = {}

    }


    require("obsidian").setup(opts)

  end,
}
