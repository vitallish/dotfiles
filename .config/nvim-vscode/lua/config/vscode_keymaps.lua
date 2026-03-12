-- VSCode-specific keymaps that call VSCode actions via vscode-neovim
-- Inspired by R.nvim (https://github.com/R-nvim/R.nvim/blob/main/lua/r/maps.lua)
--
-- NOTE: On macOS, Ctrl+Shift+<key> combos do not reliably pass through
-- vscode-neovim. The following keybindings are therefore defined in
-- VSCode keybindings.json instead of here:
--   - Ctrl+Shift+M  →  Insert |> pipe  (editor & terminal)
--   - Ctrl+Shift+Enter  →  Run chunk / source / quarto cell

if not vim.g.vscode then
  return
end

local vscode = require("vscode")
local keymap = vim.keymap.set

-------------------------------------------------------------------------------
-- Helpers
-------------------------------------------------------------------------------

--- Create a keymap that calls a VSCode action
---@param mode string|string[] Vim mode(s)
---@param lhs string Key combination
---@param action string VSCode action/command identifier
---@param desc string Keymap description
---@param action_args any[]|nil Arguments passed to the VSCode command
local function vsc(mode, lhs, action, desc, action_args)
  keymap(mode, lhs, function()
    vscode.action(action, { args = action_args })
  end, { silent = true, noremap = true, desc = desc })
end

--- Create a <localleader> keymap running r.runCommandWithSelectionOrWord
---@param suffix string Key(s) after <localleader>
---@param r_expr string R expression ($$ = word/selection placeholder)
---@param desc string Short description (auto-prefixed with "R: ")
local function r_inspect(suffix, r_expr, desc)
  vsc({ "n", "v" }, "<localleader>" .. suffix,
    "r.runCommandWithSelectionOrWord", "R: " .. desc, { r_expr })
end

-------------------------------------------------------------------------------
-- Text Insertion
-------------------------------------------------------------------------------

keymap("i", "<M-->", " <- ", { silent = true, noremap = true, desc = "R: Insert assignment (<-)" })
-- Pipe (|>) is handled in VSCode keybindings.json because Ctrl+Shift+M
-- does not reliably pass through vscode-neovim on macOS.

-------------------------------------------------------------------------------
-- Code Execution
-------------------------------------------------------------------------------

vsc({ "n", "v" }, "<CR>", "r.runSelection", "R: Run line/selection")

-- Ctrl+Shift+Enter is handled in VSCode keybindings.json because the
-- key combo does not reliably pass through vscode-neovim on macOS.

-------------------------------------------------------------------------------
-- Help
-------------------------------------------------------------------------------

vsc({ "n", "v" }, "<localleader>rh", "r.helpPanel.openForSelection", "R: Help for symbol under cursor")

-------------------------------------------------------------------------------
-- R Object Inspection (<localleader> replaces ctrl+')
-------------------------------------------------------------------------------

r_inspect("s", "str($$)", "str")
r_inspect("g",
  "options(width = as.integer(system2('tput', 'cols', stdout = TRUE)));"
    .. "tryCatch(dplyr::glimpse($$), error = function(e) str($$))",
  "glimpse (with fallback)")
r_inspect("p", "$$", "print")
r_inspect("<localleader>", "$$", "print (double-tap)")
r_inspect("d", "dim($$)", "dim")
vsc({ "n", "v" }, "<localleader>h", "r.head", "R: head")
r_inspect("a", "attributes($$)", "attributes")
r_inspect("n", "names($$)", "names")
r_inspect("N", "matrix(names($$), ncol = 1)", "names (vertical)")
r_inspect("v", "View($$)", "View")
r_inspect("u", "summary($$)", "summary")
vsc("n", "<localleader>w", "r.runCommand", "R: Set terminal width",
  { "options(width = as.integer(system2('tput', 'cols', stdout = TRUE)))" })

-------------------------------------------------------------------------------
-- R .Last.value Inspection
-------------------------------------------------------------------------------

vsc({ "n", "v" }, "<localleader>P", "r.runCommand", "R: print .Last.value",
  { ".Last.value" })
vsc({ "n", "v" }, "<localleader>G", "r.runCommand", "R: glimpse .Last.value",
  { "options(width = as.integer(system2('tput', 'cols', stdout = TRUE)));tryCatch(dplyr::glimpse(.Last.value), error = function(e) str(.Last.value))" })

-------------------------------------------------------------------------------
-- Background Tasks (<localleader>b) — package dev, build, restart
-------------------------------------------------------------------------------

vsc("n", "<localleader>bd", "r.document", "R: Document package")
vsc("n", "<localleader>bl", "r.runCommand", "R: Document and load package",
  { "devtools::document(); devtools::load_all()" })
vsc("n", "<localleader>bi", "r.runCommand", "R: Document and install package",
  { "devtools::document(); devtools::install('.', quick = TRUE, upgrade = 'never')" })

-- Restart R session (sends Ctrl-C then restarts)
vsc("n", "<localleader>br", "r.runCommand", "R: Restart R session",
  { "rstudioapi::restartSession()" })
vsc("n", "<localleader>bp", "workbench.action.tasks.runTask", "R: Pkgdown build site",
  { "R: Pkgdown" })
vsc("n", "<localleader>bv", "workbench.action.tasks.runTask", "R: Build Vignettes",
  { "R: Build Vignettes" })
vsc("n", "<localleader>bt", "workbench.action.tasks.runTask", "R: Tar Make",
  { "R: Tar Make" })

-- UI/Navigation and Window Management are handled in VSCode
-- keybindings.json (not here) so they work globally regardless of Neovim focus.
