return {
{
  "obsidian-nvim/obsidian.nvim",
  version = "*",  -- recommended, use latest release instead of latest commit
  lazy = true,
  --ft = "markdown",
  enabled = true,
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    "BufReadPre " .. vim.fn.expand "~" .. "/notes/personal/**.md",
    "BufNewFile " .. vim.fn.expand "~" .. "/notes/personal/**.md",
  },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp", -- for completion of note references
    "nvim-telescope/telescope.nvim", -- For quick pick of files
    -- overwrite anything vimwiki does - just in case
    -- "vimwiki/vimwiki",
  "folke/snacks.nvim", --image render
    "nvim-treesitter/nvim-treesitter"
  },

  config = function() 
    -- print("loading obsidian...")
    vim.opt.conceallevel = 2 
    local map = vim.keymap.set
    -- still figuring this thing out - auto folds everything (2026-03-10)
    -- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    -- vim.wo.foldmethod = "expr"
    map("n", "<localleader>s", "<cmd>Obsidian quick_switch<cr>", { desc = "QuickSwitch" })
    map("n", "<localleader>n", "<cmd>Obsidian new<cr>",        { desc = "New Note" })
    map("n", "<localleader>o", "<cmd>Obsidian open<cr>",        { desc = "Open in Obsidian" })

    -- follow link
    map("n", "<localleader>go", "<cmd>Obsidian follow_link<cr>",        { desc = "Follow link" })
    map("n", "<localleader>gv", "<cmd>Obsidian follow_link vsplit<cr>", { desc = "Follow link (vsplit)" })
    map("n", "<localleader>gh", "<cmd>Obsidian follow_link hsplit<cr>", { desc = "Follow link (hsplit)" })

    -- navigation
    map("n", "<localleader>t", "<cmd>Obsidian toc<cr>",       { desc = "Table of contents" })
    map("n", "<localleader>b", "<cmd>Obsidian backlinks<cr>", { desc = "Backlinks" })
    map("n", "<localleader>/", "<cmd>Obsidian search<cr>",    { desc = "Search notes" })

    -- insert
    map("n", "<localleader>p", "<cmd>Obsidian paste_img<cr>", { desc = "Paste image" })

    -- visual mode
    map("x", "<localleader>e", "<cmd>Obsidian extract_note<cr>", { desc = "Extract to new note" })
    map("x", "<localleader>l", "<cmd>Obsidian link<cr>",         { desc = "Link selection" })
    map("x", "<localleader>L", "<cmd>Obsidian link_new<cr>",     { desc = "Link to new note" })

    -- move note to a different directory in the vault
    map("n", "<localleader>mv", function()
      local vault_dir = tostring(Obsidian.dir)
      local src = vim.fn.expand("%:p")
      local filename = vim.fn.expand("%:t")

      local abs_dirs = require("plenary.scandir").scan_dir(vault_dir, {
        only_dirs = true,
        hidden = false,
        depth = 5,
      })

      local dirs = { "." }
      for _, d in ipairs(abs_dirs) do
        table.insert(dirs, d:sub(#vault_dir + 2))
      end

      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      require("telescope.pickers").new({}, {
        prompt_title = "Move note to...",
        finder = require("telescope.finders").new_table({ results = dirs }),
        sorter = require("telescope.config").values.generic_sorter({}),
        attach_mappings = function(prompt_bufnr)
          actions.select_default:replace(function()
            local sel = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            local rel = sel[1]
            local dst = rel == "." and (vault_dir .. "/" .. filename)
                                    or (vault_dir .. "/" .. rel .. "/" .. filename)
            if vim.fn.rename(src, dst) == 0 then
              vim.cmd("e " .. vim.fn.fnameescape(dst))
              vim.cmd("bdelete #")
              vim.notify("Moved to " .. (rel == "." and "/" or rel .. "/"), vim.log.levels.INFO)
            else
              vim.notify("Failed to move note", vim.log.levels.ERROR)
            end
          end)
          return true
        end,
      }):find()
    end, { desc = "Move note" })

    -- -- run this autocommand here so it's after the vimwiki plugin loads
    -- vim.cmd [[
    --     "augroup vimwiki
    --     "  autocmd!
    --     " I can't do this right now - task manager doesn[t work
    --     "augroup END
    --     augroup vitalyobsidian
    --       autocmd FileType vimwiki set ft=markdown
    --     augroup END
    --   ]]
    --

    -- do this here instead of as described in documentation
    -- this allows for more flexibility during configuration I think?
    -- If I didn't include it here, the the plugin didn't load correctly
    -- For example, the plugin commands didn't load - i dunno
    local opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/notes/personal",
        },
      },
      templates = {
        subdir = "zzz/templates",
      },
      legacy_commands = false,
      attachments = {
        folder = "zzz/attachments",
        confirm_img_paste = false
      },
        note_id_func = require("obsidian.builtin").title_id,
    }


    require("obsidian").setup(opts)

  end,
}
}
