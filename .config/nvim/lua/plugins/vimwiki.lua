return {
  {
    -- The plugin location on GitHub
    "vimwiki/vimwiki",
    lazy = true,
    -- The event that triggers the plugin

    -- The keys that trigger the plugin
    -- keys = { "<leader>ww", "<leader>wt" },
    -- The configuration for the plugin
    init = function()
      vim.g.vimwiki_list = {
        {
          -- Here will be the path for your wiki
          path = "~/Notes/personal/",
          -- The syntax for the wiki
          syntax = "markdown",
          ext = "md",
        },
      }
      vim.g.vimwiki_ext2syntax = {
        ['.dumpit'] = 'markdown', 
      }
    end,
  },
  {  "tools-life/taskwiki",
    init = function() 
      vim.g.taskwiki_taskrc_location = "~/.config/task/taskrc"
    end,
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
      "BufReadPre " .. vim.fn.expand "~" .. "/Notes/personal/**.md",
      "BufNewFile " .. vim.fn.expand "~" .. "/Notes/personal/**.md",
    },   
    dependencies = {
      "vimwiki/vimwiki",

    }
  }
}
