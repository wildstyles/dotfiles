return {
  "luukvbaal/statuscol.nvim",
  enabled = false,
  config = function()
    local builtin = require("statuscol.builtin")
    --
    require("statuscol").setup({
      -- ensure the current line number is right-aligned
      relculright = true,
      segments = {
        -- { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
        {
          -- sign = { namespace = { "nvim.vim.lsp.lua_ls.1.diagnostic.signs" }, maxwidth = 1, auto = true },
          sign = { namespace = { "vim_diagnostic" }, maxwidth = 1, auto = true },
          -- click = "v:lua.ScSa",
        },
        { text = { "" } }, -- effectively zero-width
        -- { sign = { namespace = { "vim.diagnostic" }, maxwidth = 1, auto = true } },
        -- { text = { " " } },
        { text = { require("statuscol.builtin").lnumfunc }, click = "v:lua.ScLa" },
        { text = { " " } },
        { sign = { namespace = { "gitsigns" }, auto = true, maxwidth = 10 }, click = "v:lua.ScSa" },
      },
    })
  end,
}
