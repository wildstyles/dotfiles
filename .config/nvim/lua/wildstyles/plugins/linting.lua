-- Plugin for linting

local cfg_path = os.getenv("HOME") .. "/Projects/dotfiles/.markdownlint.yaml"

return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			svelte = { "eslint_d" },
			markdown = { "markdownlint-cli2" },
			python = { "pylint" },
		}

		--https://github.com/LazyVim/LazyVim/discussions/4094#discussioncomment-10178217
		lint.linters["markdownlint-cli2"].args = { "--config", cfg_path, "--" }

		local lint_augroup =
			vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd(
			{ "BufEnter", "BufWritePost", "InsertLeave" },
			{
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			}
		)

		-- vim.keymap.set("n", "<leader>l", function()
		-- 	lint.try_lint()
		-- end, { desc = "Trigger linting for current file" })
	end,
}
