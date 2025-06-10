return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		{
			"b0o/nvim-tree-preview.lua",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"3rd/image.nvim", -- Optional, for previewing images
			},
		},
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local nvimtree = require("nvim-tree")

		-- recommended settings from nvim-tree documentation
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		local function my_on_attach(bufnr)
			local api = require("nvim-tree.api")

			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end

			-- default mappings
			api.config.mappings.default_on_attach(bufnr)

			vim.keymap.set("n", "<esc>", api.tree.close, opts("Close"))

			local preview = require("nvim-tree-preview")

			preview.setup({
				min_width = 50,
				min_height = 45,
				max_width = 70,
				max_height = 50,
			})
			vim.keymap.set("n", "P", preview.watch, opts("Preview (Watch)"))
			-- vim.keymap.set("n", "<Esc>", preview.unwatch, opts("Close Preview/Unwatch"))
			vim.keymap.set("n", "<C-d>", function()
				return preview.scroll(4)
			end, opts("Scroll Down"))
			vim.keymap.set("n", "<C-u>", function()
				return preview.scroll(-4)
			end, opts("Scroll Up"))

			-- Option A: Smart tab behavior: Only preview files, expand/collapse directories (recommended)
			vim.keymap.set("n", "<Tab>", function()
				local ok, node = pcall(api.tree.get_node_under_cursor)
				if ok and node then
					if node.type == "directory" then
						api.node.open.edit()
					else
						preview.node(node, { toggle_focus = true })
					end
				end
			end, opts("Preview"))
		end

		nvimtree.setup({
			on_attach = my_on_attach,
			view = {
				width = 35,
				relativenumber = true,
				float = {
					enable = true,
					open_win_config = function()
						local screen_w = vim.opt.columns:get()
						local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
						local w_h = 60
						local s_h = 42
						local center_x = 16
						local center_y = ((vim.opt.lines:get() - s_h) / 5) - vim.opt.cmdheight:get()
						return {
							border = "rounded",
							relative = "editor",
							row = center_y,
							col = center_x,
							width = w_h,
							height = s_h,
						}
					end,
				},
			},
			-- change folder arrow icons
			renderer = {
				highlight_git = "name",
				highlight_opened_files = "name",
				indent_markers = {
					enable = true,
				},
				icons = {
					git_placement = "after",
					show = {
						git = false,
					},
					glyphs = {
						folder = {
							arrow_closed = "", -- arrow when folder is closed
							arrow_open = "", -- arrow when folder is open
						},
					},
				},
			},
			-- disable window_picker for
			-- explorer to work well with
			-- window splits
			actions = {
				open_file = {
					window_picker = {
						enable = false,
					},
				},
			},
			filters = {
				dotfiles = true,
				custom = { "node_modules", "\\.cache", ".git", "dist" },
			},
			live_filter = {
				always_show_folders = false,
			},
			git = {
				enable = true,
			},
		})

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<esc>", "<cmd>NvimTreeClose<CR>", { desc = "Close explorer" }) -- toggle file explorer
		keymap.set("n", "<leader>ee", function()
			local preview = require("nvim-tree-preview")
			vim.cmd("NvimTreeToggle") -- First action: Toggle NvimTree
			preview.watch() -- Second action: Call the `preview.watch` function
		end, { desc = "Toggle file explorer" }) -- toggle file explorer
		keymap.set("n", "<leader>ef", function()
			local preview = require("nvim-tree-preview")
			vim.cmd("NvimTreeFindFile") -- First action: Toggle NvimTree
			preview.watch() -- Second action: Call the `preview.watch` function
		end, { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
		keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
		keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer

		-- nvimtree.setup({
		-- 	filters = {
		-- 		dotfiles = true,
		-- 		custom = { "node_modules", "\\.cache", ".git", "dist" },
		-- 	},
		-- 	disable_netrw = true,
		-- 	hijack_netrw = true,
		-- 	hijack_cursor = true,
		-- 	hijack_unnamed_buffer_when_opening = false,
		-- 	log = {
		-- 		enable = true,
		-- 		truncate = true,
		-- 		types = {
		-- 			all = false,
		-- 			config = false,
		-- 			copy_paste = false,
		-- 			diagnostics = true,
		-- 			git = false,
		-- 			profile = false,
		-- 			watcher = true,
		-- 		},
		-- 	},
		-- 	view = {
		-- 		float = {
		-- 			enable = true,
		-- 			open_win_config = function()
		-- 				local screen_w = vim.opt.columns:get()
		-- 				local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
		-- 				local w_h = 70
		-- 				local s_h = 42
		-- 				local center_x = (screen_w - w_h) / 2
		-- 				local center_y = ((vim.opt.lines:get() - s_h) / 5) - vim.opt.cmdheight:get()
		-- 				return {
		-- 					border = "rounded",
		-- 					relative = "editor",
		-- 					row = center_y,
		-- 					col = center_x,
		-- 					width = w_h,
		-- 					height = s_h,
		-- 				}
		-- 			end,
		-- 		},
		-- 		width = function()
		-- 			return math.floor(vim.opt.columns:get() * 5)
		-- 		end,
		-- 	},
		--
		-- 	diagnostics = {
		-- 		enable = false,
		-- 		show_on_dirs = false,
		-- 		show_on_open_dirs = false,
		-- 		debounce_delay = 500,
		--
		-- 		severity = {
		-- 			min = vim.diagnostic.severity.HINT,
		-- 			max = vim.diagnostic.severity.ERROR,
		-- 		},
		-- 		icons = {
		-- 			hint = "H",
		-- 			info = "I",
		-- 			warning = "W",
		-- 			error = "E",
		-- 		},
		-- 	},
		-- 	git = {
		-- 		enable = true,
		-- 		ignore = true,
		-- 	},
		-- 	filesystem_watchers = {
		-- 		enable = true,
		-- 	},
		-- 	actions = {
		-- 		open_file = {
		-- 			resize_window = true,
		-- 		},
		-- 		remove_file = {
		-- 			close_window = true,
		-- 		},
		-- 		change_dir = {
		-- 			enable = true,
		-- 			global = true,
		-- 			restrict_above_cwd = false,
		-- 		},
		-- 	},
		-- 	renderer = {
		-- 		root_folder_label = true,
		-- 		highlight_git = true,
		-- 		highlight_opened_files = "none",
		-- 		special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md", "LICENSE", "Dockerfile" },
		--
		-- 		indent_markers = {
		-- 			enable = true,
		-- 			icons = {
		-- 				corner = "└",
		-- 				edge = "│",
		-- 				none = "",
		-- 			},
		-- 		},
		--
		-- 		icons = {
		-- 			git_placement = "after",
		-- 			modified_placement = "after",
		-- 			show = {
		-- 				file = false,
		-- 				folder = false,
		-- 				folder_arrow = false,
		-- 				git = true,
		-- 			},
		--
		-- 			glyphs = {
		-- 				default = "",
		-- 				symlink = "",
		-- 				folder = {
		-- 					default = "/",
		-- 					empty = "/",
		-- 					empty_open = "/",
		-- 					open = "/",
		-- 					symlink = "/",
		-- 					symlink_open = "/",
		-- 				},
		-- 				git = {
		-- 					unstaged = "[U]",
		-- 					staged = "[S]",
		-- 					unmerged = "[ ]",
		-- 					renamed = "[R]",
		-- 					untracked = "[?]",
		-- 					deleted = "[D]",
		-- 					ignored = "[I]",
		-- 				},
		-- 			},
		-- 		},
		-- 	},
		-- })
	end,
}
