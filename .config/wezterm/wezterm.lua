-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.window_padding = {
	left = 0,
	right = 0,
	top = 5,
	bottom = 0,
}

config.color_scheme = "Batman"

-- config.font = wezterm.font("MesloLGS Nerd Font Mono")
-- config.font = wezterm.font("Comic Code")
config.font = wezterm.font("mononoki")
config.font_size = 16

config.enable_tab_bar = false

config.window_decorations = "RESIZE"

config.window_background_opacity = 1
config.macos_window_background_blur = 1

local home_dir = os.getenv("HOME")
config.background = {

	{
		source = {
			File = home_dir .. "/Downloads/wezterm_bg.jpg", -- Updated path
		},
		opacity = 1,
		hsb = { brightness = 0.03 },
		height = "100%",
		width = "100%",
	},
}

-- shows how to send cmd modifier to nvim. Couldn't find a way how to make it
-- work with tmux
-- https://github.com/wezterm/wezterm/issues/3731#issuecomment-1592198263
config.keys = {
	{ key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize }, -- +10% :contentReference[oaicite:2]{index=2}
	{ key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize }, -- –10%
	{ key = "0", mods = "CTRL", action = wezterm.action.ResetFontSize }, -- back to 12.0pt
}

-- and finally, return the configuration to wezterm
return config
