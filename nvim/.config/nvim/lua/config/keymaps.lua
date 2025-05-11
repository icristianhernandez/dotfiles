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

-- Check if <C-BS> and <C-h> are treated as the same key
local cbs_equals_ch = vim.fn.keytrans("<C-BS>") == vim.fn.keytrans("<C-h>")

local function delete_word_backward()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>", true, false, true), "n", true)
    vim.cmd("redraw")
end

-- Map <C-BS> to delete word backward with immediate redraw
create_keymap("c", "<C-BS>", delete_word_backward, "Delete word backward")

-- Only map <C-h> if it is not the same as <C-BS>
if not cbs_equals_ch then
    create_keymap("c", "<C-h>", delete_word_backward, "Delete word backward")
end

-- duplicate selection and comment the initial
create_keymap("v", "<leader>cy", "ygvgc`>p`[", "[C]opy to a comment above", { remap = true })

-- maximize the most possible actual window
create_keymap("n", "<leader>wa", "<C-w>_<C-w>|", "Maximize the most possible actual window")

-- send the current buffer to a new tab
create_keymap("n", "<leader><Tab>n", function()
    local current_buf_number = vim.fn.bufnr("%")
    local prior_tab_id = vim.api.nvim_get_current_tabpage()

    vim.cmd("tabnew %")
    local new_tab_id = vim.api.nvim_get_current_tabpage()

    vim.api.nvim_set_current_tabpage(prior_tab_id)
    local windows_in_prior_tab = vim.api.nvim_tabpage_list_wins(prior_tab_id)
    for _, win_id in ipairs(windows_in_prior_tab) do
        if vim.api.nvim_win_get_buf(win_id) == current_buf_number then
            vim.api.nvim_win_close(win_id, true) -- Force close the window
            break -- Exit the loop after closing the relevant window
        end
    end

    vim.api.nvim_set_current_tabpage(new_tab_id)
end, "Send the current buffer to a new tab and close it in the prior tab")

-- go to an specific numbered tab
for i = 1, 9 do
    create_keymap("n", "<leader><Tab>" .. i, "<cmd>tabn " .. i .. "<CR>", "Go to tab " .. i)
end
