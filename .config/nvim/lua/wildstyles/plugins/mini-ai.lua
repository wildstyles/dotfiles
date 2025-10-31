-- Plugin extends default text objects. Like diw, cab

return {
	"echasnovski/mini.ai",
	version = "*",
	config = function()
		require("mini.ai").setup()
	end,
}
