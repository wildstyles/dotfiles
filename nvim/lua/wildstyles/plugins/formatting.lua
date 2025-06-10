return {
  "stevearc/conform.nvim",

  -- enabled = false,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        liquid = { "prettier" },
        lua = { "stylua" },
        python = { "isort", "black" },
      },
      formatters = {
        stylua = {
          -- specify the CLI binary (optional if it's on your $PATH)
          cmd = "stylua",
          -- args: read from stdin (-), tell stylua which file this is:
          args = {
            "--indent-width",
            "2",
            "--stdin-filepath",
            vim.fn.expand("%:p"),
            "-", -- read from stdin
          },
          -- let Conform use stdin rather than spawning with filenames:
          stdin = true,
        }, -- … other formatter configs …
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
