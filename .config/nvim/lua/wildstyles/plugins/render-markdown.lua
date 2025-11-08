-- Filename: ~/github/dotfiles-latest/neovim/neobean/lua/plugins/render-markdown.lua
-- ~/github/dotfiles-latest/neovim/neobean/lua/plugins/render-markdown.lua

-- https://github.com/MeanderingProgrammer/markdown.nvim
--
-- When I hover over markdown headings, this plugins goes away, so I need to
-- edit the default highlights
-- I tried adding this as an autocommand, in the options.lua
-- file, also in the markdownl.lua file, but the highlights kept being overriden
-- so the only way I was able to make it work was loading it
-- after the config.lazy in the init.lua file lamw25wmal

return {
	"MeanderingProgrammer/render-markdown.nvim",
	enabled = true,
	-- Moved highlight creation out of opts as suggested by plugin maintainer
	-- There was no issue, but it was creating unnecessary noise when ran
	-- :checkhealth render-markdown
	-- https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/138#issuecomment-2295422741
	init = function()
		local linkarzu_color04 = "#987afb"
		local linkarzu_color02 = "#37f499"
		local linkarzu_color03 = "#04d1f9"
		local linkarzu_color01 = "#fca6ff"
		local linkarzu_color05 = "#9ad900"
		local linkarzu_color08 = "#e58f2a"
		local linkarzu_color06 = "#05ff23"

		local linkarzu_color18 = "#2d244b"
		local linkarzu_color19 = "#10492d"
		local linkarzu_color20 = "#013e4a"
		local linkarzu_color21 = "#4b314c"
		local linkarzu_color22 = "#1e2b00"
		local linkarzu_color23 = "#2d1c08"
		local linkarzu_color26 = "#0D1116"

		local color_fg = linkarzu_color26
		local colorInline_bg = linkarzu_color02

		local color1_bg = linkarzu_color04
		local color2_bg = linkarzu_color02
		local color3_bg = linkarzu_color03
		local color4_bg = linkarzu_color01
		local color5_bg = linkarzu_color05
		local color6_bg = linkarzu_color08

		local color_fg1 = linkarzu_color18
		local color_fg2 = linkarzu_color19
		local color_fg3 = linkarzu_color20
		local color_fg4 = linkarzu_color21
		local color_fg5 = linkarzu_color22
		local color_fg6 = linkarzu_color23

		-- Heading colors (when not hovered over), extends through the entire line
		vim.cmd(
			string.format(
				[[highlight Headline1Bg guibg=%s guifg=%s ]],
				color_fg1,
				color1_bg
			)
		)
		vim.cmd(
			string.format(
				[[highlight Headline2Bg guibg=%s guifg=%s ]],
				color_fg2,
				color2_bg
			)
		)
		vim.cmd(
			string.format(
				[[highlight Headline3Bg guibg=%s guifg=%s ]],
				color_fg3,
				color3_bg
			)
		)
		vim.cmd(
			string.format(
				[[highlight Headline4Bg guibg=%s guifg=%s ]],
				color_fg4,
				color4_bg
			)
		)
		vim.cmd(
			string.format(
				[[highlight Headline5Bg guibg=%s guifg=%s ]],
				color_fg5,
				color5_bg
			)
		)
		vim.cmd(
			string.format(
				[[highlight Headline6Bg guibg=%s guifg=%s ]],
				color_fg6,
				color6_bg
			)
		)
		-- Define inline code highlight for markdown
		vim.cmd(
			string.format(
				[[highlight RenderMarkdownCodeInline guifg=%s guibg=%s]],
				colorInline_bg,
				color_fg
			)
		)
		vim.cmd(
			string.format(
				[[highlight RenderMarkdownCode guifg=%s guibg=%s]],
				colorInline_bg,
				color_fg
			)
		)

		-- Highlight for the heading and sign icons (symbol on the left)
		-- I have the sign disabled for now, so this makes no effect
		vim.cmd(
			string.format(
				[[highlight Headline1Fg cterm=bold gui=bold guifg=%s]],
				color1_bg
			)
		)
		vim.cmd(
			string.format(
				[[highlight Headline2Fg cterm=bold gui=bold guifg=%s]],
				color2_bg
			)
		)
		vim.cmd(
			string.format(
				[[highlight Headline3Fg cterm=bold gui=bold guifg=%s]],
				color3_bg
			)
		)
		vim.cmd(
			string.format(
				[[highlight Headline4Fg cterm=bold gui=bold guifg=%s]],
				color4_bg
			)
		)
		vim.cmd(
			string.format(
				[[highlight Headline5Fg cterm=bold gui=bold guifg=%s]],
				color5_bg
			)
		)
		vim.cmd(
			string.format(
				[[highlight Headline6Fg cterm=bold gui=bold guifg=%s]],
				color6_bg
			)
		)
	end,
	opts = {
		bullet = {
			-- Turn on / off list bullet rendering
			enabled = true,
		},
		checkbox = {
			-- Turn on / off checkbox state rendering
			enabled = true,
			-- Determines how icons fill the available space:
			--  inline:  underlying text is concealed resulting in a left aligned icon
			--  overlay: result is left padded with spaces to hide any additional text
			position = "inline",
			unchecked = {
				-- Replaces '[ ]' of 'task_list_marker_unchecked'
				icon = "   󰄱 ",
				-- Highlight for the unchecked icon
				highlight = "RenderMarkdownUnchecked",
				-- Highlight for item associated with unchecked checkbox
				scope_highlight = nil,
			},
			checked = {
				-- Replaces '[x]' of 'task_list_marker_checked'
				icon = "   󰱒 ",
				-- Highlight for the checked icon
				highlight = "RenderMarkdownChecked",
				-- Highlight for item associated with checked checkbox
				scope_highlight = nil,
			},
		},
		html = {
			-- Turn on / off all HTML rendering
			enabled = true,
			comment = {
				-- Turn on / off HTML comment concealing
				conceal = false,
			},
		},
		-- Add custom icons lamw26wmal
		link = {
			image = vim.g.neovim_mode == "skitty" and "" or "󰥶 ",
			custom = {
				youtu = { pattern = "youtu%.be", icon = "󰗃 " },
			},
		},
		heading = {
			sign = false,
			icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
			backgrounds = {
				"Headline1Bg",
				"Headline2Bg",
				"Headline3Bg",
				"Headline4Bg",
				"Headline5Bg",
				"Headline6Bg",
			},
			foregrounds = {
				"Headline1Fg",
				"Headline2Fg",
				"Headline3Fg",
				"Headline4Fg",
				"Headline5Fg",
				"Headline6Fg",
			},
		},
		code = {
			-- if I'm not using yabai, I cannot make the color of the codeblocks
			-- transparent, so just disabling all rendering 😢
			-- style = "none",
			style = "language",
			-- with = "block",
		},
	},
}
