return {
	"luukvbaal/statuscol.nvim",
	config = function()
		local builtin = require("statuscol.builtin")

		require("statuscol").setup({
			relculright = true,
			segments = {

				{
					sign = {
						namespace = { "diagnostic.signs" },
						foldclosed = true,
						maxwidth = 1,
						colwidth = 2,
						auto = false,
					},
				},

				{ text = { " " } },

				{ text = { builtin.lnumfunc } },

				{
					sign = {
						auto = false,
						colwidth = 2,
						maxwidth = 1,
						namespace = { "gitsigns" },
						name = { ".*" },
					},
				},

				-- {
				-- 	text = {
				-- 		function(args)
				-- 			-- args.fold.close = ""
				-- 			-- args.fold.open = ""
				-- 			-- args.fold.open = " "
				-- 			args.fold.sep = " "
				-- 			return builtin.foldfunc(args)
				-- 		end,
				-- 	},
				-- 	colwidth = 1,
				-- 	click = "v:lua.ScFa",
				-- },
				--
				-- { text = { " " } },
			},
		})
	end,
}
