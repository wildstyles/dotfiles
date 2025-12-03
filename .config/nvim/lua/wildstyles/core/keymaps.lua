vim.g.mapleader = ","
vim.g.maplocalleader = "'"
local keymap = vim.keymap -- for conciseness

vim.g.scrollback = vim.env.SCROLLBACK or "disabled"

keymap.set("x", "p", [["_dP]], {
	noremap = true,
	silent = true,
	desc = "Paste without overwriting clipboard",
})

local opts = { noremap = true, silent = true }

keymap.set("n", "c", '"dc', opts)
keymap.set("x", "c", '"dc', opts)

keymap.set("n", "d", '"dd', opts)
keymap.set("x", "d", '"dd', opts)

-- 5) paste from register d
keymap.set("n", "<leader>p", '"dp', opts)

-- makes <c-u> in insert mode to behave the same as "u" in normal
vim.api.nvim_set_keymap(
	"i",
	"<C-u>",
	"<C-o>u",
	{ noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
	"i",
	"<C-b>",
	"<C-o>b",
	{ noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
	"i",
	"<C-e>",
	"<C-o>e<Right>",
	{ noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
	"i",
	"<C-left>",
	"<C-o>_",
	{ noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
	"i",
	"<C-right>",
	"<C-o>$",
	{ noremap = true, silent = true }
)

keymap.set("n", "<leader>ya", function()
	local filename = vim.fn.expand("%:p")
	vim.fn.setreg("+", filename)
	print("Copied filename to clipboard: " .. filename)
end, {
	desc = "Copy current buffer absolute file path",
	noremap = true,
	silent = true,
})

keymap.set("n", "<leader>yp", function()
	local root = vim.lsp.buf.list_workspace_folders()[1] or vim.fn.getcwd()
	local filename = vim.fn.expand("%:p")
	local relative_path = vim.fn.fnamemodify(filename, ":~:." .. root)

	vim.fn.setreg("+", relative_path) -- Copy relative path to clipboard
	vim.notify("Copied filename to clipboard: " .. relative_path)
end, {
	desc = "Copy current buffer file project path",
	noremap = true,
	silent = true,
})

keymap.set("n", "<leader>yn", function()
	local filename = vim.fn.expand("%:t")

	vim.fn.setreg("+", filename)

	print("Copied filename to clipboard: " .. filename)
end, { noremap = true, silent = true, desc = "Copy current buffer file name" })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	callback = function(args)
		local bufnr = args.buf
		local bt = vim.bo[bufnr].buftype
		local ft = vim.bo[bufnr].filetype -- Get the file type of the buffer
		-- only in regular buffers (no quickfix, no terminal, no help, etc.)
		if bt == "" and ft ~= "http" then
			vim.keymap.set(
				"n",
				"<CR>",
				"<Esc>o<Esc>",
				{ buffer = bufnr, desc = "Insert blank line below" }
			)
		end
	end,
})
-- Remove the blank‐line <CR> mapping in quickfix windows
vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	callback = function()
		-- delete the buffer-local <CR> mapping in normal mode
		vim.keymap.del("n", "<CR>", { buffer = true })
		-- (optional) restore default: jump to entry
		vim.keymap.set("n", "<CR>", "<CR>", { buffer = true })
	end,
})

keymap.set("n", "<Space>", "a <Esc>", { desc = "Insert space at cursor" })

-- keymap.set("n", "kk", function()
-- 	local tabs = vim.api.nvim_list_tabpages()
--
-- 	for _, tab in ipairs(tabs) do
-- 		local windows = vim.api.nvim_tabpage_list_wins(tab)
--
-- 		for _, win in ipairs(windows) do
-- 			local bufnr = vim.api.nvim_win_get_buf(win)
-- 			local bufnr_name = vim.api.nvim_buf_get_name(bufnr)
--
-- 			if bufnr_name:match("http") then
-- 				-- Switch to the current tab
-- 				vim.api.nvim_set_current_tabpage(tab)
-- 			end
-- 		end
-- 	end
--
-- 	require("kulala").replay()
-- end, { desc = "Replay last request" })

