return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
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
          s = { 
            name = "Scratch", 
            e = { "<cmd>edit ~/Notes/personal/zzz/Scratch.md<cr>", "Open"},
            v = { "<cmd>vsplit ~/Notes/personal/zzz/Scratch.md<cr>", "Open vertical split"},
            h = { "<cmd>split ~/Notes/personal/zzz/Scratch.md<cr>", "Open vertical split"},
          },
        },
      }, { prefix = "<leader>" })
    end, 
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  }
}
