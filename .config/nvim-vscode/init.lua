print("Here we go...")
require "config.keymaps"
require "config.options"
require "config.lazy"

if vim.g.vscode then
  require "config.vscode_keymaps"
else

end
