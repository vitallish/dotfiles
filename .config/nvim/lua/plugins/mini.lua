return {
  {
    'nvim-mini/mini.nvim',
    version = false,
    config = function()
      require('mini.surround').setup({
        -- # changing this to semi-colon make whichkey work again
        mappings = {
          add = ';;',
          delete = ';d',
          find = ';f',
          find_left = ';F',
          highlight = ';h',
          replace = 'lr',
          update_n_lines = ';n',
        },
      })

      vim.keymap.set('n', ';"', ';;iw"', { remap = true, desc = 'Surround inner word with "' })

      require('mini.diff').setup({
        -- view = { style = 'sign' },
      })
    end,
  },
}
