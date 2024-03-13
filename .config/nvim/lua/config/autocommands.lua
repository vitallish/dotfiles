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

-- always enter terminal in insert mode
vim.api.nvim_create_autocmd({ "WinEnter" }, { 
  pattern = "term://*", 
  group = term_group,
  command = "startinsert" })




--{ "TermOpen", "*", [[tnoremap <buffer> <Esc> <c-\><c-n>]] };
--        { "TermOpen", "*", "startinsert" };
--        { "TermOpen", "*", "setlocal listchars= nonumber norelativenumber" };
