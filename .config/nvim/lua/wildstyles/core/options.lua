-- vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt -- for conciseness
local api = vim.api

-- line numbers
opt.relativenumber = true -- show relative line numbers
-- shows absolute line number on cursor line (when relative number is on)
opt.number = true
vim.opt.signcolumn = "no"
vim.opt.numberwidth = 1

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = true
opt.textwidth = 80
-- Wrap at word boundaries rather than in the middle of a word
opt.linebreak = true

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
-- colorschemes that can be light or dark will be made dark
opt.background = "dark"
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

---------------------------------------------------------------
-- Autocloses nvim session if it's been inactive for 15 mins----
----------------------------------------------------------------
local inactivity_timer
local inactivity_limit = 15 * 60 * 1000 -- 15 minutes in milliseconds

-- Function to reset the inactivity timer
_G.reset_inactivity_timer = function()
	if inactivity_timer then
		inactivity_timer:stop()
		inactivity_timer:close()
	end

	inactivity_timer = vim.loop.new_timer()
	inactivity_timer:start(
		inactivity_limit,
		0,
		vim.schedule_wrap(function()
			api.nvim_command("qa!")
		end)
	)
end

-- Function to set up autocommands
local function setup_autocommands()
	-- Create a group for custom autocommands
	api.nvim_command("augroup InactivityAutoQuit")
	api.nvim_command("autocmd!")
	-- Reset timer on keypress, mouse click, or cursor movement
	api.nvim_command(
		"autocmd CursorHold,CursorMoved,TextChanged * lua _G.reset_inactivity_timer()"
	)
	api.nvim_command("augroup END")
end

setup_autocommands()
reset_inactivity_timer()
