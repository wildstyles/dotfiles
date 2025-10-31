-- Plugin helps to navigate between nvim and tmux in split

return {
	"christoomey/vim-tmux-navigator",
	lazy = true,
	keys = {
		{ "<c-Left>", "<cmd>TmuxNavigateLeft<cr>" },
		{ "<c-Down>", "<cmd>TmuxNavigateDown<cr>" },
		{ "<c-Up>", "<cmd>TmuxNavigateUp<cr>" },
		{ "<c-Right>", "<cmd>TmuxNavigateRight<cr>" },
		{ "<c-h>" },
		{ "<c-j>" },
		{ "<c-k>" },
		{ "<c-l>" },
	},
}
