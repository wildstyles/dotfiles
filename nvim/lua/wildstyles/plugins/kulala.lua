return {
	"mistweaverco/kulala.nvim",
	keys = {
		{ "<leader>Rs", desc = "Send request" },
		{ "<leader>Ra", desc = "Send all requests" },
		{ "<leader>Rb", desc = "Open scratchpad" },
	},
	ft = { "http", "rest" },
	opts = {
		request_timout = 10000,
		-- global_keymaps = true,
		global_keymaps = {
			["Send all requests"] = false,
			-- ["Select environment"] = false,
			["Open kulala"] = false,
			["Download GraphQL schema"] = false,
			["Toggle headers/body"] = false,
			["Open scratchpad"] = false,
			["Close window"] = false,
			["Jump to next request"] = false,
			["Jump to previous request"] = false,
			["Send request"] = { -- sets global mapping
				"<CR>",
				function()
					require("kulala").run()
				end,
				mode = { "n", "v" }, -- optional mode, default is n
				desc = "Send request changed description", -- optional description, otherwise inferred from the key
			},
		},
		global_keymaps_prefix = "<leader>R",
		kulala_keymaps_prefix = "",
	},
}
