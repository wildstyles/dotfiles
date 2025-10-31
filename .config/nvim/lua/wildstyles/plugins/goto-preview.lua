-- Plugin allows to show variable definition in small window instead of
-- navigating to file

return {
	"rmagatti/goto-preview",
	event = "LspAttach",
	dependencies = { "rmagatti/logger.nvim" },
	config = function()
		require("goto-preview").setup({
			width = 90, -- float window width
			height = 25, -- float window height
			-- install <Esc> in preview buffer to close it
			post_open_hook = function(bufnr, _)
				vim.keymap.set(
					"n",
					"<Esc>",
					require("goto-preview").close_all_win,
					{ buffer = bufnr, silent = true, desc = "Close Preview" }
				)
			end,
			default_mappings = false, -- we’ll set our own
		})
	end,
	keys = {
		{
			"gp",
			function()
				require("goto-preview").goto_preview_definition()
			end,
			desc = "Peek Definition",
		},
		-- {
		--   "gD",
		--   function()
		--     vim.lsp.buf.definition()
		--   end,
		--   desc = "Go to Definition",
		-- },
		-- {
		--   "gi",
		--   function()
		--     require("goto-preview").goto_preview_implementation()
		--   end,
		--   desc = "Peek Implementation",
		-- },
		-- {
		--   "gt",
		--   function()
		--     require("goto-preview").goto_preview_type_definition()
		--   end,
		--   desc = "Peek Type Definition",
		-- },
		-- {
		--   "gr",
		--   function()
		--     require("goto-preview").goto_preview_references()
		--   end,
		--   desc = "Peek References",
		-- },
	},
}
