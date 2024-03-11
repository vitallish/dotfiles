return {
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    -- or                              , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    lazy = false,
    config = function()
      local wk = require("which-key")

      wk.register({
        f = {
          name = "file", -- optional group name
          f = { "<cmd>Telescope find_files<cr>", "Find file" }, -- create a binding with label
          r = { "<cmd>Telescope oldfiles<cr>", "Open recent file"}, -- additional options for creating the keymap
        },
        b = {
          name = "buffers",
          b = { "<cmd>Telescope buffers<cr>", "Select buffers"}, -- additional options for creating the keymap
        },
      }, { prefix = "<leader>" })
    end,
  },
  --lazy
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").load_extension "file_browser"
      -- open file_browser with the path of the current buffer
      vim.api.nvim_set_keymap(
        "n",
        "<leader>fb",
        ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
        { noremap = true, desc = "File Browser" }
      )
    end,
  }
}
