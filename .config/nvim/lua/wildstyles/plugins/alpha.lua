-- Plugin which configures initial screen after nvim command

local function dup(value, count)
	local result = {}
	for i = 1, count do
		table.insert(result, value)
	end
	return result
end

return {
	-- dashboard to greet
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			-- Set header
			dashboard.section.header.val = dup("", 20)

			-- Set menu
			dashboard.section.buttons.val = {
				dashboard.button(
					"r",
					"󰁯  > Restore Session For Current Directory",
					"<cmd>AutoSession restore<CR>"
				),
				-- dashboard.button("l", "📦  Lazy Plugin Manager", ":Lazy<CR>"),
				-- dashboard.button(
				-- 	"m",
				-- 	"🧱  Mason Package Manager",
				-- 	":Mason<CR>"
				-- ),
				dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
			}

			-- Function to get a random fortune from the list
			local function get_random_fortune()
				local fortune_list = {
					{
						"Code is like humor. When you have to explain it, it’s bad.",
						"",
						"— Cory House 🤖",
					},
					{
						"First, solve the problem. Then, write the code.",
						"",
						"— John Johnson 💻",
					},
					{
						"Simplicity is the soul of efficiency.",
						"",
						"— Austin Freeman 🌟",
					},
					{
						"Programs must be written for people to read, and only incidentally for machines to execute.",
						"",
						"— Abelson & Sussman 📜",
					},
					{
						"The most damaging phrase in the language is 'We've always done it this way.'",
						"",
						"— Grace Hopper 🚀",
					},
					{
						"Talk is cheap. Show me the code.",
						"",
						"— Linus Torvalds 👨‍💻",
					},
					{
						"Good code is its own best documentation.",
						"",
						"— Steve McConnell 📖",
					},
					{
						"The best way to predict the future is to invent it.",
						"",
						"— Alan Kay 🛠️",
					},
					{
						"In programming, the hard part isn’t solving problems, but deciding what problems to solve.",
						"",
						"— Paul Graham 🔍",
					},
					{
						"It’s not a bug; it’s an undocumented feature.",
						"",
						"— Anonymous 🐞",
					},
				}

				-- Get a random index
				local index = math.random(#fortune_list)

				return fortune_list[index][1] .. " " .. fortune_list[index][3] -- Combine message and author
			end

			dashboard.section.footer.val = {
				"",
				"",
				"",
				"",
				"",
				"",
				get_random_fortune(),
			}

			-- vim.api.nvim_create_autocmd("User", {
			-- 	once = true,
			-- 	pattern = "LazyVimStarted",
			-- 	callback = function()
			-- 		local stats = require("lazy").stats()
			-- 		local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
			-- 		dashboard.section.footer.val = {
			-- 			"⚡ Neovim loaded "
			-- 				.. stats.loaded
			-- 				.. "/"
			-- 				.. stats.count
			-- 				.. " plugins in "
			-- 				.. ms
			-- 				.. "ms",
			-- 			"",
			-- 			"",
			-- 			get_random_fortune(), -- Append a new random fortune
			-- 		}
			-- 		pcall(vim.cmd.AlphaRedraw)
			-- 	end,
			-- })

			-- Send config to alpha
			alpha.setup(dashboard.opts)
		end,
	},
}
