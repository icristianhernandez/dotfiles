local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- scroll the screen up and down and top the cursor
map({ "n", "v" }, "t", "<C-u>zz", { desc = "Center cursor after moving up half-page" })
map({ "n", "v" }, "r", "<C-d>zz", { desc = "Center cursor after moving down half-page" })

-- remap p to P and P to p
map({ "n", "v" }, "p", "P", { desc = "Paste before the cursor" })
map({ "n", "v" }, "P", "p", { desc = "Paste after the cursor" })

-- system clipboard mappings
vim.keymap.set({ "n", "v", "x" }, '<leader>y', '"+y', { noremap = true, silent = true, desc = 'Yank to clipboard' })
vim.keymap.set({ "n", "v", "x" }, '<leader>Y', '"+yy', { noremap = true, silent = true, desc = 'Yank line to clipboard' })
vim.keymap.set({ "n", "v", "x" }, '<leader>p', '"+p', { noremap = true, silent = true, desc = 'Paste from clipboard' })

-- mapping the save and exit
map("n", "<leader>w", "<cmd>w<CR>", { desc = "File Save" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Exit Nvim" })
map("n", "<leader>Q", "<cmd>wq<CR>", { desc = "File Save and Exit" })

-- centered move to the next find in / or ? search
map("n", "n", "nzzzv", { desc = "Move to next find" })
map("n", "N", "Nzzzv", { desc = "Move to previous find" })

-- reload the current buffer
map("n", "<leader>r", "<cmd>edit!<CR>", { desc = "Reload the current buffer" })

-- reload neovim entirely
map("n", "<leader>R", "<cmd>source $MYVIMRC<CR>", { desc = "Reload neovim entirely" })

-- back to the last buffer
map("n", "<BS>", "<cmd>bp<CR>", { desc = "Back to the last buffer" })

-- Show all diagnostics on current line in floating window
vim.api.nvim_set_keymap(
	"n",
	"<Leader>le",
	":lua vim.diagnostic.open_float()<CR>",
	{ noremap = true, silent = true, desc = "Show diagnostics on current line in floating window" }
)

-- Move focus to the window in the given direction
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Move the visual selection up and down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move the visual selection down" }, opts)
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move the visual selection up" }, opts)

-- Move between wrapped lines but limited to only normal jk, not change behavior of 2j or 2k
vim.api.nvim_set_keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, noremap = true, silent = true })

-- In insert mode, delete the actual word with ctrl+backspace
vim.api.nvim_set_keymap("i", "<C-BS>", "<C-w>", { noremap = true, silent = true })
