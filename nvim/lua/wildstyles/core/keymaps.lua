vim.g.mapleader = ","
vim.g.maplocalleader = "."
local keymap = vim.keymap -- for conciseness

vim.opt.clipboard = "" -- disables automatic clipboard sync

-- Yank to system clipboard by default
keymap.set({ "n", "v" }, "y", '"+y', { noremap = true })
keymap.set("n", "p", '"+p', { noremap = true })
keymap.set("n", "P", '"+P', { noremap = true })

keymap.set("n", "<CR>", "<Esc>o<Esc>", { desc = "Insert blank line below" })
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
keymap.set("n", "X", "<cmd>bd<CR>", { desc = "Close current buffer" }) -- close current buffer
keymap.set("n", "<leader>n", "<cmd>bnext<CR>", { desc = "Go to next buffer" }) --  go to next buffer
keymap.set("n", "<leader>N", "<cmd>bprevious<CR>", { desc = "Go to previous buffer" }) --  go to previous buffer
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

keymap.set(
  "n",
  "<S-h>",
  "<cmd>Telescope buffers sort_mru=true sort_lastused=true initial_mode=normal<cr>",
  { desc = "[P]Open telescope buffers" }
)

-- keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Center cursor after moving down half-page" })
-- keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Center cursor after moving up half-page" })

keymap.set("n", "<leader>p", '"_dP', { desc = "Paste without register change" })

vim.keymap.set("v", "<leader>cc", "y<esc>oconsole.log('<C-r>\":', <C-r>\");<esc>", { noremap = true, silent = true })

-- in your init.lua or a plugin file
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    -- make sure <CR> in quickfix just jumps, instead of trying to enter edit
    vim.keymap.set("n", "<CR>", "<CR>", { buffer = true, silent = true })
  end,
})
