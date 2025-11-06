local function create_keymap(modes, key, command, desc, user_opts)
    local default_opts = { noremap = true, silent = true, desc = desc }

    local opts_to_add = vim.tbl_extend("force", default_opts, user_opts or {})

    vim.keymap.set(modes, key, command, opts_to_add)
end

-- save file
create_keymap({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", "Save File")

-- quit
create_keymap("n", "<leader>qq", "<cmd>qa<cr>", "Quit All")

--  basic windows management
--  delete, quit, close all others, split
create_keymap("n", "<leader>wq", "<cmd>q<cr>", "Quit Window")
create_keymap("n", "<leader>wd", "<cmd>bd<cr>", "Delete Buffer")
create_keymap("n", "<leader>wo", "<cmd>only<cr>", "Close Other Windows")
create_keymap("n", "<leader>ws", "<cmd>split<cr>", "Horizontal Split Window")
create_keymap("n", "<leader>wv", "<cmd>vsplit<cr>", "Vertical Split Window")

-- system clipboard mappings
create_keymap({ "n", "v", "x" }, "<C-c>", '"+y', "Yank to clipboard")
create_keymap("n", "<C-v>", '"+gP', "Paste from clipboard and preserve clipboard")
create_keymap("i", "<C-v>", "<C-r>+", "Paste from clipboard")
-- terminal mode clipboard mappings
create_keymap("t", "<C-v>", [[<C-\><C-n>"+p]], "Paste from clipboard in terminal mode")

-- keep last yanked when nvim pasting
create_keymap("v", "p", '"_dP', "Keep last yanked when pasting", { remap = true })

-- reload the current buffer
create_keymap("n", "<leader>wr", "<cmd>edit!<CR>", "Reload the current buffer")

-- better up/down
create_keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", "Down", { expr = true, silent = true })
create_keymap({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", "Down", { expr = true, silent = true })
create_keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", "Up", { expr = true, silent = true })
create_keymap({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", "Up", { expr = true, silent = true })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
create_keymap("n", "n", "'Nn'[v:searchforward].'zv'", "Next Search Result", { expr = true })
create_keymap("x", "n", "'Nn'[v:searchforward]", "Next Search Result", { expr = true })
create_keymap("o", "n", "'Nn'[v:searchforward]", "Next Search Result", { expr = true })
create_keymap("n", "N", "'nN'[v:searchforward].'zv'", "Prev Search Result", { expr = true })
create_keymap("x", "N", "'nN'[v:searchforward]", "Prev Search Result", { expr = true })
create_keymap("o", "N", "'nN'[v:searchforward]", "Prev Search Result", { expr = true })

-- better indenting
create_keymap("v", "<", "<gv")
create_keymap("v", ">", ">gv")

-- Move between windows in insert mode
create_keymap("i", "<C-h>", "<Esc><C-w>h", "Move to left window with ctrl+h")
create_keymap("i", "<C-j>", "<Esc><C-w>j", "Move to window below with ctrl+j")
create_keymap("i", "<C-k>", "<Esc><C-w>k", "Move to window above with ctrl+k")
create_keymap("i", "<C-l>", "<Esc><C-w>l", "Move to right window with ctrl+l")

-- Move between windows in normal mode
create_keymap("n", "<C-h>", "<C-w>h", "Move to left window with ctrl+h")
create_keymap("n", "<C-j>", "<C-w>j", "Move to window below with ctrl+j")
create_keymap("n", "<C-k>", "<C-w>k", "Move to window above with ctrl+k")
create_keymap("n", "<C-l>", "<C-w>l", "Move to right window with ctrl+l")

-- change 0 to ^, ^ to 0
create_keymap("n", "0", "^", "Change 0 to ^")
create_keymap("n", "^", "0", "Change ^ to 0")

-- remap { and } to [ and ]
create_keymap("n", "{", "[", "Remap { to [", { remap = true })
create_keymap("n", "}", "]", "Remap } to ]", { remap = true })

-- go to alternate buffer
create_keymap("n", "<leader><leader>", "<C-^>", "Go to Alternate Buffer")

-- Disable native ctrl+w in insert/cmdline if you are redefining behavior globally
local function cmd_delete_word()
    -- Feed the raw <C-w> key into command-line mode using termcodes and feedkeys
    local keys = vim.api.nvim_replace_termcodes("<C-w>", true, false, true)
    vim.api.nvim_feedkeys(keys, "n", true)
end
create_keymap({ "i", "o", "s", "t", "c" }, "<C-w>", "<Nop>", "Disable native ctrl+w")

-- Shared deletion in insert-like modes (i, l, o, s, t) just reuse built-in <C-w>
create_keymap({ "i", "o", "s", "t" }, "<C-BS>", "<C-w>", "Delete word backward")
create_keymap({ "i", "o", "s", "t" }, "<C-h>", "<C-w>", "Delete word backward")

-- Map <C-BS> to delete word backward with immediate redraw
create_keymap("c", "<C-BS>", cmd_delete_word, "Delete word backward")
create_keymap("c", "<C-h>", cmd_delete_word, "Delete word backward")

-- maximize the most possible actual window
create_keymap("n", "<leader>wa", "<C-w>_<C-w>|", "Maximize the most possible actual window")
-- delete current window
create_keymap("n", "<leader>wd", "<C-w>c", "Delete current window")

-- Search the current visual selection
create_keymap("v", "<leader>/", [[y/\V<C-R>=escape(@",'/\')<CR><CR>]], "Search the current visual selection")

-- send the current buffer to a new tab
create_keymap("n", "<leader><Tab>n", function()
    local prior_tab = vim.api.nvim_get_current_tabpage()
    local prior_win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_get_current_buf()

    vim.cmd("tab split") -- opens same buffer in a new tab
    local new_tab = vim.api.nvim_get_current_tabpage()

    vim.api.nvim_set_current_tabpage(prior_tab)
    if vim.api.nvim_win_is_valid(prior_win) and vim.api.nvim_win_get_buf(prior_win) == buf then
        vim.api.nvim_win_close(prior_win, true)
    end

    vim.api.nvim_set_current_tabpage(new_tab)
end, "Send the current buffer to a new tab and close it in the prior tab")

-- go to an specific numbered tab
for i = 1, 9 do
    create_keymap("n", "<leader><Tab>" .. i, "<cmd>tabn " .. i .. "<CR>", "Go to tab " .. i)
end

-- new tab
create_keymap("n", "<leader><Tab><Tab>", "<cmd>tabnew<CR>", "Open a new tab")
-- close current tab
create_keymap("n", "<leader><Tab>d", "<cmd>tabclose<CR>", "Close current tab")
-- close Other Tabs
create_keymap("n", "<leader><Tab>o", "<cmd>tabonly<CR>", "Close Other Tabs")
