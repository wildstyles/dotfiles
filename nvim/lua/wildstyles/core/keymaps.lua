vim.g.mapleader = ","
vim.g.maplocalleader = "'"
local keymap = vim.keymap -- for conciseness

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

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	callback = function(args)
		local bufnr = args.buf
		local bt = vim.bo[bufnr].buftype
		-- only in regular buffers (no quickfix, no terminal, no help, etc.)
		if bt == "" then
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

vim.api.nvim_set_keymap(
	"n",
	"<leader>gy",
	'<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
	{ silent = true, desc = "Open current line in browser" }
)
vim.api.nvim_set_keymap(
	"v",
	"<leader>gy",
	'<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
	{
		desc = "Open selected lines in browser",
	}
)

keymap.set("i", "nn", "<ESC>", { desc = "Exit insert mode with nn" })
keymap.set("n", "<leader>q", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "<C-q>", ":q!<CR>", { desc = "Quit" })
keymap.set("i", "<C-q>", "<Esc>:q!<CR>", { desc = "Quit" })
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
keymap.set("n", "<leader>n", "<cmd>bnext<CR>", { desc = "Go to next buffer" }) --  go to next buffer
keymap.set(
	"n",
	"<leader>N",
	"<cmd>bprevious<CR>",
	{ desc = "Go to previous buffer" }
) --  go to previous buffer
keymap.set(
	"n",
	"<leader>tf",
	"<cmd>tabnew %<CR>",
	{ desc = "Open current buffer in new tab" }
) --  move current buffer to new tab

keymap.set(
	"n",
	"h",
	"<cmd>Telescope buffers sort_mru=true sort_lastused=true initial_mode=normal<cr>",
	{ desc = "[P]Open telescope buffers" }
)

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
		chunk[has_untoggled_index] = removeLabel(chunk[has_untoggled_index]):gsub(
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
