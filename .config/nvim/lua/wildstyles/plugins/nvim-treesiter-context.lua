-- Plugin adds context where cursor has on top of buffer

return {
	"nvim-treesitter/nvim-treesitter-context",
	event = { "BufReadPost", "BufNewFile" },

	opts = {
		mode = "cursor",
		max_lines = 5,
		separator = "─",
	},

	config = function(_, opts)
		require("treesitter-context").setup(opts)

		vim.api.nvim_set_hl(
			0,
			"TreesitterContextLineNumber",
			{ fg = "NONE", bg = "none" }
		)
		vim.api.nvim_set_hl(
			0,
			"TreesitterContextBottom",
			{ fg = "NONE", bg = "NONE" }
		)
	end,

	keys = {
		{
			"<leader>ut",
			function()
				local tsc = require("treesitter-context")
				tsc.toggle()

				vim.notify(
					"Toggle Treesitter Context",
					vim.log.levels.INFO,
					{ title = "Option" }
				)
			end,
			desc = "Toggle Treesitter Context",
		},
	},
}
