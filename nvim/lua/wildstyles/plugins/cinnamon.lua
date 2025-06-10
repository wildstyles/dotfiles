return {
	"declancm/cinnamon.nvim",
	version = "*", -- use latest release
	keymaps = {
		basic = true,
		extra = true,
	},
	opts = {
		mode = "window",
		-- change default options here
	},
	config = function()
		require("cinnamon").setup({
			keymaps = { basic = true, extra = false },
		})

		local cinnamon = require("cinnamon")

		vim.keymap.set("n", "<C-u>", function()
			cinnamon.scroll("<C-u>zz")
		end)

		vim.keymap.set("n", "<C-d>", function()
			cinnamon.scroll("<C-d>zz")
		end)

		vim.keymap.set("n", "{", function()
			cinnamon.scroll("{zz")
		end)

		vim.keymap.set("n", "}", function()
			cinnamon.scroll("}zz")
		end)
	end,
}
