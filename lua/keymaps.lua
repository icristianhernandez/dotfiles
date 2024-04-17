local map = vim.keymap.set

-- scroll the screen up and down and top the cursor
map( {"n", "v"} , "t", "<C-u>zt", {desc = "Center cursor after moving up half-page"})
map( {"n", "v"} , "r", "<C-d>zt", {desc = "Center cursor after moving down half-page"})

-- mapping the save and exit
map("n", "<leader>w", "<cmd>w<CR>", { desc = "File Save" })
map("n", "<leader>q", "<cmd>q!<CR>", { desc = "Exit without saving" })
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
  'n', '<Leader>le', ':lua vim.diagnostic.open_float()<CR>',
  { noremap = true, silent = true, desc = "Show diagnostics on current line in floating window" }
)

-- Move focus to the window in the given direction
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

