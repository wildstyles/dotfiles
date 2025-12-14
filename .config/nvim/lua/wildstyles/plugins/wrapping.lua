return {
	"rickhowe/wrapwidth",
	config = function()
		vim.g.disable_linewrap = false

		vim.keymap.set("n", "<leader>lw", function()
			vim.g.disable_linewrap = not vim.g.disable_linewrap
			vim.b.disable_linewrap = not vim.b.disable_linewrap

			if vim.g.disable_linewrap then
				vim.cmd("Wrapwidth 80")
			else
				vim.cmd("Wrapwidth 200")
			end
		end, { desc = "Toggle virtual line wrapping" })
	end,
}
