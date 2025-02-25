local function create_opts(keymap_desc)
    return { noremap = true, silent = true, desc = keymap_desc }
end

-- system clipboard mappings
vim.keymap.set({ "n", "v", "x" }, "<C-c>", '"+y', { noremap = false, silent = true, desc = "Yank to clipboard" })
vim.keymap.set({ "n", "v", "x" }, "<C-v>", '"+p', { noremap = false, silent = true, desc = "Paste from clipboard" })

-- system clipboard mappings, insert mode
-- in cmd line, has the problem that insert the clipboard content but not auto
-- render the content
vim.keymap.set({ "i", "c" }, "<C-v>", "<C-r><C-o>+", { noremap = false, silent = true, desc = "Paste from clipboard" })

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x', create_opts("Delete single character without copying into register"))

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', create_opts("Keep last yanked when pasting"))

-- ctrl + a to select all
vim.keymap.set("n", "<C-a>", "ggVG", create_opts("Select all"))

-- reload the current buffer
vim.keymap.set("n", "<leader>wr", "<cmd>edit!<CR>", create_opts("Reload the current buffer"))

-- reload the vimrc
vim.keymap.set("n", "<leader>wR", "<cmd>source $MYVIMRC<CR>", create_opts("Reload the vimrc"))

-- -- Terminal leave commands
-- vim.keymap.set("t", "<Esc>", "<C-\\><C-N>", create_opts("Leave terminal mode"))

-- In insert mode, arrow move with ctrl+hjkl
vim.api.nvim_set_keymap("i", "<C-h>", "<Left>", create_opts("Move left with ctrl+h"))
vim.api.nvim_set_keymap("i", "<C-j>", "<Down>", create_opts("Move down with ctrl+j"))
vim.api.nvim_set_keymap("i", "<C-k>", "<Up>", create_opts("Move up with ctrl+k"))
vim.api.nvim_set_keymap("i", "<C-l>", "<Right>", create_opts("Move right with ctrl+l"))

-- change 0 to ^, ^ to 0
vim.keymap.set("n", "0", "^", create_opts("Change 0 to ^"))
vim.keymap.set("n", "^", "0", create_opts("Change ^ to 0"))

-- remap { and } to [ and ]
vim.keymap.set("n", "{", "[", { remap = true, silent = true, desc = "Remap { to [" })
vim.keymap.set("n", "}", "]", { remap = true, silent = true, desc = "Remap } to ]" })

-- ctrl+bs to delete word
vim.keymap.set({ "i" }, "<C-BS>", "<C-w>", create_opts("Delete word backward"))
vim.keymap.set({ "i" }, "<C-h>", "<C-w>", create_opts("Delete word backward"))

-- try new things:
vim.keymap.set("n", "<leader><leader>", "<C-^>", create_opts("Go to Alternate Buffer"))

-- select recently pasted, yanked or changed text
vim.keymap.set("n", "gp", "`[v`]", { desc = "Select recently pasted, yanked or changed text" })
