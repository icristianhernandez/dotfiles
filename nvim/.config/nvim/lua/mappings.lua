local function create_opts(keymap_desc)
	return { noremap = true, silent = true, desc = keymap_desc }
end

-- scroll the screen and keep the cursor in the center
vim.keymap.set({ "n", "v" }, "t", "<C-u>zz", create_opts("Scroll the screen up and keep the cursor in the center"))
vim.keymap.set({ "n", "v" }, "r", "<C-d>zz", create_opts("Scroll the screen down and keep the cursor in the center"))

-- remap p to P and P to p
-- vim.keymap.set({ "n", "v" }, "p", "P", create_opts("Paste before the cursor"))
-- vim.keymap.set({ "n", "v" }, "P", "p", create_opts("Paste after the cursor"))

-- system clipboard mappings
vim.keymap.set({ "n", "v", "x" }, '<leader>y', '"+y', create_opts('Yank to clipboard'))
vim.keymap.set({ "n", "v", "x" }, '<leader>Y', '"+yy', create_opts('Yank line to clipboard'))
vim.keymap.set({ "n", "v", "x" }, '<leader>p', '"+p', create_opts('Paste from clipboard'))

-- mapping the save and exit
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", create_opts("File Save"))
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", create_opts("Exit Nvim"))
vim.keymap.set("n", "<leader>Q", "<cmd>wq<CR>", create_opts("File Save and Exit"))

-- centered move to the next find in / or ? search
vim.keymap.set("n", "n", "nzzzv", create_opts("Move to next find"))
vim.keymap.set("n", "N", "Nzzzv", create_opts("Move to previous find"))

-- reload the current buffer
vim.keymap.set("n", "<leader>r", "<cmd>edit!<CR>", create_opts("Reload the current buffer"))

-- Show all diagnostics on current line in floating window
vim.api.nvim_set_keymap(
	"n",
	"<Leader>le",
	":lua vim.diagnostic.open_float()<CR>",
	create_opts("Show diagnostics on current line in floating window")
)

-- Move focus to the window in the given direction
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", create_opts("Move focus to the left window"))
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", create_opts("Move focus to the right window"))
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", create_opts("Move focus to the lower window"))
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", create_opts("Move focus to the upper window"))

-- Move the visual selection up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", create_opts("Move the visual selection down"))
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", create_opts("Move the visual selection up"))

-- Move between wrapped lines but limited to only normal jk, not change behavior of other mappings
vim.api.nvim_set_keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, noremap = true, silent = true })

-- In insert mode, delete the actual word with ctrl+backspace
vim.api.nvim_set_keymap("i", "<C-BS>", "<C-w>", create_opts("Delete the actual word with ctrl+backspace"))

-- Use ñ as ;
vim.api.nvim_set_keymap("n", "ñ", ":", {desc = "Ñ as ;"})
