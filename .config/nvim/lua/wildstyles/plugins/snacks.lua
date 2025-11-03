return {
	{
		"folke/snacks.nvim",
		keys = {
			-- I use this keymap with mini.files, but snacks explorer was taking over
			-- https://github.com/folke/snacks.nvim/discussions/949
			{ "<leader>e", false },
			-- Open git log in vertical view
			{
				"<leader>fl",
				function()
					Snacks.picker.git_log({
						finder = "git_log",
						format = "git_log",
						preview = "git_show",
						confirm = "git_checkout",
					})
				end,
				desc = "Git Log",
			},
			{
				"<leader>fb",
				function()
					Snacks.picker.git_branches({
						layout = "select",
					})
				end,
				desc = "Select Branch",
			},
			{
				"<M-k>",
				function()
					Snacks.picker.keymaps({
						layout = "vertical",
					})
				end,
				desc = "Keymaps",
			},
			-- TODO: try to replace explorer with Snacks too
			-- {
			-- 	"<leader>ke",
			-- 	function()
			-- 		Snacks.picker.explorer({
			-- 			finder = "explorer",
			-- 		})
			-- 	end,
			-- 	desc = "Explorer",
			-- },
			{
				"<leader>fs",
				function()
					Snacks.picker.grep({
						finder = "grep",
						format = "file",
						live = true,
						hidden = true,
						ignored = true,
						title = "Live Grep",

						exclude = { "^.git/", "node_modules/" },
						show_empty = true,
						supports_live = true,
						layout = "telescope",
					})
				end,
				desc = "Find String",
			},
			-- File picker
			{
				"<leader>fr",
				function()
					Snacks.picker.recent({
						finder = "recent_files",
						format = "file",
						filter = { cwd = true },
						layout = "telescope",
					})
				end,
				desc = "Recent Files",
			},
			-- {
			-- 	"<leader>fg",
			-- 	function()
			-- 		Snacks.picker.search_history({
			-- 			finder = "vim_history",
			-- 			name = "search",
			-- 			format = "text",
			-- 			preview = "none",
			-- 			main = { current = true },
			-- 			layout = { preset = "vscode" },
			-- 			confirm = "search",
			-- 			formatters = { text = { ft = "regex" } },
			-- 		})
			-- 	end,
			-- 	desc = "Recent Files",
			-- },
			{
				"<leader>ff",
				function()
					Snacks.picker.files({
						finder = "files",
						format = "file",
						hidden = true,
						ignored = true,
						title = "Find Files",

						exclude = { "^.git/", "node_modules/" },
						show_empty = true,
						supports_live = true,
						layout = "telescope",
					})
				end,
				desc = "Find Files",
			},
			-- Navigate my buffers
			{
				"h",
				function()
					Snacks.picker.buffers({
						-- I always want my buffers picker to start in normal mode
						on_show = function()
							vim.cmd.stopinsert()
						end,
						finder = "buffers",
						format = "buffer",
						hidden = false,
						unloaded = true,
						current = false,
						sort_lastused = true,
						layout = "telescope",
						win = {
							input = {
								keys = {
									["d"] = "bufdelete",
								},
							},
							list = { keys = { ["d"] = "bufdelete" } },
						},
						-- In case you want to override the layout for this keymap
						-- layout = "ivy",
					})
				end,
				desc = "[P]Snacks picker buffers",
			},
		},
		opts = {
			picker = {
				debug = {
					scores = false, -- show scores in the list
				},
				layout = {
					preset = "telescope",
					cycle = true,
				},
				layouts = {
					telescope = {
						layout = {
							box = "horizontal",
							backdrop = true,
							width = 0.9,
							height = 0.85,
							border = "none",
							{
								box = "vertical",
								{
									win = "list",
									title = " Results ",
									title_pos = "center",
									border = true,
								},
								{
									win = "input",
									height = 1,
									border = true,
									title = "{title}",
									title_pos = "center",
								},
							},
							{
								win = "preview",
								title = "{preview:Preview}",
								width = 0.6,
								border = true,
								title_pos = "center",
							},
						},
					},
					vertical = {
						layout = {
							backdrop = false,
							width = 0.8,
							min_width = 80,
							height = 0.8,
							min_height = 30,
							box = "vertical",
							border = "rounded",
							title = "{title} {live} {flags}",
							title_pos = "center",
							{ win = "input", height = 1, border = "bottom" },
							{ win = "list", border = "none" },
							{
								win = "preview",
								title = "{preview}",
								height = 0.4,
								border = "top",
							},
						},
					},
				},
				matcher = {
					frecency = true,
				},
				win = {
					input = {
						keys = {
							-- to close the picker on ESC instead of going to normal mode,
							-- add the following keymap to your config
							["<Esc>"] = { "close", mode = { "n", "i" } },
							-- I'm used to scrolling like this in LazyGit
							["<C-d>"] = {
								"preview_scroll_down",
								mode = { "i", "n" },
							},
							["<C-u>"] = {
								"preview_scroll_up",
								mode = { "i", "n" },
							},
							-- ["H"] = {
							-- 	"preview_scroll_left",
							-- 	mode = { "i", "n" },
							-- },
							-- ["L"] = {
							-- 	"preview_scroll_right",
							-- 	mode = { "i", "n" },
							-- },
						},
					},
				},
				formatters = {
					file = {
						filename_first = true, -- display filename before the file path
						truncate = 80,
					},
				},
			},
			-- Folke pointed me to the snacks docs
			-- https://github.com/LazyVim/LazyVim/discussions/4251#discussioncomment-11198069
			-- Here's the lazygit snak docs
			-- https://github.com/folke/snacks.nvim/blob/main/docs/lazygit.md
			notifier = {
				enabled = true,
				top_down = false, -- place notifications from top to bottom
			},
			-- This keeps the image on the top right corner, basically leaving your
			-- text area free, suggestion found in reddit by user `Redox_ahmii`
			-- https://www.reddit.com/r/neovim/comments/1irk9mg/comment/mdfvk8b/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
			styles = {
				snacks_image = {
					relative = "editor",
					col = -1,
				},
			},
			image = {
				enabled = true,
				doc = {
					-- Personally I set this to false, I don't want to render all the
					-- images in the file, only when I hover over them
					-- render the image inline in the buffer
					-- if your env doesn't support unicode placeholders, this will be disabled
					-- takes precedence over `opts.float` on supported terminals
					inline = vim.g.neovim_mode == "skitty" and true or false,
					-- only_render_image_at_cursor = vim.g.neovim_mode == "skitty" and false or true,
					-- render the image in a floating window
					-- only used if `opts.inline` is disabled
					float = true,
					-- Sets the size of the image
					-- max_width = 60,
					-- max_width = vim.g.neovim_mode == "skitty" and 20 or 60,
					-- max_height = vim.g.neovim_mode == "skitty" and 10 or 30,
					max_width = vim.g.neovim_mode == "skitty" and 5 or 60,
					max_height = vim.g.neovim_mode == "skitty" and 2.5 or 30,
					-- max_height = 30,
					-- Apparently, all the images that you preview in neovim are converted
					-- to .png and they're cached, original image remains the same, but
					-- the preview you see is a png converted version of that image
					--
					-- Where are the cached images stored?
					-- This path is found in the docs
					-- :lua print(vim.fn.stdpath("cache") .. "/snacks/image")
					-- For me returns `~/.cache/neobean/snacks/image`
					-- Go 1 dir above and check `sudo du -sh ./* | sort -hr | head -n 5`
				},
			},
			-- 			dashboard = {
			-- 				enabled = vim.g.scrollback_mode ~= "neobean", -- Disable for scrollback_mode
			-- 				preset = {
			-- 					keys = {
			-- 						-- { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
			-- 						-- { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
			-- 						-- { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
			-- 						-- { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
			-- 						-- {
			-- 						--   icon = " ",
			-- 						--   key = "c",
			-- 						--   desc = "Config",
			-- 						--   action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
			-- 						-- },
			-- 						{
			-- 							icon = " ",
			-- 							key = "s",
			-- 							desc = "Restore Session",
			-- 							section = "session",
			-- 						},
			-- 						-- { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
			-- 						{
			-- 							icon = " ",
			-- 							key = "<esc>",
			-- 							desc = "Quit",
			-- 							action = ":qa",
			-- 						},
			-- 					},
			-- 					-- Font Name: ANSI Shadow
			-- 					-- https://patorjk.com/software/taag
			-- 					header = [[
			-- ███╗   ██╗███████╗ ██████╗ ██████╗ ███████╗ █████╗ ███╗   ██╗
			-- ████╗  ██║██╔════╝██╔═══██╗██╔══██╗██╔════╝██╔══██╗████╗  ██║
			-- ██╔██╗ ██║█████╗  ██║   ██║██████╔╝█████╗  ███████║██╔██╗ ██║
			-- ██║╚██╗██║██╔══╝  ██║   ██║██╔══██╗██╔══╝  ██╔══██║██║╚██╗██║
			-- ██║ ╚████║███████╗╚██████╔╝██████╔╝███████╗██║  ██║██║ ╚████║
			-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝
			--
			-- [Linkarzu.com]
			--         ]],
			-- 				},
			-- 			},
		},
	},
}
