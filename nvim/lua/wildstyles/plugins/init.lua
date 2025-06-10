return {
	"nvim-lua/plenary.nvim", -- lua functions that many plugins use
	{
		"aaronhallaert/advanced-git-search.nvim",
		dependencies = {
			"tpope/vim-fugitive",
			"tpope/vim-rhubarb",
		},
	},
	-- {
	-- 	"mbbill/undotree",
	-- 	config = function()
	-- 		vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<CR>", { desc = "Telescope Undo" })
	-- 	end,
	-- },
}
