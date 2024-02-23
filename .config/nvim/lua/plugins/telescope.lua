return {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
-- or                              , branch = '0.1.x',
      dependencies = { 'nvim-lua/plenary.nvim' },
      lazy = false,
      config = function()
        local wk = require("which-key")
      -- As an example, we will create the following mappings:
      --  * <leader>ff find files
      --  * <leader>fr show recent files
      --  * <leader>fb Foobar
      -- we'll document:
      --  * <leader>fn new file
      --  * <leader>fe edit file
      -- and hide <leader>1

      wk.register({
        f = {
          name = "file", -- optional group name
          f = { "<cmd>Telescope find_files<cr>", "Find File" }, -- create a binding with label
          r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File"}, -- additional options for creating the keymap
          b = { "<cmd>Telescope buffers<cr>", "Select beffers"}, -- additional options for creating the keymap
          --n = { "New File" }, -- just a label. don't create any mapping
          --e = "Edit File", -- same as above
          --["1"] = "which_key_ignore",  -- special label to hide it in the popup
          -- b = { function() print("bar") end, "Foobar" } -- you can also pass functions!
        },
      }, { prefix = "<leader>" })
    end,
    }
