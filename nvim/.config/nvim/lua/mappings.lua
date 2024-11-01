--[[
- Cheat sheet for mapmode

╭────────────────────────────────────────────────────────────────────────────╮
│  Str  │  Help page   │  Affected modes                           │  VimL   │
│────────────────────────────────────────────────────────────────────────────│
│  ''   │  mapmode-nvo │  Normal, Visual, Select, Operator-pending │  :map   │
│  'n'  │  mapmode-n   │  Normal                                   │  :nmap  │
│  'v'  │  mapmode-v   │  Visual and Select                        │  :vmap  │
│  's'  │  mapmode-s   │  Select                                   │  :smap  │
│  'x'  │  mapmode-x   │  Visual                                   │  :xmap  │
│  'o'  │  mapmode-o   │  Operator-pending                         │  :omap  │
│  '!'  │  mapmode-ic  │  Insert and Command-line                  │  :map!  │
│  'i'  │  mapmode-i   │  Insert                                   │  :imap  │
│  'l'  │  mapmode-l   │  Insert, Command-line, Lang-Arg           │  :lmap  │
│  'c'  │  mapmode-c   │  Command-line                             │  :cmap  │
│  't'  │  mapmode-t   │  Terminal                                 │  :tmap  │
╰────────────────────────────────────────────────────────────────────────────╯
--]]

local function create_opts(keymap_desc)
    return { noremap = true, silent = true, desc = keymap_desc }
end

-- scroll the screen and keep the cursor in the center
vim.keymap.set({ "n", "v" }, "t", "<C-u>zz", create_opts("Scroll the screen up and keep the cursor in the center"))
vim.keymap.set({ "n", "v" }, "r", "<C-d>zz", create_opts("Scroll the screen down and keep the cursor in the center"))

-- nvim exit mappings
vim.keymap.set("n", "<leader>x", "<cmd>qall<CR>", create_opts("Exit Nvim"))
vim.keymap.set("n", "<leader>X", "<cmd>qall!<CR>", create_opts("Exit Nvim in Group"))

-- save mappings
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", create_opts("Save file"))
vim.keymap.set("n", "<leader>W", "<cmd>conf qa<CR>", create_opts("Save and Exit"))

-- -- close windows
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", create_opts("Close buffer"))
vim.keymap.set("n", "<leader>Q", "<C-w>o<CR>", create_opts("Close all other windows"))
-- vim.keymap.set("n", "<leader>q", function()
--     local actual_tab_windows = vim.api.nvim_tabpage_list_wins(0)
--     local non_empty_windows_count = 0
--
--     for _, win in ipairs(actual_tab_windows) do
--         local buf = vim.api.nvim_win_get_buf(win)
--         local buf_lines = vim.api.nvim_buf_line_count(buf)
--         local is_empty = true
--
--         for i = 1, buf_lines do
--             local line = vim.api.nvim_buf_get_lines(buf, i - 1, i, false)[1]
--
--             if i == 1 then
--                 print("line: ", line)
--                 -- print("line: ", line, "sss")
--             end
--
--             if line ~= "" then
--                 is_empty = false
--                 break
--             end
--         end
--
--         if not is_empty then
--             non_empty_windows_count = non_empty_windows_count + 1
--         end
--     end
--
--     -- print("non_empty_windows_count", non_empty_windows_count)
--
--     -- if non_empty_windows_count > 1 then
--     --     vim.cmd("q")
--     -- end
-- end, create_opts("Close windows"))

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
vim.keymap.set("n", "n", "nzz", create_opts("Move to next find"))
vim.keymap.set("n", "N", "Nzz", create_opts("Move to previous find"))
vim.keymap.set("n", "*", "*zz", create_opts("Move to next find"))
vim.keymap.set("n", "#", "#zz", create_opts("Move to previous find"))
vim.keymap.set("n", "{", "{zz", create_opts("Center the screen"))
vim.keymap.set("n", "}", "}zz", create_opts("Center the screen"))
vim.keymap.set("n", "<C-i>", "<C-i>zz", create_opts("Center the screen"))
vim.keymap.set("n", "<C-o>", "<C-o>zz", create_opts("Center the screen"))

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
-- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", create_opts("Move the visual selection down"))
-- vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", create_opts("Move the visual selection up"))

