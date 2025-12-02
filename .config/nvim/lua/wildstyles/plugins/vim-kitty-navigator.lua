return {
	{
		"knubie/vim-kitty-navigator",
		build = "cp ./*.py ~/.config/kitty/",
		init = function()
			vim.g.kitty_navigator_no_mappings = 1
		end,
		keys = {
			{
				"<C-left>",
				"<cmd>KittyNavigateLeft<cr>",
				mode = { "n", "v", "i" },
				desc = "KittyNavigateLeft",
			},
			{
				"<C-down>",
				"<cmd>KittyNavigateDown<cr>",
				mode = { "n", "v", "i" },
				desc = "KittyNavigateDown",
			},
			{
				"<C-up>",
				"<cmd>KittyNavigateUp<cr>",
				mode = { "n", "v", "i" },
				desc = "KittyNavigateUp",
			},
			{
				"<C-right>",
				"<cmd>KittyNavigateRight<cr>",
				mode = { "n", "v", "i" },
				desc = "KittyNavigateRight",
			},
		},
	},
}
