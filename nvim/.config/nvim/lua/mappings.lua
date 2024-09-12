local function create_opts(keymap_desc)
    return { noremap = true, silent = true, desc = keymap_desc }
end

-- scroll the screen and keep the cursor in the center
vim.keymap.set({ "n", "v" }, "t", "<C-u>zz", create_opts("Scroll the screen up and keep the cursor in the center"))
vim.keymap.set({ "n", "v" }, "r", "<C-d>zz", create_opts("Scroll the screen down and keep the cursor in the center"))

-- mapping the save and exit
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", create_opts("File Save"))
vim.keymap.set("n", "<leader>W", "<cmd>conf qa<CR>", create_opts("File Save and Exit"))
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", create_opts("Exit Nvim"))
vim.keymap.set("n", "<leader>Q", "<cmd>qall!<CR>", create_opts("Exit Nvim in Group"))

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

-- General clear search highlights
vim.keymap.set("n", "<Esc>", ":noh<CR>", create_opts("Clear search highlights"))

-- centered after motion commands
vim.keymap.set("n", "n", "nzzzv", create_opts("Move to next find"))
vim.keymap.set("n", "N", "Nzzzv", create_opts("Move to previous find"))
vim.keymap.set("n", "*", "*zzzv", create_opts("Move to next find"))
vim.keymap.set("n", "#", "#zzzv", create_opts("Move to previous find"))
vim.keymap.set("n", "{", "{zzzv", create_opts("Center the screen"))
vim.keymap.set("n", "}", "}zzzv", create_opts("Center the screen"))
vim.keymap.set("n", "<C-i>", "<C-i>zzzv", create_opts("Center the screen"))
vim.keymap.set("n", "<C-o>", "<C-o>zzzv", create_opts("Center the screen"))

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

-- In insert mode, arrow move with ctrl+hjkl
vim.api.nvim_set_keymap("i", "<C-h>", "<Left>", create_opts("Move left with ctrl+h"))
vim.api.nvim_set_keymap("i", "<C-j>", "<Down>", create_opts("Move down with ctrl+j"))
vim.api.nvim_set_keymap("i", "<C-k>", "<Up>", create_opts("Move up with ctrl+k"))
vim.api.nvim_set_keymap("i", "<C-l>", "<Right>", create_opts("Move right with ctrl+l"))

-- tabs
vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>", create_opts("New tab"))
vim.keymap.set("n", "<leader>to", "<cmd>tabonly<CR>", create_opts("Close all other tabs"))
vim.keymap.set("n", "<leader>tq", "<cmd>tabclose<CR>", create_opts("Close tab"))
-- vim.keymap.set("n", "<leader><Tab>", "<cmd>tabnext<CR>", create_opts("Next tab"))
-- vim.keymap.set("n", "<leader><S-Tab>", "<cmd>tabprevious<CR>", create_opts("Previous tab"))
vim.keymap.set("n", "<Tab>", "<cmd>tabnext<CR>", create_opts("Next tab"))
vim.keymap.set("n", "<S-Tab>", "<cmd>tabprevious<CR>", create_opts("Previous tab"))
vim.keymap.set("n", "<leader>t1", "1gt", create_opts("Go to tab 1"))
vim.keymap.set("n", "<leader>t2", "2gt", create_opts("Go to tab 2"))
vim.keymap.set("n", "<leader>t3", "3gt", create_opts("Go to tab 3"))
vim.keymap.set("n", "<leader>t4", "4gt", create_opts("Go to tab 4"))
vim.keymap.set("n", "<leader>t5", "5gt", create_opts("Go to tab 5"))
vim.keymap.set("n", "<leader>t6", "6gt", create_opts("Go to tab 6"))
vim.keymap.set("n", "<leader>t7", "7gt", create_opts("Go to tab 7"))
vim.keymap.set("n", "<leader>t8", "8gt", create_opts("Go to tab 8"))
vim.keymap.set("n", "<leader>t9", "9gt", create_opts("Go to tab 9"))
-- move current tab to next/previous position
vim.api.nvim_set_keymap("n", "<leader>th", ":+tabmove<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tl", ":-tabmove<CR>", { noremap = true })
-- vim.keymap.set("n", "<leader>te", "<cmd>tabedit ", create_opts("Edit tab"))
-- vim.keymap.set("n", "<leader>tm", "<cmd>tabmove ", create_opts("Move tab"))

-- windows resize with arrows
vim.keymap.set("n", "<Up>", ":resize +4<CR>", create_opts("Resize window up"))
vim.keymap.set("n", "<Down>", ":resize -4<CR>", create_opts("Resize window down"))
vim.keymap.set("n", "<Left>", ":vertical resize +4<CR>", create_opts("Resize window left"))
vim.keymap.set("n", "<Right>", ":vertical resize -4<CR>", create_opts("Resize window right"))
