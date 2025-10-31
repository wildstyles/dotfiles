-- Plugin allows to replace text

return {
	"MagicDuck/grug-far.nvim",
	--- Ensure existing keymaps and opts remain unaffected
	config = function(_, opts)
		require("grug-far").setup(opts)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "grug-far",
			callback = function()
				-- Map <Esc> to quit after ensuring we're in normal mode
				vim.keymap.set(
					{ "i", "n" },
					"<Esc>",
					"<Cmd>stopinsert | bd!<CR>",
					{ buffer = true }
				)
			end,
		})
	end,
	keys = {
		{
			"<leader>rc",
			function()
				require("grug-far").open({
					prefills = { search = vim.fn.expand("<cword>") },
				})
			end,
			mode = { "n", "v" },
			desc = "Search and Replace under cursor",
		},
		{
			"<leader>rf",
			function()
				require("grug-far").open({
					prefills = { paths = vim.fn.expand("%") },
				})
			end,
			mode = { "n", "v" },
			desc = "Search and Replace in current file",
		},
		{
			"<leader>rr",
			function()
				local grug = require("grug-far")
				local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
				grug.open({
					transient = true,
					prefills = {
						filesFilter = ext and ext ~= "" and "*." .. ext or nil,
					},
				})
			end,
			mode = { "n", "v" },
			desc = "Search and Replace",
		},
	},
}
