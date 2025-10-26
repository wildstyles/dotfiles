return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	init = false,
	enable = true,
	config = function()
		local dashboard = require("alpha.themes.dashboard")

		-- Set header
		dashboard.section.header.val = {
			"                                                     ",
			"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
			"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
			"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
			"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
			"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
			"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
			"                                                     ",
		}
		--
		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
			dashboard.button(
				"SPC ee",
				"  > Toggle file explorer",
				"<cmd>NvimTreeToggle<CR>"
			),
			dashboard.button(
				"SPC ff",
				"󰱼 > Find File",
				"<cmd>Telescope find_files<CR>"
			),
			dashboard.button(
				"SPC fs",
				"  > Find Word",
				"<cmd>Telescope live_grep<CR>"
			),
			dashboard.button(
				"SPC wr",
				"󰁯  > Restore Session For Current Directory",
				"<cmd>SessionRestore<CR>"
			),
			dashboard.button("q", " > Quit NVIM", "<cmd>qa<CR>"),
		}
		--
		-- Send config to alpha NOTE: for some reason plugin failes to run
		require("alpha").setup(dashboard.config)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
