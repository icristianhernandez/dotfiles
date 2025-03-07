local function create_opts(keymap_desc)
    return { noremap = true, silent = true, desc = keymap_desc }
end

-- system clipboard mappings
vim.keymap.set({ "n", "v", "x" }, "<C-c>", '"+y', { noremap = false, silent = true, desc = "Yank to clipboard" })
vim.keymap.set({ "n", "v", "x" }, "<C-v>", '"+p', { noremap = false, silent = true, desc = "Paste from clipboard" })

-- system clipboard mappings, insert mode
-- in cmd line, has the problem that insert the clipboard content but not auto
-- render the content
-- update: seems to be fixed in the new neovim version or with noice cmdline
vim.keymap.set({ "i", "c" }, "<C-v>", "<C-r><C-o>+", { noremap = false, silent = true, desc = "Paste from clipboard" })

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x', create_opts("Delete single character without copying into register"))

vim.keymap.set("v", "p", '"_dP', create_opts("Keep last yanked when pasting"))

-- ctrl + a to select all
vim.keymap.set("n", "<C-a>", "ggVG", create_opts("Select all"))

-- reload the current buffer
vim.keymap.set("n", "<leader>wr", "<cmd>edit!<CR>", create_opts("Reload the current buffer"))

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

-- try new things:
vim.keymap.set("n", "<leader><leader>", "<C-^>", create_opts("Go to Alternate Buffer"))

-- select recently pasted, yanked or changed text
vim.keymap.set("n", "gp", "`[v`]", { desc = "Select recently pasted, yanked or changed text" })

-- disable native ctrl+w
vim.keymap.set({ "i", "c" }, "<C-w>", "<Nop>", { noremap = true, silent = true, desc = "Disable native ctrl+w" })

-- ctrl+bs and ctrl+h to delete word in insert mode
-- the array of keys is trying to debug a bug when doing c-bs in snacks.picker
vim.keymap.set({ "i", "l", "o", "s" }, "<C-BS>", "<C-w>", create_opts("Delete word backward"))
vim.keymap.set({ "i", "l", "o", "s" }, "<C-h>", "<C-w>", create_opts("Delete word backward"))

-- ctrl+bs and ctrl+h to delete word in command-line mode with immediate redraw
-- (don't auto redraw with the prior keymaps)
vim.keymap.set("c", "<C-BS>", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>", true, false, true), "n", true)
    -- that redraw probably causes bugs
    vim.cmd("redraw")
end, { noremap = true, silent = true, desc = "Delete word backward" })

vim.keymap.set("c", "<C-h>", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>", true, false, true), "n", true)
    -- that redraw probably causes bugs
    vim.cmd("redraw")
end, { noremap = true, silent = true, desc = "Delete word backward" })
