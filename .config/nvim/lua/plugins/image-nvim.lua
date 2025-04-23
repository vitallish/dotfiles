-- https://github.com/3rd/image.nvim
--
-- Filename: ~/github/dotfiles-latest/neovim/nvim-lazyvim/lua/plugins/image-nvim.lua
-- ~/github/dotfiles-latest/neovim/nvim-lazyvim/lua/plugins/image-nvim.lua

-- For dependencies see
-- `~/github/dotfiles-latest/neovim/nvim-lazyvim/README.md`
--
-- -- Uncomment the following 2 lines if you use the local luarocks installation
-- -- Leave them commented to instead use `luarocks.nvim`
-- -- instead of luarocks.nvim
-- Notice that in the following 2 commands I'm using luaver
-- package.path = package.path
--   .. ";"
--   .. vim.fn.expand("$HOME")
--   .. "/.luaver/luarocks/3.11.0_5.1/share/lua/5.1/magick/?/init.lua"
-- package.path = package.path
--   .. ";"
--   .. vim.fn.expand("$HOME")
--   .. "/.luaver/luarocks/3.11.0_5.1/share/lua/5.1/magick/?.lua"
--
-- -- Here I'm not using luaver, but instead installed lua and luarocks directly through
-- -- homebrew
-- package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua"
-- package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua"

return {
  -- {
  -- luarocks.nvim is a Neovim plugin designed to streamline the installation
  -- of luarocks packages directly within Neovim. It simplifies the process
  -- of managing Lua dependencies, ensuring a hassle-free experience for
  -- Neovim users.
  -- https://github.com/vhyrro/luarocks.nvim
  -- "vhyrro/luarocks.nvim",
  -- this plugin needs to run before anything else
  --   priority = 1001,
  --   enabled = false,
  --   opts = {
  --     rocks = { "magick" },
  --   },
  -- },
  {
    "3rd/image.nvim",
    build = false,
    commit = "2e2d28b7734b5efdfc1219f4da8a46c761587bc2",
    enabled = true,
    config = function()
      require("image").setup({
        backend = "kitty",
        kitty_method = "normal",
        processor = "magick_cli",
        integrations = {
          -- Notice these are the settings for markdown files
          markdown = {
            enabled = true,
            clear_in_insert_mode = true,
            -- Set this to false if you don't want to render images coming from
            -- a URL
            download_remote_images = true,
            -- Change this if you would only like to render the image where the
            -- cursor is at
            -- I set this to true, because if the file has way too many images
            -- it will be laggy and will take time for the initial load
            only_render_image_at_cursor = "popup",
            -- markdown extensions (ie. quarto) can go here
            filetypes = { "markdown", "vimwiki" },
            -- https://github.com/3rd/image.nvim/issues/190#issuecomment-2791058642
            resolve_image_path = function(document_path, image_path, fallback)
              local obs = require("obsidian").get_client()
              local vault_root = obs:vault_root().filename

              -- If we're in a vault, try using vault behavior
              if document_path:find(vault_root, 1, 1) then
                local obs_rel = obs:vault_relative_path(image_path)

                if (
                  obs_rel
                  and vim.fn.filereadable(vault_root .. "/" .. obs_rel.filename) == 1
                ) then
                  return vault_root .. "/" .. obs_rel.filename
                end
              end

              return fallback(document_path, image_path)
            end,
          },
          neorg = {
            enabled = false,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = "popup",
            filetypes = { "norg" },
          },
          -- This is disabled by default
          -- Detect and render images referenced in HTML files
          -- Make sure you have an html treesitter parser installed
          -- ~/github/dotfiles-latest/neovim/nvim-lazyvim/lua/plugins/treesitter.lua
          html = {
            enabled = false,
          },
          -- This is disabled by default
          -- Detect and render images referenced in CSS files
          -- Make sure you have a css treesitter parser installed
          -- ~/github/dotfiles-latest/neovim/nvim-lazyvim/lua/plugins/treesitter.lua
          css = {
            enabled = false,
          },
        },
        max_width = nil,
        max_height = nil,
        max_width_window_percentage = nil,

        -- This is what I changed to make my images look smaller, like a
        -- thumbnail, the default value is 50
        -- max_height_window_percentage = 20,
        max_height_window_percentage = 40,

        -- toggles images when windows are overlapped
        window_overlap_clear_enabled = false,
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },

        -- auto show/hide images when the editor gains/looses focus
        editor_only_render_when_focused = true,

        -- auto show/hide images in the correct tmux window
        -- In the tmux.conf add `set -g visual-activity off`
        tmux_show_only_in_active_window = true,

        -- render image files as images when opened
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
      })
    end,
  },
}

