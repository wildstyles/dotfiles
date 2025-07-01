return {
  "AckslD/nvim-neoclip.lua",
  dependencies = {
    { "nvim-telescope/telescope.nvim" },
  },
  config = function()
    require("neoclip").setup({
      default_register = "+",
    })

    vim.keymap.set("n", "<leader>o", "<cmd>Telescope neoclip initial_mode=normal<CR>", { desc = "Telescope Neoclip" })
  end,
}
