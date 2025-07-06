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
config.macos_window_background_blur = 10

config.keys = {
  { key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize }, -- +10% :contentReference[oaicite:2]{index=2}
  { key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize }, -- –10%
  { key = "0", mods = "CTRL", action = wezterm.action.ResetFontSize }, -- back to 12.0pt
}

-- my coolnight colorscheme:
config.colors = {
  foreground = "#CBE0F0",
  background = "#011423",
  cursor_bg = "#47FF9C",
  cursor_border = "#47FF9C",
  cursor_fg = "#011423",
  selection_bg = "#033259",
  selection_fg = "#CBE0F0",
  ansi = { "#1a3a5e", "#ea4d44", "#88fbd2", "#fcf392", "#3674f0", "#be94e4", "#ec69cf", "#75f9a9" },
  brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
}

-- and finally, return the configuration to wezterm
return config
