return {
	"echasnovski/mini.indentscope",
	version = false, -- wait till new 0.7.0 release to put it back on semver
	enabled = false,
	-- event = "LazyFile",
	opts = {
		-- symbol = "▏",
		-- symbol = '╎',
		symbol = "│",
		draw = {
			predicate = function(scope)
				return scope.reference.indent > 2
			end,
			delay = 50,
		},
		options = { try_as_border = true },
	},
	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"help",
				"alpha",
				"dashboard",
				"neo-tree",
				"Trouble",
				"trouble",
				"lazy",
				"mason",
				"notify",
				"toggleterm",
				"lazyterm",
			},
			callback = function()
				vim.b.miniindentscope_disable = true
			end,
		})
	end,
	config = function(_, opts)
		require("mini.indentscope").setup(opts)

		-- Use a dim color for non-current scope
		vim.api.nvim_set_hl(0, "MiniIndentscopeSymbolOff", { link = "Comment" })

		-- Bright for current scope
		vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { link = "Keyword" })
	end,
}
