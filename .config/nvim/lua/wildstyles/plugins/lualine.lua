return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")

		local conditions = {
			buffer_not_empty = function()
				return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
			end,
			buffer_empty = function()
				return vim.fn.empty(vim.fn.expand("%:t")) == 1
			end,
			hide_in_width = function()
				return vim.fn.winwidth(0) > 80
			end,
			check_git_workspace = function()
				local filepath = vim.fn.expand("%:p:h")
				local gitdir = vim.fn.finddir(".git", filepath .. ";")
				return gitdir and #gitdir > 0 and #gitdir < #filepath
			end,
			diff_mode = function()
				return vim.o.diff == true
			end,
		}

		local colors = {
			blue = "#65D1FF",
			green = "#3EFFDC",
			violet = "#FF61EF",
			yellow = "#FFDA7B",
			red = "#FF4A4A",
			fg = "#c3ccdc",
			-- bg = "#112638",
			bg = "None",
			inactive_bg = "#2c3043",
		}

		local my_lualine_theme = {
			normal = {
				a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			insert = {
				a = { bg = colors.green, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			visual = {
				a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			command = {
				a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			replace = {
				a = { bg = colors.red, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			inactive = {
				a = {
					bg = colors.inactive_bg,
					fg = colors.semilightgray,
					gui = "bold",
				},
				b = { bg = colors.inactive_bg, fg = colors.semilightgray },
				c = { bg = colors.inactive_bg, fg = colors.semilightgray },
			},
		}

		local config = {
			options = {
				theme = my_lualine_theme,
				component_separators = { right = "", left = "" },
				section_separators = { left = "", right = "" },
				globalstatus = true,
			},
			sections = {
				-- these are to remove the defaults
				lualine_b = {},
				lualine_y = {},
				-- These will be filled later
				lualine_c = {},
				lualine_x = {},
			},
			inactive_sections = {
				-- these are to remove the defaults
				lualine_b = {},
				lualine_y = {},
				lualine_c = {},
				lualine_x = {},
			},
		}

		local function insert_left(component)
			table.insert(config.sections.lualine_c, component)
		end

		local function insert_right(component)
			table.insert(config.sections.lualine_x, component)
		end

		insert_left({
			"branch",
			icon = "",
			fmt = function(name)
				if #name > 50 then
					return name:sub(1, 47) .. "..."
				end
				return name
			end,
			color = { fg = colors.fg, bg = colors.bg, gui = "bold" },
		})

		insert_left({
			"diff",
			symbols = { added = " ", modified = " ", removed = " " },
			diff_color = {
				added = { fg = colors.green },
				modified = { fg = colors.yellow },
				removed = { fg = colors.red },
			},
			cond = conditions.hide_in_width,
		})
		-- insert_left(custom_fname)

		insert_left({
			"filename",
			file_status = true,
			path = 1,
			symbols = {

				modified = " ●", -- Text to show when the buffer is modified
				alternate_file = "#", -- Text to show to identify the alternate file
				directory = "", -- Text to show when the buffer is a directory
			},
		})
		insert_right({
			"diagnostics",
			sources = { "nvim_diagnostic" },
			symbols = { error = " ", warn = " ", info = " " },
			diagnostics_color = {
				color_error = { fg = colors.red },
				color_warn = { fg = colors.yellow },
				color_info = { fg = colors.violet },
			},
		})

		insert_right({
			function()
				local buffer_count =
					tostring(vim.fn.len(vim.fn.getbufinfo({ buflisted = 1 })))

				return "(" .. buffer_count .. ")"
			end,
			color = { fg = colors.yellow },
		})
		insert_right({
			"filetype",
		})
		lualine.setup(config)
	end,
}