-- Move between wrapped lines but limited to only normal jk, not change behavior of other mappings
vim.api.nvim_set_keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, noremap = true, silent = true })

-- In insert mode, arrow move with ctrl+hjkl
vim.api.nvim_set_keymap("i", "<C-h>", "<Left>", create_opts("Move left with ctrl+h"))
vim.api.nvim_set_keymap("i", "<C-j>", "<Down>", create_opts("Move down with ctrl+j"))
vim.api.nvim_set_keymap("i", "<C-k>", "<Up>", create_opts("Move up with ctrl+k"))
vim.api.nvim_set_keymap("i", "<C-l>", "<Right>", create_opts("Move right with ctrl+l"))

-- tabs
vim.keymap.set("n", "<Tab>", "<cmd>tabnext<CR>", create_opts("Next tab"))
vim.keymap.set("n", "<S-Tab>", "<cmd>tabprevious<CR>", create_opts("Previous tab"))
vim.keymap.set("n", "<leader><Tab>n", "<cmd>tabnew<CR>", create_opts("New tab"))
vim.keymap.set("n", "<leader><Tab>o", "<cmd>tabonly<CR>", create_opts("Close all other tabs"))
vim.keymap.set("n", "<leader><Tab>q", "<cmd>tabclose<CR>", create_opts("Close tab"))
vim.keymap.set("n", "<leader>1", "1gt", create_opts("Go to tab 1"))
vim.keymap.set("n", "<leader>2", "2gt", create_opts("Go to tab 2"))
vim.keymap.set("n", "<leader>3", "3gt", create_opts("Go to tab 3"))
vim.keymap.set("n", "<leader>4", "4gt", create_opts("Go to tab 4"))
vim.keymap.set("n", "<leader>5", "5gt", create_opts("Go to tab 5"))
vim.keymap.set("n", "<leader>6", "6gt", create_opts("Go to tab 6"))
vim.keymap.set("n", "<leader>7", "7gt", create_opts("Go to tab 7"))
vim.keymap.set("n", "<leader>8", "8gt", create_opts("Go to tab 8"))
vim.keymap.set("n", "<leader>9", "9gt", create_opts("Go to tab 9"))
vim.api.nvim_set_keymap("n", "<leader><Tab>h", ":-tabmove<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader><Tab>l", ":+tabmove<CR>", { noremap = true })
vim.keymap.set("n", "<leader>te", "<cmd>tabedit ", create_opts("Edit tab"))
vim.keymap.set("n", "<leader>tm", "<cmd>tabmove ", create_opts("Move tab"))
-- open a new tab with the current buffer (ctrl+w + t)
vim.keymap.set("n", "<leader><Tab><Tab>", "<C-w>t", create_opts("Open a new tab with the current buffer"))

-- windows resize with arrows
-- vim.keymap.set("n", "<Up>", ":resize +4<CR>", create_opts("Resize window up"))
-- vim.keymap.set("n", "<Down>", ":resize -4<CR>", create_opts("Resize window down"))
-- vim.keymap.set("n", "<Left>", ":vertical resize +4<CR>", create_opts("Resize window left"))
-- vim.keymap.set("n", "<Right>", ":vertical resize -4<CR>", create_opts("Resize window right"))
--
-- change 0 to ^, ^ to 0
vim.keymap.set("n", "0", "^", create_opts("Change 0 to ^"))
vim.keymap.set("n", "^", "0", create_opts("Change ^ to 0"))

-- remap { and } to [ and ]
vim.keymap.set("n", "{", "[", { remap = true, silent = true, desc = "Remap { to [" })
vim.keymap.set("n", "}", "]", { remap = true, silent = true, desc = "Remap } to ]" })

-- try new things:
vim.keymap.set("n", "<leader><leader>", "<C-^>", create_opts("Go to Alternate Buffer"))
