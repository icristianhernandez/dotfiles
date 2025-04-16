local function create_keymap(modes, key, command, desc, user_opts)
    local default_opts = { noremap = true, silent = true, desc = desc }

    local opts_to_add = vim.tbl_extend("force", default_opts, user_opts or {})

    vim.keymap.set(modes, key, command, opts_to_add)
end

-- system clipboard mappings
create_keymap({ "n", "v", "x" }, "<C-c>", '"+y', "Yank to clipboard")

-- delete single character without copying into register
create_keymap("n", "x", '"_x', "Delete single character without copying into register")

-- keep last yanked when pasting
create_keymap("v", "p", '"_dP', "Keep last yanked when pasting")

-- reload the current buffer
create_keymap("n", "<leader>wr", "<cmd>edit!<CR>", "Reload the current buffer")

-- Move between windows in insert mode
create_keymap("i", "<C-h>", "<Esc><C-w>h", "Move to left window with ctrl+h")
create_keymap("i", "<C-j>", "<Esc><C-w>j", "Move to window below with ctrl+j")
create_keymap("i", "<C-k>", "<Esc><C-w>k", "Move to window above with ctrl+k")
create_keymap("i", "<C-l>", "<Esc><C-w>l", "Move to right window with ctrl+l")

-- change 0 to ^, ^ to 0
create_keymap("n", "0", "^", "Change 0 to ^")
create_keymap("n", "^", "0", "Change ^ to 0")

-- remap { and } to [ and ]
create_keymap("n", "{", "[", "Remap { to [", { remap = true })
create_keymap("n", "}", "]", "Remap } to ]", { remap = true })

-- try new things:
create_keymap("n", "<leader><leader>", "<C-^>", "Go to Alternate Buffer")

-- select recently pasted, yanked or changed text
create_keymap("n", "gp", "`[v`]", "Select recently pasted, yanked or changed text")

-- disable native ctrl+w
create_keymap({ "i", "c" }, "<C-w>", "<Nop>", "Disable native ctrl+w")

-- ctrl+bs and ctrl+h to delete word in insert mode
create_keymap({ "i", "l", "o", "s" }, "<C-BS>", "<C-w>", "Delete word backward")
create_keymap({ "i", "l", "o", "s" }, "<C-h>", "<C-w>", "Delete word backward")

-- ctrl+bs and ctrl+h to delete word in command-line mode with immediate redraw
create_keymap("c", "<C-BS>", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>", true, false, true), "n", true)
    vim.cmd("redraw")
end, "Delete word backward")

create_keymap("c", "<C-h>", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>", true, false, true), "n", true)
    vim.cmd("redraw")
end, "Delete word backward")

-- duplicate selection and comment the initial
create_keymap("v", "<leader>cy", "ygvgc`>p`[", "[C]opy to a comment above", { remap = true })

-- maximize the most possible actual window
create_keymap("n", "<leader>wa", "<C-w>_<C-w>|", "Maximize the most possible actual window")