-- keymap.set("i", "nn", "<ESC>", { desc = "Exit insert mode with nn" })
keymap.set("n", "<leader>q", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "<C-q>", ":qa!<CR>", { desc = "Quit" })
keymap.set("i", "<C-q>", "<Esc>:qa!<CR>", { desc = "Quit" })
keymap.set("n", "<C-s>", ":<c-u>update<cr>", { desc = "Save file" })
keymap.set(
	"i",
	"<C-s>",
	"<Esc>:update<cr>",
	{ desc = "Save file and exit insert mode" }
) -- Insert mode save and exit to normal mode
-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set(
	"n",
	"<leader>sx",
	"<cmd>close<CR>",
	{ desc = "Close current split" }
) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set(
	"n",
	"<leader>tn",
	"<cmd>tabnext<CR>",
	{ desc = "Navigate to next tab" }
)
keymap.set(
	"n",
	"<leader>tt",
	"<cmd>tabnext<CR>",
	{ desc = "Navigate to next tab" }
)
keymap.set(
	"n",
	"<leader>tN",
	"<cmd>tabprevious<CR>",
	{ desc = "Navigate to prev tab" }
)
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close tab" })

keymap.set("n", "X", "<cmd>bd<CR>", { desc = "Close current buffer" }) -- close current buffer
-- keymap.set("n", "<leader>n", "<cmd>bnext<CR>", { desc = "Go to next buffer" }) --  go to next buffer
-- keymap.set(
-- 	"n",
-- 	"<leader>N",
-- 	"<cmd>bprevious<CR>",
-- 	{ desc = "Go to previous buffer" }
-- ) --  go to previous buffer
keymap.set(
	"n",
	"<leader>tf",
	"<cmd>tabnew %<CR>",
	{ desc = "Open current buffer in new tab" }
) --  move current buffer to new tab

vim.keymap.set(
	"v",
	"<leader>cc",
	"y<esc>oconsole.log('<C-r>\":', <C-r>\");<esc>",
	{ noremap = true, silent = true }
)

-- clears all a–z, 0–9 and common special registers, plus search & cmdline
local function clear_all_registers()
	local regs =
		vim.fn.split('abcdefghijklmnopqrstuvwxyz0123456789*+-/#"=', "\\zs")
	for _, r in ipairs(regs) do
		vim.fn.setreg(r, {})
	end
	-- clear search and command‐line registers
	vim.fn.setreg("/", "")
	print("» All registers cleared")
end

-- bind <leader>cr to that function
vim.keymap.set(
	"n",
	"<leader>cr",
	clear_all_registers,
	{ desc = "Clear all registers" }
)

-- I have <C-i> mapped to next tab in terminal. This remap exists
-- to avoid conflict
vim.keymap.set("n", "<C-S-i>", "<C-i>")

