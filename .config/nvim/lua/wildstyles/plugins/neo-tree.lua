-- Plugin which shows file tree in float window

return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		require("neo-tree").setup({
			enable_diagnostics = false,
			default_component_configs = {
				indent = {
					with_markers = true,
				},
				file_size = {
					enabled = false,
				},
				git_status = {
					symbols = {
						-- Change type
						added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
						modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
						deleted = "✖", -- this can only be used in the git_status source
						renamed = "󰁕", -- this can only be used in the git_status source
						-- Status type
						untracked = "",
						ignored = "",
						unstaged = "󰄱",
						staged = "",
						conflict = "",
					},
				},
			},
			window = {
				position = "float",
				width = 40,
				mappings = {
					["<esc>"] = {
						function(state)
							state.commands.close_window(state)

							state.commands.toggle_preview(state)
						end,
						desc = "Close Neo Tree",
					},
					["P"] = {
						"toggle_preview",
						config = {
							use_float = true,
							popup = {
								border = "double", -- nui border style: "single", "double", "rounded", "solid", "shadow" :contentReference[oaicite:0]{index=0}
								size = { width = 80, height = 20 },
								padding = { 0, 2, 0, 0 }, -- left gap, etc.
							},
						},
					},
					["<C-u>"] = {
						"scroll_preview",
						config = { direction = 10 },
					},
					["<C-d>"] = {
						"scroll_preview",
						config = { direction = -10 },
					},
				},
			},
			filesystem = {
				hijack_netrw_behavior = "disabled",
				bind_to_cwd = true,
				follow_current_file = { enabled = true },
				use_libuv_file_watcher = true,
			},

			event_handlers = {
				{
					event = "after_render",
					handler = function(state)
						if
							not require("neo-tree.sources.common.preview").is_active()
						then
							state.config = {
								use_float = true,
							}
							state.commands.toggle_preview(state)
						end
					end,
				},
			},
		})

		-- vim.keymap.set("n", "-", function()
		-- 	require("neo-tree.command").execute({
		-- 		toggle = true,
		-- 		reveal = true,
		-- 		position = "float",
		-- 	})
		-- end, { desc = "Open file explorer on current file" })

		vim.keymap.set("n", "<leader>ee", function()
			require("neo-tree.command").execute({
				toggle = true,
				position = "float",
			})
		end, { desc = "Open file explorer" })

		vim.keymap.set("n", "<leader>eg", function()
			require("neo-tree.command").execute({
				source = "git_status",
				toggle = true,
				reveal = true,
				position = "float",
			})
		end, { desc = "Open git file explorer" })

		-- TODO: highlight opened buffers
		vim.cmd("highlight NeoTreeDotfile guifg=#fff")
	end,
}
