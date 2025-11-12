-- function -- -t=lua
-- function -- -g *.{md,ts}
--
-- test -- --type ts
-- test -- -tts
-- test -- -g=dictionary/**/*.md -g=dictionary/**/*.ts
--
--

local trim = function(s)
	return s:gsub("^%s*(.-)%s*$", "%1")
end

local function splitStringByDelimiter(inputString)
	-- Use string.match to extract the first part before the delimiter
	local firstPart = inputString:match("([^%-]+)")

	if firstPart then
		return trim(firstPart)
	else
		return "" -- return an empty string if delimiter is not found
	end
end

-- https://github.com/folke/snacks.nvim/discussions/2374
-- https://github.com/ruicsh/nvim-config/blob/main/lua/plugins/snacks.picker.lua#L27
--
return {
	{
		"folke/snacks.nvim",
		keys = {

			{
				"<leader>fw",
				function()
					Snacks.picker.grep({
						finder = "grep",
						regex = false,
						args = { "--word-regexp" },
						format = "file",
						search = function(picker)
							return picker:word()
						end,
						live = false,
						supports_live = true,
					})
				end,
				desc = "Visual selection or word",
				mode = { "n", "x" },
			},

			{
				"<leader>fj",
				function()
					Snacks.picker.jumps({
						finder = "vim_jumps",
						format = "file",
						main = { current = true },
					})
				end,
				desc = "Find jumps",
			},

			{
				"<leader>fn",
				function()
					Snacks.picker.notifications()
				end,
				desc = "Notification History",
			},

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

			{
				"-",
				function()
					Snacks.explorer({
						layout = { preset = "default", preview = true },
						hidden = true,
						diagnostics = false,
						ignored = true,
						auto_close = true,
						on_change = function()
							vim.cmd.norm("$")
							vim.cmd.norm("zz")
						end,
						exclude = { "^.git/", "node_modules/", "build/" },
						-- include = { "hidden" },
					})
				end,
				desc = "File Explorer",
			},

			{
				"<leader>fh",
				function()
					Snacks.picker({
						finder = "git_log",
						format = "git_log",
						preview = "git_show",
						current_file = true,
						follow = true,
						confirm = "git_checkout",
						sort = { fields = { "score:desc", "idx" } },
					})
				end,
				desc = "Git history in file",
			},

			{
				"<leader>fg",
				function()
					Snacks.picker.git_diff({
						group = true,
						finder = "git_diff",
						format = "git_status",
						preview = "diff",
						matcher = { sort_empty = true },
						sort = { fields = { "score:desc", "file", "idx" } },
						win = {
							input = {
								keys = {
									["<Tab>"] = {
										"git_stage",
										mode = { "n", "i" },
									},
									["<c-r>"] = {
										"git_restore",
										mode = { "n", "i" },
										nowait = true,
									},
								},
							},
						},
					})
				end,
				desc = "Find String",
			},

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
						exclude = { "^.git/", "node_modules/", "build/" },
						show_empty = true,
						supports_live = true,
						layout = "telescope",
					})
				end,
				desc = "Find String",
			},

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

			{
				"<leader>f/",
				function()
					Snacks.picker.search_history({
						finder = "vim_history",
						format = "text",
						preview = "none",
						layout = { preset = "select" },
						confirm = "search",
						formatters = { text = { ft = "regex" } },
					})
				end,
				desc = "Search history in file",
			},

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

			{
				"h",
				function()
					Snacks.picker.buffers({
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
									["D"] = function()
										vim.api.nvim_command("%bdelete!")
									end,
									["d"] = "bufdelete",
								},
							},
							list = { keys = { ["d"] = "bufdelete" } },
						},
					})
				end,
				desc = "[P]Snacks picker buffers",
			},
		},
		opts = {
			picker = {
				actions = {
					["multi_grep"] = function(picker)
						local current = picker.input:get()
						picker.input:set("", current .. " -- -g=")
						picker:find({ refresh = true })
					end,
					---@param picker snacks.Picker
					choose_directory = function(picker)
						local cwd = vim.fn.getcwd()
						local dirs = {}
						local cmd = {
							"fd",
							"--type",
							"directory",
							"--hidden",
							"--no-ignore-vcs",
							"--exclude",
							".git",
							"--exclude",
							"node_modules",
						}

						vim.fn.jobstart(cmd, {
							on_stdout = function(_, data, _)
								for _, line in ipairs(data) do
									if line and line ~= "" then
										table.insert(dirs, line)
									end
								end
							end,
							on_exit = function(_, code, _)
								local items = {}
								for i, item in ipairs(dirs) do
									table.insert(items, {
										idx = i,
										file = item,
										text = item,
									})
								end

								Snacks.picker.pick({
									confirm = function(directory_picker, item)
										local selected =
											directory_picker:selected()
										local prev_search =
											splitStringByDelimiter(
												picker.input:get()
											)
										local search_patterns = ""
										local title = ""

										if #selected > 0 then
											for index, element in
												ipairs(selected)
											do
												title = title .. element.file
												if index < #selected then
													title = title .. ", "
												end

												if index == 1 then
													search_patterns = " -- "
												end

												search_patterns = search_patterns
													.. "-g="
													.. element.file
													.. "** "
											end
										end

										picker.title = title
										-- TODO: always exclude node_modules etc...
										picker.input:set(
											"",
											prev_search .. search_patterns
										)

										directory_picker:close()
										picker:find()
									end,
									title = "Grep in directory",
									-- multi = { "files" },
									main = { current = true },
									layout = {
										preview = false,
										preset = "vertical",
									},
									format = function(item, _)
										local file = item.file
										local ret = {}
										local a = Snacks.picker.util.align
										local icon, icon_hl = Snacks.util.icon(
											file.ft,
											"directory"
										)
										ret[#ret + 1] = { a(icon, 3), icon_hl }
										ret[#ret + 1] = { " " }
										local path = file:gsub(
											"^" .. vim.pesc(cwd) .. "/",
											""
										)
										ret[#ret + 1] =
											{ a(path, 20), "Directory" }

										return ret
									end,
									items = items,
								})
							end,
						})
					end,
					---@param picker snacks.Picker
					choose_history = function(picker)
						local history = picker.history.kv.data
						local items = {}

						for i = 1, #history do
							local hist = history[#history + 1 - i]
							table.insert(items, {
								idx = i,
								pattern = hist.pattern,
								search = hist.search,
								live = hist.live,
								text = hist.search .. " " .. hist.pattern,
							})
						end

						Snacks.picker.pick({
							title = "Picker history",
							items = items,
							main = { current = true }, -- NOTE: Prevent closing the parent picker
							layout = { preset = "select" },
							supports_live = false,
							transform = function(item)
								return not (
									item.pattern == "" and item.search == ""
								)
							end,
							format = function(item)
								local ico = {
									live = picker.opts.icons.ui.live,
									prompt = picker.opts.prompt,
								}
								local part1 = item.live and item.pattern
									or item.search
								local part2 = item.live and item.search
									or item.pattern
								--
								local text = {}
								table.insert(text, {
									item.live and ico.live or "  ",
									"Special",
								})
								table.insert(text, { " " })
								table.insert(
									text,
									{ part1, "SnacksPickerInputSearch" }
								)
								if part1 ~= "" and part2 ~= "" then
									table.insert(text, { " " })
									table.insert(
										text,
										{ ico.prompt, "SnacksPickerPrompt" }
									)
								end
								table.insert(text, { part2 })
								return text
							end,
							confirm = function(history_picker, item)
								local mode = vim.fn.mode()
								picker.opts.live = item.live
								vim.notify(
									tostring(item.pattern),
									tostring(item.search)
								)
								picker.input:set(item.pattern, item.search)
								print("Pattern: " .. tostring(item.pattern)) -- Check what item.pattern is
								print("Search: " .. tostring(item.search)) -- Check what item.search is
								history_picker:close()
								if mode == "i" then
                -- stylua: ignore
                vim.schedule(function() vim.cmd 'startinsert!' end)
								end
							end,
						})
					end,
				},
				debug = {
					scores = false, -- show scores in the list
				},
				previewers = {
					diff = {
						style = "syntax",
					},
				},
				sources = {
					grep = {
						preview = function(ctx)
							local res = Snacks.picker.preview.file(ctx)
							if ctx.item.file then
								ctx.picker.preview:set_title(ctx.item.file)
							end
							return res
						end,
					},
					files = {
						preview = function(ctx)
							local res = Snacks.picker.preview.file(ctx)
							if ctx.item.file then
								ctx.picker.preview:set_title(ctx.item.file)
							end
							return res
						end,
					},
				},
				layout = {
					preset = "telescope",
					cycle = true,
				},
				layouts = {
					default = {
						layout = {
							box = "horizontal",
							width = 0.95,
							min_width = 120,
							height = 0.9,
							{
								box = "vertical",
								border = true,
								title = "{title} {live} {flags}",
								{
									win = "input",
									height = 1,
									border = "bottom",
								},
								{ win = "list", border = "none" },
							},
							{
								win = "preview",
								title = "{preview}",
								border = true,
								width = 0.65,
							},
						},
					},

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
					preview = {
						keys = {
							["<C-right>"] = "focus_input",
						},
					},
					list = {
						keys = {
							["<C-d>"] = {
								"preview_scroll_down",
								mode = { "i", "n" },
							},
							["<C-u>"] = {
								"preview_scroll_up",
								mode = { "i", "n" },
							},
						},
					},
					input = {
						keys = {
							["<space><space>"] = {
								"multi_grep",
								desc = "Switch to smart",
								mode = { "n", "i" },
							},
							-- to close the picker on ESC instead of going to normal mode,
							-- add the following keymap to your config
							["<Esc>"] = { "close", mode = { "n", "i" } },
							["<C-d>"] = {
								"preview_scroll_down",
								mode = { "i", "n" },
							},
							["<C-u>"] = {
								"preview_scroll_up",
								mode = { "i", "n" },
							},
							["<C-h>"] = {
								"choose_history",
								mode = { "i", "n" },
							},
							["<C-f>"] = {
								"choose_directory",
								mode = { "i", "n" },
							},
							["<C-right>"] = { "cycle_win", mode = { "i", "n" } },
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
		},
	},
}
