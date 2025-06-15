return {
  "akinsho/toggleterm.nvim",
  version = "*",

  config = function()
    require("toggleterm").setup({
      open_mapping = [[<c-_>]],
      direction = "float",
      close_on_exit = true,
      on_open = function(term)
        vim.api.nvim_buf_set_keymap(term.bufnr, "t", "nn", [[<C-\><C-n>]], { noremap = true })

        vim.keymap.set("t", "<Esc>", function()
          term:shutdown()
        end, { buffer = term.bufnr, noremap = true, silent = true })

        vim.keymap.set("n", "<Esc>", function()
          vim.cmd("startinsert")
        end, { buffer = term.bufnr, noremap = true, silent = true })
      end,
    })
    vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm name=default<CR>", { desc = "Open float terminal" })
  end,
}