-- If there is no `untoggled` or `done` label on an item, mark it as done
-- and move it to the "## completed tasks" markdown heading in the same file, if
-- the heading does not exist, it will be created, if it exists, items will be
-- appended to it at the top lamw25wmal
--
-- If an item is moved to that heading, it will be added the `done` label
vim.keymap.set("n", "<C-x>", function()
	-- Customizable variables
	-- NOTE: Customize the completion label
	local label_done = "done:"
	-- NOTE: Customize the timestamp format
	local timestamp = os.date("%y%m%d-%H%M")
	-- local timestamp = os.date("%y%m%d")
	-- NOTE: Customize the heading and its level
	local tasks_heading = "## Completed tasks"
	-- Save the view to preserve folds
	vim.cmd("mkview")
	local api = vim.api
	-- Retrieve buffer & lines
	local buf = api.nvim_get_current_buf()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local start_line = cursor_pos[1] - 1
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local total_lines = #lines
	-- If cursor is beyond last line, do nothing
	if start_line >= total_lines then
		vim.cmd("loadview")
		return
	end
	------------------------------------------------------------------------------
	-- (A) Move upwards to find the bullet line (if user is somewhere in the chunk)
	------------------------------------------------------------------------------
	while start_line > 0 do
		local line_text = lines[start_line + 1]
		-- Stop if we find a blank line or a bullet line
		if line_text == "" or line_text:match("^%s*%-") then
			break
		end
		start_line = start_line - 1
	end
	-- Now we might be on a blank line or a bullet line
	if lines[start_line + 1] == "" and start_line < (total_lines - 1) then
		start_line = start_line + 1
	end
	------------------------------------------------------------------------------
	-- (B) Validate that it's actually a task bullet, i.e. '- [ ]' or '- [x]'
	------------------------------------------------------------------------------
	local bullet_line = lines[start_line + 1]
	if not bullet_line:match("^%s*%- %[[x ]%]") then
		-- Not a task bullet => show a message and return
		print("Not a task bullet: no action taken.")
		vim.cmd("loadview")
		return
	end
	------------------------------------------------------------------------------
	-- 1. Identify the chunk boundaries
	------------------------------------------------------------------------------
	local chunk_start = start_line
	local chunk_end = start_line
	while chunk_end + 1 < total_lines do
		local next_line = lines[chunk_end + 2]
		if next_line == "" or next_line:match("^%s*%-") then
			break
		end
		chunk_end = chunk_end + 1
	end
	-- Collect the chunk lines
	local chunk = {}
	for i = chunk_start, chunk_end do
		table.insert(chunk, lines[i + 1])
	end
	------------------------------------------------------------------------------
	-- 2. Check if chunk has [done: ...] or [untoggled], then transform them
	------------------------------------------------------------------------------
	local has_done_index = nil
	local has_untoggled_index = nil
	for i, line in ipairs(chunk) do
		-- Replace `[done: ...]` -> `` `done: ...` ``
		chunk[i] = line:gsub("%[done:([^%]]+)%]", "`" .. label_done .. "%1`")
		-- Replace `[untoggled]` -> `` `untoggled` ``
		chunk[i] = chunk[i]:gsub("%[untoggled%]", "`untoggled`")
		if chunk[i]:match("`" .. label_done .. ".-`") then
			has_done_index = i
			break
		end
	end
	if not has_done_index then
		for i, line in ipairs(chunk) do
			if line:match("`untoggled`") then
				has_untoggled_index = i
				break
			end
		end
	end
	------------------------------------------------------------------------------
	-- 3. Helpers to toggle bullet
	------------------------------------------------------------------------------
	-- Convert '- [ ]' to '- [x]'
	local function bulletToX(line)
		return line:gsub("^(%s*%- )%[%s*%]", "%1[x]")
	end
	-- Convert '- [x]' to '- [ ]'
	local function bulletToBlank(line)
		return line:gsub("^(%s*%- )%[x%]", "%1[ ]")
	end
	------------------------------------------------------------------------------
	-- 4. Insert or remove label *after* the bracket
	------------------------------------------------------------------------------
	local function insertLabelAfterBracket(line, label)
		local prefix = line:match("^(%s*%- %[[x ]%])")
		if not prefix then
			return line
		end
		local rest = line:sub(#prefix + 1)
		return prefix .. " " .. label .. rest
	end
	local function removeLabel(line)
		-- If there's a label (like `` `done: ...` `` or `` `untoggled` ``) right after
		-- '- [x]' or '- [ ]', remove it
		return line:gsub("^(%s*%- %[[x ]%])%s+`.-`", "%1")
	end
	------------------------------------------------------------------------------
	-- 5. Update the buffer with new chunk lines (in place)
	------------------------------------------------------------------------------
	local function updateBufferWithChunk(new_chunk)
		for idx = chunk_start, chunk_end do
			lines[idx + 1] = new_chunk[idx - chunk_start + 1]
		end
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	end
	------------------------------------------------------------------------------
	-- 6. Main toggle logic
	------------------------------------------------------------------------------
	if has_done_index then
		chunk[has_done_index] = removeLabel(chunk[has_done_index]):gsub(
			"`" .. label_done .. ".-`",
			"`untoggled`"
		)
		chunk[1] = bulletToBlank(chunk[1])
		chunk[1] = removeLabel(chunk[1])
		chunk[1] = insertLabelAfterBracket(chunk[1], "`untoggled`")
		updateBufferWithChunk(chunk)
		vim.notify("Untoggled", vim.log.levels.INFO)
	elseif has_untoggled_index then
		chunk[has_untoggled_index] =
			removeLabel(chunk[has_untoggled_index]):gsub(
				"`untoggled`",
				"`" .. label_done .. " " .. timestamp .. "`"
			)
		chunk[1] = bulletToX(chunk[1])
		chunk[1] = removeLabel(chunk[1])
		chunk[1] = insertLabelAfterBracket(
			chunk[1],
			"`" .. label_done .. " " .. timestamp .. "`"
		)
		updateBufferWithChunk(chunk)
		vim.notify("Completed", vim.log.levels.INFO)
	else
		-- Save original window view before modifications
		local win = api.nvim_get_current_win()
		local view = api.nvim_win_call(win, function()
			return vim.fn.winsaveview()
		end)
		chunk[1] = bulletToX(chunk[1])
		chunk[1] = insertLabelAfterBracket(
			chunk[1],
			"`" .. label_done .. " " .. timestamp .. "`"
		)
		-- Remove chunk from the original lines
		for i = chunk_end, chunk_start, -1 do
			table.remove(lines, i + 1)
		end
		-- Append chunk under 'tasks_heading'
		local heading_index = nil
		for i, line in ipairs(lines) do
			if line:match("^" .. tasks_heading) then
				heading_index = i
				break
			end
		end
		if heading_index then
			for _, cLine in ipairs(chunk) do
				table.insert(lines, heading_index + 1, cLine)
				heading_index = heading_index + 1
			end
			-- Remove any blank line right after newly inserted chunk
			local after_last_item = heading_index + 1
			if lines[after_last_item] == "" then
				table.remove(lines, after_last_item)
			end
		else
			table.insert(lines, tasks_heading)
			for _, cLine in ipairs(chunk) do
				table.insert(lines, cLine)
			end
			local after_last_item = #lines + 1
			if lines[after_last_item] == "" then
				table.remove(lines, after_last_item)
			end
		end
		-- Update buffer content
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
		vim.notify("Completed", vim.log.levels.INFO)
		-- Restore window view to preserve scroll position
		api.nvim_win_call(win, function()
			vim.fn.winrestview(view)
		end)
	end
	-- Write changes and restore view to preserve folds
	-- "Update" saves only if the buffer has been modified since the last save
	vim.cmd("silent update")
	vim.cmd("loadview")
end, { desc = "[P]Toggle task and move it to 'done'" })

vim.keymap.set({ "n", "i" }, "<C-n>", function()
	-- Get the current line/row/column
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local row, _ = cursor_pos[1], cursor_pos[2]
	local line = vim.api.nvim_get_current_line()
	-- 1) If line is empty => replace it with "- [ ] " and set cursor after the brackets
	if line:match("^%s*$") then
		local final_line = "- [ ] "
		vim.api.nvim_set_current_line(final_line)
		-- "- [ ] " is 6 characters, so cursor col = 6 places you *after* that space
		vim.api.nvim_win_set_cursor(0, { row, 6 })
		return
	end
	-- 2) Check if line already has a bullet with possible indentation: e.g. "  - Something"
	--    We'll capture "  -" (including trailing spaces) as `bullet` plus the rest as `text`.
	local bullet, text = line:match("^([%s]*[-*]%s+)(.*)$")
	if bullet then
		-- Convert bullet => bullet .. "[ ] " .. text
		local final_line = bullet .. "[ ] " .. text
		vim.api.nvim_set_current_line(final_line)
		-- Place the cursor right after "[ ] "
		-- bullet length + "[ ] " is bullet_len + 4 characters,
		-- but bullet has trailing spaces, so #bullet includes those.
		local bullet_len = #bullet
		-- We want to land after the brackets (four characters: `[ ] `),
		-- so col = bullet_len + 4 (0-based).
		vim.api.nvim_win_set_cursor(0, { row, bullet_len + 4 })
		return
	end
	-- 3) If there's text, but no bullet => prepend "- [ ] "
	--    and place cursor after the brackets
	local final_line = "- [ ] " .. line
	vim.api.nvim_set_current_line(final_line)
	-- "- [ ] " is 6 characters
	vim.api.nvim_win_set_cursor(0, { row, 6 })
