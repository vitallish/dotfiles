local term_group = vim.api.nvim_create_augroup('term', { clear = true })

vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  pattern = '*',
  group = term_group,
  command = 'setlocal listchars= nonumber norelativenumber',
})

vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  pattern = '*',
  group = term_group,
  command = 'startinsert',
})





--{ "TermOpen", "*", [[tnoremap <buffer> <Esc> <c-\><c-n>]] };
--        { "TermOpen", "*", "startinsert" };
--        { "TermOpen", "*", "setlocal listchars= nonumber norelativenumber" };
