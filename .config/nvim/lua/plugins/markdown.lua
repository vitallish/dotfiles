return {
  {
    "yousefhadder/markdown-plus.nvim",
    ft = "markdown",
    config = function(_, opts)
      require("markdown-plus").setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(ev)
          -- Convert URL under cursor to [url](url)
          vim.keymap.set("n", "<localleader>lf", function()
            local url = vim.fn.expand("<cWORD>")
            vim.fn.feedkeys("ciW[" .. url .. "](" .. url .. ")\27", "n")
          end, { buffer = ev.buf, desc = "Link full: [url](url)" })

          -- Convert URL under cursor to [](url), cursor between brackets
          vim.keymap.set("n", "<localleader>le", function()
            local url = vim.fn.expand("<cWORD>")
            vim.fn.feedkeys("ciW[](" .. url .. ")\27F[a", "n")
          end, { buffer = ev.buf, desc = "Link empty: [](url)" })
        end,
      })
    end,
  }
}
