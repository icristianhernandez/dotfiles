local function create_opts(keymap_desc)
    return { noremap = true, silent = true, desc = keymap_desc }
end

-- system clipboard mappings
vim.keymap.set({ "n", "v", "x" }, "<C-c>", '"+y', { noremap = false, silent = true, desc = "Yank to clipboard" })

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x', create_opts("Delete single character without copying into register"))

vim.keymap.set("v", "p", '"_dP', create_opts("Keep last yanked when pasting"))

-- reload the current buffer
vim.keymap.set("n", "<leader>wr", "<cmd>edit!<CR>", create_opts("Reload the current buffer"))

-- Move between windows in insert mode
vim.api.nvim_set_keymap("i", "<C-h>", "<Esc><C-w>h", create_opts("Move to left window with ctrl+h"))
vim.api.nvim_set_keymap("i", "<C-j>", "<Esc><C-w>j", create_opts("Move to window below with ctrl+j"))
vim.api.nvim_set_keymap("i", "<C-k>", "<Esc><C-w>k", create_opts("Move to window above with ctrl+k"))
vim.api.nvim_set_keymap("i", "<C-l>", "<Esc><C-w>l", create_opts("Move to right window with ctrl+l"))

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

-- duplicate selection and comment the initial
-- vim.keymap.set("v", "gy", "ygvgc`>p", { remap = true, desc = "[C]opy to a comment above" })
-- to the above commands, also add that restore the prior yank register
vim.keymap.set("v", "<leader>cy", "ygvgc`>p`[", { remap = true, desc = "[C]opy to a comment above" })
