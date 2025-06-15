return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPre", "BufNewFile" },
  main = "ibl",
  enabled = true,
  config = function()
    local hooks = require("ibl.hooks")

    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)

    require("ibl").setup({
      indent = { char = "┊" },
    })
  end,
}
