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

      wk.add(
        {
    { "<leader>f", group = "file" },
    { "<leader>fs", group = "Scratch" },
    { "<leader>fse", "<cmd>edit ~/Notes/personal/zzz/Scratch.md<cr>", desc = "Open" },
    { "<leader>fsh", "<cmd>split ~/Notes/personal/zzz/Scratch.md<cr>", desc = "Open vertical split" },
    { "<leader>fsv", "<cmd>vsplit ~/Notes/personal/zzz/Scratch.md<cr>", desc = "Open vertical split" },
  }



        , { prefix = "<leader>" })
    end, 
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  }
}
