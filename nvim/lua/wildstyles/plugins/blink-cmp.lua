return {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },

    version = "1.*",
    opts = {
        keymap = {
            preset = "default",
            ["<CR>"] = { "accept", "fallback" },
            ["<C><leader>"] = { "show" },
        },
        appearance = {
            nerd_font_variant = "mono",
        },

        cmdline = {
            keymap = { preset = "inherit" },
            completion = { menu = { auto_show = true } },
        },
        completion = { documentation = { auto_show = true } },
        sources = {
            providers = {
                -- enable the built-in cmdline source
                cmdline = {},
                -- enable the built-in path source for file-path completion
                path = {},
            },
            default = { "lsp", "path", "snippets", "buffer" },
        },

        fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
}
