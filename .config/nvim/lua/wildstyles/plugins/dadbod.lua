-- Plugin to conect and query databases within nvim
return {
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{
				"kristijanhusak/vim-dadbod-completion",
				ft = { "sql", "mysql", "plsql" },
				lazy = true,
			},
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_save_location = "~/Projects/karabiner/nvim/lua/db_ui_queries"

			local ok, dbs = pcall(require, "private.dbs")
			if not ok then
				vim.notify("Could not load private DB creds", vim.log.levels.WARN)
				dbs = {}
			end

			vim.g.dbs = dbs

			vim.keymap.set(
				"n",
				"<leader>db",
				"<cmd>tab DBUI<CR>",
				{ desc = "Open DB" }
			)

			vim.keymap.set(
				{ "n", "v" },
				"<leader>b",
				"vip<Plug>(DBUI_ExecuteQuery)",
				{ desc = "Execute query on cursor" }
			)
		end,
	},
	{
		"saghen/blink.cmp",
		opts = {
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				per_filetype = {
					sql = { "snippets", "dadbod", "buffer" },
				},
				-- add vim-dadbod-completion to your completion providers
				providers = {
					dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
				},
			},
		},
	},
}
