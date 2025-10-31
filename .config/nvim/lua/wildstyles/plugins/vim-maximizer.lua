-- Plugin allows to maximaze a buffer

return {
	"szw/vim-maximizer",
	keys = {
		{
			"<leader>sm",
			"<cmd>MaximizerToggle<CR>",
			desc = "Maximize/minimize a split",
		},
	},
}
