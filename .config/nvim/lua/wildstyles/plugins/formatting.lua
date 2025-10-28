return {
	"stevearc/conform.nvim",

	enabled = true,
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters = {
				kulala = {
					command = "kulala-fmt",
					args = { "format", "$FILENAME" },
					stdin = false,
				},
			},
			formatters_by_ft = {
				http = { "kulala" },
				lua = { "stylua" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "prettier" },
				markdown = { "prettier" },
				erb = { "htmlbeautifier" },
				html = { "htmlbeautifier" },
				bash = { "beautysh" },
				yaml = { "yamlfix" },
				toml = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				styl = { "prettier" },
				sh = { "shellcheck" },
			},
			format_on_save = function(bufnr)
				-- Disable with a global or buffer-local variable
				if
					vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat
				then
					return
				end

				return { timeout_ms = 1000, async = false, lsp_fallback = true }
			end,
		})

		vim.keymap.set("n", "<leader>lt", function()
			vim.g.disable_autoformat = not vim.g.disable_autoformat
			vim.b.disable_autoformat = not vim.b.disable_autoformat
		end, { desc = "Toggle auto-formatting" })
	end,
}
