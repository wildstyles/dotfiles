-- Plugin helps to work with folds

return {
	"kevinhwang91/nvim-ufo",
	dependencies = "kevinhwang91/promise-async",
	config = function()
		vim.o.foldcolumn = "1" -- '0' is not bad
		vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true

		-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
		vim.keymap.set(
			"n",
			"zR",
			require("ufo").openAllFolds,
			{ desc = "Open all folds" }
		)
		vim.keymap.set(
			"n",
			"zM",
			require("ufo").closeAllFolds,
			{ desc = "Close all folds" }
		)
		-- vim.keymap.set("n", "zK", function()
		-- 	local winid = require("ufo").peekFoldedLinesUnderCursor()
		-- 	if not winid then
		-- 		vim.lsp.buf.hover()
		-- 	end
		-- end, { desc = "Peek Fold" })
		--
		local ftMap = {
			lua = { "lsp", "indent" },
			javascript = { "lsp", "indent" },
			markdown = "", -- folding works correnctly only in this way for .md
		}

		require("ufo").setup({
			provider_selector = function(bufnr, filetype, buftype)
				print(filetype)
				return ftMap[filetype]
			end,
		})
	end,
}
