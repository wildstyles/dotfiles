local DIAG_NAV_NS = vim.api.nvim_create_namespace("diag_jump_ns")

local function nav_inline(opts)
  vim.g._inline_diag_enabled = false
  vim.diagnostic.config({ virtual_text = vim.g._inline_diag_enabled })

  vim.diagnostic.jump(opts)

  vim.diagnostic.hide(DIAG_NAV_NS, 0)
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  local diags = vim.diagnostic.get(0, { lnum = row })
  vim.diagnostic.show(DIAG_NAV_NS, 0, diags, {
    virtual_text = { only_current_line = true },
  })
end

return {
  "folke/trouble.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  cmd = "Trouble",
  keys = {
    {
      "<leader>dn",
      function()
        nav_inline({ count = 1 })
      end,
      desc = "Next diagnostic",
    },
    {
      "<leader>dN",
      function()
        nav_inline({ count = -1 })
      end,
      desc = "Prev diagnostic",
    },
    {
      "<leader>df",
      "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
      desc = "Show diagnostics for file",
    },
    {
      "<leader>dd",
      function()
        vim.diagnostic.hide(DIAG_NAV_NS, 0)
        vim.g._inline_diag_enabled = not vim.g._inline_diag_enabled
        vim.diagnostic.config({ virtual_text = vim.g._inline_diag_enabled })
      end,
      desc = "Toggle inline diagnostics for entire file",
    },
  },
  opts = { focus = true },
  config = function(_, opts)
    require("trouble").setup(opts)

    vim.g._inline_diag_enabled = false
    vim.diagnostic.config({ float = false, virtual_text = false })
  end,
}
