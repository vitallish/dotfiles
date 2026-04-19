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
      { "<leader>fse",  "<cmd>edit ~/notes/personal/zzz/Scratch.md<cr>", desc = "Open"},
      { "<leader>fsv",  "<cmd>vsplit ~/notes/personal/zzz/Scratch.md<cr>", desc = "Open vertical"},
      { "<leader>fsh",  "<cmd>split ~/notes/personal/zzz/Scratch.md<cr>", desc = "Open horizontal"},
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      vim.keymap.set("n", "<C-w><Space>", function()
        wk.show({ keys = "<C-w>", loop = true })
      end, { desc = "Window hydra mode" })
    end,
    opts = {
      notify = false,
    }
  }
}
