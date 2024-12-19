return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    keys = {
      { "<leader>f", group = "file" },
      { "<leader>fs", group = "scratch" },
      { "<leader>fse",  "<cmd>edit ~/Notes/personal/zzz/Scratch.md<cr>", desc = "Open"},
      { "<leader>fsv",  "<cmd>vsplit ~/Notes/personal/zzz/Scratch.md<cr>", desc = "Open vertical"},
      { "<leader>fsh",  "<cmd>split ~/Notes/personal/zzz/Scratch.md<cr>", desc = "Open horizontal"},
    },
    opts = {
      notify = false,
    }
  }
}
