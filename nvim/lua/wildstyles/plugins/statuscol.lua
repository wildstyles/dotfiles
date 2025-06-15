return {
  "luukvbaal/statuscol.nvim",
  config = function()
    local builtin = require("statuscol.builtin")
    require("statuscol").setup({
      relculright = true,
      segments = {
        -- { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
        { sign = { namespace = { "diagnostic.signs" }, maxwidth = 1, colwidth = 2, auto = false } },
        -- { text = { " " } },
        { text = { builtin.lnumfunc } },
        {
          sign = { auto = false, colwidth = 2, maxwidth = 1, namespace = { "gitsigns" }, name = { ".*" } },
        },
      },
    })
  end,
}