end, { desc = "Convert bullet to a task or insert new task bullet" })

-------------------------------------------------------------------------------
--                           Folding section
-------------------------------------------------------------------------------

-- This surrounds with inline code, that I use a lot lamw25wmal
vim.keymap.set("v", "<leader>mc", function()
	-- Use nvim_replace_termcodes to handle special characters like backticks
	local keys = vim.api.nvim_replace_termcodes("gsa`", true, false, true)
	-- Feed the keys in visual mode ('x' for visual mode)
	vim.api.nvim_feedkeys(keys, "x", false)
	-- I tried these 3, but they didn't work, I assume because of the backtick character
	-- vim.cmd("normal! gsa`")
	-- vim.cmd([[normal! gsa`]])
	-- vim.cmd("normal! gsa\\`")
end, { desc = "[P] Surround selection with backticks (inline code)" })

-- In visual mode, check if the selected text is already bold and show a message if it is
-- If not, surround it with double asterisks for bold
vim.keymap.set("v", "<leader>mb", function()
	-- Get the selected text range
	local start_row, start_col = unpack(vim.fn.getpos("'<"), 2, 3)
	local end_row, end_col = unpack(vim.fn.getpos("'>"), 2, 3)
	-- Get the selected lines
	local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
	local selected_text =
		table.concat(lines, "\n"):sub(start_col, #lines == 1 and end_col or -1)
	if selected_text:match("^%*%*.*%*%*$") then
		vim.notify("Text already bold", vim.log.levels.INFO)
	else
		vim.cmd("normal 2gsa*")
	end
end, { desc = "[P]BOLD current selection" })

-- -- Multiline unbold attempt
-- -- In normal mode, bold the current word under the cursor
-- -- If already bold, it will unbold the word under the cursor
-- -- If you're in a multiline bold, it will unbold it only if you're on the
-- -- first line
vim.keymap.set("n", "<leader>mb", function()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local current_buffer = vim.api.nvim_get_current_buf()
	local start_row = cursor_pos[1] - 1
	local col = cursor_pos[2]
	-- Get the current line
	local line = vim.api.nvim_buf_get_lines(
		current_buffer,
		start_row,
		start_row + 1,
		false
	)[1]
	-- Check if the cursor is on an asterisk
	if line:sub(col + 1, col + 1):match("%*") then
		vim.notify(
			"Cursor is on an asterisk, run inside the bold text",
			vim.log.levels.WARN
		)
		return
	end
	-- Search for '**' to the left of the cursor position
	local left_text = line:sub(1, col)
	local bold_start = left_text:reverse():find("%*%*")
	if bold_start then
		bold_start = col - bold_start
	end
	-- Search for '**' to the right of the cursor position and in following lines
	local right_text = line:sub(col + 1)
	local bold_end = right_text:find("%*%*")
	local end_row = start_row
	while
		not bold_end
		and end_row < vim.api.nvim_buf_line_count(current_buffer) - 1
	do
		end_row = end_row + 1
		local next_line = vim.api.nvim_buf_get_lines(
			current_buffer,
			end_row,
			end_row + 1,
			false
		)[1]
		if next_line == "" then
			break
		end
		right_text = right_text .. "\n" .. next_line
		bold_end = right_text:find("%*%*")
	end
	if bold_end then
		bold_end = col + bold_end
	end
	-- Remove '**' markers if found, otherwise bold the word
	if bold_start and bold_end then
		-- Extract lines
		local text_lines = vim.api.nvim_buf_get_lines(
			current_buffer,
			start_row,
			end_row + 1,
			false
		)
		local text = table.concat(text_lines, "\n")
		-- Calculate positions to correctly remove '**'
		-- vim.notify("bold_start: " .. bold_start .. ", bold_end: " .. bold_end)
		local new_text = text:sub(1, bold_start - 1)
			.. text:sub(bold_start + 2, bold_end - 1)
			.. text:sub(bold_end + 2)
		local new_lines = vim.split(new_text, "\n")
		-- Set new lines in buffer
		vim.api.nvim_buf_set_lines(
			current_buffer,
			start_row,
			end_row + 1,
			false,
			new_lines
		)
		-- vim.notify("Unbolded text", vim.log.levels.INFO)
	else
		-- Bold the word at the cursor position if no bold markers are found
		local before = line:sub(1, col)
		local after = line:sub(col + 1)
		local inside_surround = before:match("%*%*[^%*]*$")
			and after:match("^[^%*]*%*%*")
		if inside_surround then
			vim.cmd("normal gsd*.")
		else
			vim.cmd("normal viw")
			vim.cmd("normal 2gsa*")
		end
		vim.notify("Bolded current word", vim.log.levels.INFO)
	end
end, { desc = "[P]BOLD toggle bold markers" })

vim.keymap.set("n", "<leader>md", function()
	-- Get the current cursor position
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local current_buffer = vim.api.nvim_get_current_buf()
	local start_row = cursor_pos[1] - 1
	local col = cursor_pos[2]
	-- Get the current line
	local line = vim.api.nvim_buf_get_lines(
		current_buffer,
		start_row,
		start_row + 1,
		false
	)[1]
	-- Check if the line already starts with a bullet point
	if line:match("^%s*%-") then
		-- Remove the bullet point from the start of the line
		line = line:gsub("^%s*%-", "")
		vim.api.nvim_buf_set_lines(
			current_buffer,
			start_row,
			start_row + 1,
			false,
			{ line }
		)
		return
	end
	-- Search for newline to the left of the cursor position
	local left_text = line:sub(1, col)
	local bullet_start = left_text:reverse():find("\n")
	if bullet_start then
		bullet_start = col - bullet_start
	end
	-- Search for newline to the right of the cursor position and in following lines
	local right_text = line:sub(col + 1)
	local bullet_end = right_text:find("\n")
	local end_row = start_row
	while
		not bullet_end
		and end_row < vim.api.nvim_buf_line_count(current_buffer) - 1
	do
		end_row = end_row + 1
		local next_line = vim.api.nvim_buf_get_lines(
			current_buffer,
			end_row,
			end_row + 1,
			false
		)[1]
		if next_line == "" then
			break
		end
		right_text = right_text .. "\n" .. next_line
		bullet_end = right_text:find("\n")
	end
	if bullet_end then
		bullet_end = col + bullet_end
	end
	-- Extract lines
	local text_lines = vim.api.nvim_buf_get_lines(
		current_buffer,
		start_row,
		end_row + 1,
		false
	)
	local text = table.concat(text_lines, "\n")
	-- Add bullet point at the start of the text
	local new_text = "- " .. text
	local new_lines = vim.split(new_text, "\n")
	-- Set new lines in buffer
	vim.api.nvim_buf_set_lines(
		current_buffer,
		start_row,
		end_row + 1,
		false,
		new_lines
	)
end, { desc = "[P]Toggle bullet point (dash)" })

-- Checks each line to see if it matches a markdown heading (#, ##, etc.):
-- It’s called implicitly by Neovim’s folding engine by vim.opt_local.foldexpr
function _G.markdown_foldexpr()
	local lnum = vim.v.lnum
	local line = vim.fn.getline(lnum)
	local heading = line:match("^(#+)%s")
	if heading then
		local level = #heading
		if level == 1 then
			-- Special handling for H1
			if lnum == 1 then
				return ">1"
			else
				local frontmatter_end = vim.b.frontmatter_end
				if frontmatter_end and (lnum == frontmatter_end + 1) then
					return ">1"
				end
			end
		elseif level >= 2 and level <= 6 then
			-- Regular handling for H2-H6
			return ">" .. level
		end
	end
	return "="
end

local function set_markdown_folding()
	vim.opt_local.foldmethod = "expr"
	vim.opt_local.foldexpr = "v:lua.markdown_foldexpr()"
	vim.opt_local.foldlevel = 99

	-- Detect frontmatter closing line
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local found_first = false
	local frontmatter_end = nil
	for i, line in ipairs(lines) do
		if line == "---" then
			if not found_first then
				found_first = true
			else
				frontmatter_end = i
				break
			end
		end
	end
	vim.b.frontmatter_end = frontmatter_end
end

-- Use autocommand to apply only to markdown files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = set_markdown_folding,
})

-- Function to fold all headings of a specific level
local function fold_headings_of_level(level)
	-- Move to the top of the file without adding to jumplist
	vim.cmd("keepjumps normal! gg")
	-- Get the total number of lines
	local total_lines = vim.fn.line("$")
	for line = 1, total_lines do
		-- Get the content of the current line
		local line_content = vim.fn.getline(line)
		-- "^" -> Ensures the match is at the start of the line
		-- string.rep("#", level) -> Creates a string with 'level' number of "#" characters
		-- "%s" -> Matches any whitespace character after the "#" characters
		-- So this will match `## `, `### `, `#### ` for example, which are markdown headings
		if line_content:match("^" .. string.rep("#", level) .. "%s") then
			-- Move the cursor to the current line without adding to jumplist
			vim.cmd(string.format("keepjumps call cursor(%d, 1)", line))
			-- Check if the current line has a fold level > 0
			local current_foldlevel = vim.fn.foldlevel(line)
			if current_foldlevel > 0 then
				-- Fold the heading if it matches the level
				if vim.fn.foldclosed(line) == -1 then
					vim.cmd("normal! za")
				end
				-- else
				--   vim.notify("No fold at line " .. line, vim.log.levels.WARN)
			end
		end
	end
end

local function fold_markdown_headings(levels)
	-- I save the view to know where to jump back after folding
	local saved_view = vim.fn.winsaveview()
	for _, level in ipairs(levels) do
		fold_headings_of_level(level)
	end
	vim.cmd("nohlsearch")
	-- Restore the view to jump to where I was
	vim.fn.winrestview(saved_view)
end

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 1 or above
vim.keymap.set("n", "<leader>m1", function()
	-- "Update" saves only if the buffer has been modified since the last save
	vim.cmd("silent update")
	-- vim.keymap.set("n", "<leader>mfj", function()
	-- Reloads the file to refresh folds, otheriise you have to re-open neovim
	vim.cmd("edit!")
	-- Unfold everything first or I had issues
	vim.cmd("normal! zR")
	fold_markdown_headings({ 6, 5, 4, 3, 2, 1 })
	-- vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 1 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 2 or above
-- I know, it reads like "madafaka" but "k" for me means "2"
vim.keymap.set("n", "<leader>m2", function()
	-- "Update" saves only if the buffer has been modified since the last save
	vim.cmd("silent update")
	-- vim.keymap.set("n", "<leader>mfk", function()
	-- Reloads the file to refresh folds, otherwise you have to re-open neovim
	vim.cmd("edit!")
	-- Unfold everything first or I had issues
	vim.cmd("normal! zR")
	fold_markdown_headings({ 6, 5, 4, 3, 2 })
	-- vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 2 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 3 or above
vim.keymap.set("n", "<leader>m3", function()
	-- "Update" saves only if the buffer has been modified since the last save
	vim.cmd("silent update")
	-- vim.keymap.set("n", "<leader>mfl", function()
	-- Reloads the file to refresh folds, otherwise you have to re-open neovim
	vim.cmd("edit!")
	-- Unfold everything first or I had issues
	vim.cmd("normal! zR")
	fold_markdown_headings({ 6, 5, 4, 3 })
	vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 3 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 4 or above
vim.keymap.set("n", "<leader>m4", function()
	-- "Update" saves only if the buffer has been modified since the last save
	vim.cmd("silent update")
	-- vim.keymap.set("n", "<leader>mf;", function()
	-- Reloads the file to refresh folds, otherwise you have to re-open neovim
	vim.cmd("edit!")
	-- Unfold everything first or I had issues
	vim.cmd("normal! zR")
	fold_markdown_headings({ 6, 5, 4 })
	vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 4 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Use <CR> to fold when in normal mode
-- To see help about folds use `:help fold`
vim.keymap.set("n", "<CR>", function()
	-- Get the current line number
	local line = vim.fn.line(".")
	-- Get the fold level of the current line
	local foldlevel = vim.fn.foldlevel(line)
	if foldlevel == 0 then
		vim.notify("No fold found", vim.log.levels.INFO)
	else
		vim.cmd("normal! za")
		vim.cmd("normal! zz") -- center the cursor line on screen
	end
end, { desc = "[P]Toggle fold" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for unfolding markdown headings of level 2 or above
-- Changed all the markdown folding and unfolding keymaps from <leader>mfj to
-- zj, zk, zl, z; and zu respectively lamw25wmal
vim.keymap.set("n", "<leader>mu", function()
	-- "Update" saves only if the buffer has been modified since the last save
	vim.cmd("silent update")
	-- vim.keymap.set("n", "<leader>mfu", function()
	-- Reloads the file to reflect the changes
	vim.cmd("edit!")
	vim.cmd("normal! zR") -- Unfold all headings
	vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Unfold all headings level 2 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- gk jummps to the markdown heading above and then folds it
-- zi by default toggles folding, but I don't need it lamw25wmal
vim.keymap.set("n", "<leader>mf", function()
	-- "Update" saves only if the buffer has been modified since the last save
	vim.cmd("silent update")
	-- Difference between normal and normal!
	-- - `normal` executes the command and respects any mappings that might be defined.
	-- - `normal!` executes the command in a "raw" mode, ignoring any mappings.
	vim.cmd("normal gk")
	-- This is to fold the line under the cursor
	vim.cmd("normal! za")
	vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold the heading cursor currently on" })

-------------------------------------------------------------------------------
--                         End Folding section
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--                         Start Open in Browser section
-------------------------------------------------------------------------------
local function get_github_url_of_current_file()
	local file_path = vim.fn.expand("%:p")
	local current_line = vim.fn.line(".")

	local start_line = vim.fn.line("v") -- Start line from visual mode selection
	local end_line = vim.fn.line(".") -- End line (where the cursor is)

	if file_path == "" then
		vim.notify("No file is currently open", vim.log.levels.WARN)
		return nil
	end

	local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	if not git_root or git_root == "" then
		vim.notify(
			"Could not determine the root directory for the GitHub repository",
			vim.log.levels.WARN
		)
		return nil
	end

	local origin_url =
		vim.fn.systemlist("git config --get remote.origin.url")[1]
	if not origin_url or origin_url == "" then
		vim.notify(
			"Could not determine the origin URL for the GitHub repository",
			vim.log.levels.WARN
		)
		return nil
	end

	local branch_name = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")[1]
	if not branch_name or branch_name == "" then
		vim.notify(
			"Could not determine the current branch name",
			vim.log.levels.WARN
		)
		return nil
	end

	local repo_url = origin_url
		:gsub("git@github.com[^:]*:", "https://github.com/")
		:gsub("git@gitlab.com[^:]*:", "https://gitlab.com/")
		:gsub("%.git$", "")

	local relative_path = file_path:sub(#git_root + 2)
	return repo_url
		.. "/blob/"
		.. branch_name
		.. "/"
		.. relative_path
		.. "#L"
		.. start_line
		.. "-L"
		.. end_line
end

-- Open current file's GitHub repo link lamw25wmal
vim.keymap.set({ "n", "v" }, "<leader>gy", function()
	local github_url = get_github_url_of_current_file()
	if github_url then
		local command = "open " .. vim.fn.shellescape(github_url)
		vim.fn.system(command)
		print("Opened GitHub link: " .. github_url)
	end
end, { desc = "[P]Open current file's in repo link" })
-------------------------------------------------------------------------------
--                         End Open in Browser section
-------------------------------------------------------------------------------
