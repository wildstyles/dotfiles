-- https://github.com/nvim-treesitter/nvim-treesitter-context
--
-- Filename: ~/github/dotfiles-latest/neovim/neobean/lua/plugins/nvim-treesitter-context.lua
-- ~/github/dotfiles-latest/neovim/neobean/lua/plugins/nvim-treesitter-context.lua
--
-- If on a markdown file, and you're inside a level 4 heading, this plugin shows
-- you the level 2 and 3 heading that you're under at the top of the screen
-- Really useful to know where you're at
--
-- This plugin used to be enabled by default in lazyvim, but it was moved to
-- extras lamw25wmal
--
-- I just copied Folke's config here
-- https://www.lazyvim.org/extras/ui/treesitter-context#nvim-treesitter-context

-- return {
--   "nvim-treesitter/nvim-treesitter-context",
--   event = { "BufReadPost", "BufNewFile" },
--   opts = { mode = "cursor", max_lines = 3 },
--   keys = {
--     {
--       "<leader>ut",
--       function()
--         local tsc = require("treesitter-context")
--         tsc.toggle()
--
--         vim.notify("Toggled Treesitter Context", vim.log.levels.INFO, { title = "Option" })
--       end,
--       desc = "Toggle Treesitter Context",
--     },
--   },
-- }
-- lua/plugins/treesitter-context.lua
return {
  "nvim-treesitter/nvim-treesitter-context",
  -- load when you open or create a buffer
  event = { "BufReadPost", "BufNewFile" },

  -- initial options for the plugin
  opts = {
    mode = "cursor",
    max_lines = 3,
    separator = "─",
  },

  -- run after opts are applied
  config = function(_, opts)
    -- set up the plugin
    require("treesitter-context").setup(opts)

    -- remove the grey bg
    vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "NONE" })
    -- color the separator and clear its bg
    vim.api.nvim_set_hl(0, "TreesitterContextSeparator", { fg = "#888888", bg = "NONE" })
  end,

  keys = {
    {
      "<leader>ut",
      function()
        local tsc = require("treesitter-context")
        tsc.toggle()

        vim.notify("Toggle Treesitter Context", vim.log.levels.INFO, { title = "Option" })
      end,
      desc = "Toggle Treesitter Context",
    },
  },
}
