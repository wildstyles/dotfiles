vim.g.mapleader = ","
vim.g.maplocalleader = "."
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
			vim.keymap.set("n", "<CR>", "<Esc>o<Esc>", { buffer = bufnr, desc = "Insert blank line below" })
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

keymap.set("i", "nn", "<ESC>", { desc = "Exit insert mode with nn" })
keymap.set("n", "<leader>q", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "<C-q>", ":q!<CR>", { desc = "Quit" })
keymap.set("i", "<C-q>", "<Esc>:q!<CR>", { desc = "Quit" })
keymap.set("n", "<C-s>", ":<c-u>update<cr>", { desc = "Save file" })
keymap.set("i", "<C-s>", "<Esc>:update<cr>", { desc = "Save file and exit insert mode" }) -- Insert mode save and exit to normal mode
-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tn", "<cmd>tabnext<CR>", { desc = "Navigate to next tab" })
keymap.set("n", "<leader>tt", "<cmd>tabnext<CR>", { desc = "Navigate to next tab" })
keymap.set("n", "<leader>tN", "<cmd>tabprevious<CR>", { desc = "Navigate to prev tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close tab" })

keymap.set("n", "X", "<cmd>bd<CR>", { desc = "Close current buffer" }) -- close current buffer
keymap.set("n", "<leader>n", "<cmd>bnext<CR>", { desc = "Go to next buffer" }) --  go to next buffer
keymap.set("n", "<leader>N", "<cmd>bprevious<CR>", { desc = "Go to previous buffer" }) --  go to previous buffer
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

keymap.set(
	"n",
	"h",
	"<cmd>Telescope buffers sort_mru=true sort_lastused=true initial_mode=normal<cr>",
	{ desc = "[P]Open telescope buffers" }
)

vim.keymap.set("v", "<leader>cc", "y<esc>oconsole.log('<C-r>\":', <C-r>\");<esc>", { noremap = true, silent = true })

-- clears all a–z, 0–9 and common special registers, plus search & cmdline
local function clear_all_registers()
	local regs = vim.fn.split('abcdefghijklmnopqrstuvwxyz0123456789*+-/#"=', "\\zs")
	for _, r in ipairs(regs) do
		vim.fn.setreg(r, {})
	end
	-- clear search and command‐line registers
	vim.fn.setreg("/", "")
	print("» All registers cleared")
end

-- bind <leader>cr to that function
vim.keymap.set("n", "<leader>cr", clear_all_registers, { desc = "Clear all registers" })
