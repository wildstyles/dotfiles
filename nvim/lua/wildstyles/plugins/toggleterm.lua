return {
	"akinsho/toggleterm.nvim",
	version = "*",
	opts = {--[[ things you want to change go here]]
	},

	config = function()
		require("toggleterm").setup({
			open_mapping = [[<c-_>]],
			direction = "float",
			on_open = function(term)
				vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc>", "<C-u>exit<CR>", { noremap = true })
				vim.api.nvim_buf_set_keymap(term.bufnr, "t", "nn", [[<C-\><C-n>]], { noremap = true })

				vim.api.nvim_buf_set_keymap( --exit from normal mode
					term.bufnr,
					"n",
					"<esc>",
					[[<cmd>call chansend(b:terminal_job_id, "exit\n")<CR>]],
					{ noremap = true, silent = true }
				)
			end,
		})
		vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm name=default<CR>", { desc = "Open float terminal" })
	end,
}
