-- Plugin to invoke float terminal. Might be replaces with tmux native one

return {
	"akinsho/toggleterm.nvim",

	version = "*",

	config = function()
		local cols = vim.o.columns
		local lines = vim.o.lines

		require("toggleterm").setup({
			open_mapping = [[<c-_>]],
			direction = "float",
			float_opts = {
				width = cols - 4,
				height = lines - 4,
				winblend = 0,
			},

			close_on_exit = true,
			on_open = function(term)
				vim.api.nvim_buf_set_keymap(
					term.bufnr,
					"t",
					"nn",
					[[<C-\><C-n>]],
					{ noremap = true }
				)

				vim.keymap.set("t", "<Esc>", function()
					term:shutdown()
				end, { buffer = term.bufnr, noremap = true, silent = true })

				vim.keymap.set("n", "<Esc>", function()
					vim.cmd("startinsert")
				end, { buffer = term.bufnr, noremap = true, silent = true })
			end,
		})
	end,
}
