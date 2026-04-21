vim.pack.add({
    --folke/snacks.nvim: a collection of small QoL plugins
    "https://github.com/folke/snacks.nvim",
})

if vim.g.neovide then
    vim.g.snacks_animate = false
end

require("snacks").setup({
    notifier = {
        enabled = true,
    },

    scroll = {
        enabled = true,
    },

    words = {
        enabled = true,
        debounce = 100,
        modes = { "n", "c" },
    },

    -- bigfile: deal with big files (from editor.lua)
    bigfile = {
        enabled = true,
    },

    -- terminal: floating terminal (from editor.lua)
    terminal = {
        win = {
            style = "float",
        },
    },

    -- scratch: persistent scratch buffers (from editor.lua)
    scratch = {
        win = {
            footer_keys = false,
            on_win = function(self)
                self:set_title("")
            end,
        },
        root = vim.fn.expand("~/dotfiles/notes"),
        ft = function()
            return "markdown"
        end,
    },

    -- picker: file finder, grep, git, etc. (from editor.lua)
    picker = {
        -- styles: "default", "dropdown", "ivy", "ivy_split", "left", "right"
        -- "select", "sidebar", "vertical", "vscode", "telescope", "top", "bottom"
        layout = "sidebar",
        ui_select = true,

        win = {
            input = {
                keys = {
                    ["<Esc>"] = { "close", mode = { "n", "i" } },
                    ["<C-h>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
                    ["<C-bs>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
                    ["<Up>"] = { "select_and_prev", mode = { "i", "n" } },
                    ["<Down>"] = { "select_and_next", mode = { "i", "n" } },
                    ["<Tab>"] = { "list_down", mode = { "i", "n" } },
                    ["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
                },
            },
        },

        sources = {
            files = { hidden = true },
            search = { hidden = true },
            grep = { hidden = true },
            git_diff = {
                win = {
                    input = {
                        keys = {
                            ["<Tab>"] = { "list_down", mode = { "i", "n" } },
                            ["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
                            ["<C-s>"] = { "git_stage", mode = { "n", "i" } },
                            ["<C-r>"] = { "git_restore", mode = { "n", "i" }, nowait = true },
                        },
                    },
                },
            },
            git_status = {
                win = {
                    input = {
                        keys = {
                            ["<Tab>"] = { "list_down", mode = { "i", "n" } },
                            ["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
                            ["<C-s>"] = { "git_stage", mode = { "n", "i" } },
                            ["<C-r>"] = { "git_restore", mode = { "n", "i" }, nowait = true },
                        },
                    },
                },
            },
        },
    },
})

-- Override vim.notify to use snacks notifier (from ui.lua)
vim.notify = require("snacks").notifier

-- ============================================================================
-- KEYMAPS
-- ============================================================================

-- Terminal
vim.keymap.set({ "n", "t", "i" }, "<c-space>", function()
    require("snacks").terminal.toggle()
end, { desc = "Toggle snacks terminal" })

-- Scratch Buffer
vim.keymap.set("n", "<C-n>", function()
    require("snacks").scratch()
end, { desc = "Toggle Scratch Buffer" })

vim.keymap.set("i", "<C-n>", function()
    require("snacks").scratch()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end, { desc = "Toggle Scratch Buffer" })

vim.keymap.set("n", "<leader>sn", function()
    require("snacks").scratch.select()
end, { desc = "Select Scratch Buffer" })

-- Find / Files
vim.keymap.set("n", "<leader>ff", function()
    require("snacks").picker.files()
end, { desc = "Find Files (Root Dir)" })

vim.keymap.set("n", "<leader>fF", function()
    require("snacks").picker.files({ root = false })
end, { desc = "Find Files (cwd)" })

vim.keymap.set("n", "<leader>fr", function()
    require("snacks").picker.recent()
end, { desc = "Recent opened files" })

-- Git
vim.keymap.set("n", "<leader>gg", function()
    require("snacks").lazygit.open()
end, { desc = "Open Lazygit" })

vim.keymap.set("n", "<leader>gb", function()
    require("snacks").picker.git_branches()
end, { desc = "Git Branches" })

-- vim.keymap.set("n", "<leader>gl", function()
--     require("snacks").picker.git_log()
-- end, { desc = "Git Log" })

vim.keymap.set("n", "<leader>gl", function()
    require("snacks").picker.git_log_line()
end, { desc = "Git Log Line" })

vim.keymap.set("n", "<leader>gf", function()
    require("snacks").picker.git_log_file()
end, { desc = "Git Log File" })

vim.keymap.set("n", "<leader>gd", function()
    require("snacks").picker.git_diff()
end, { desc = "Git Diff (hunks)" })

vim.keymap.set("n", "<leader>gs", function()
    require("snacks").picker.git_status()
end, { desc = "Git Status" })

vim.keymap.set("n", "<leader>gS", function()
    require("snacks").picker.git_stash()
end, { desc = "Git Stash" })

-- Git Browse
-- TODO: que e eto?
vim.keymap.set({ "n", "x" }, "<leader>gx", function()
    require("snacks").gitbrowse()
end, { desc = "Git Browse" })

-- Search
vim.keymap.set("n", "<leader>/", function()
    require("snacks").picker.grep()
end, { desc = "Grep (Root Dir)" })

vim.keymap.set({ "n", "x" }, "<leader>sw", function()
    require("snacks").picker.grep_word()
end, { desc = "Visual selection or word" })

vim.keymap.set("n", "<leader>sd", function()
    require("snacks").picker.diagnostics()
end, { desc = "Diagnostics" })

vim.keymap.set("n", "<leader>sD", function()
    require("snacks").picker.diagnostics_buffer()
end, { desc = "Buffer Diagnostics" })

vim.keymap.set("n", "<leader>sk", function()
    require("snacks").picker.keymaps()
end, { desc = "Keymaps" })

vim.keymap.set("n", "<leader>sr", function()
    require("snacks").picker.resume()
end, { desc = "Resume" })

-- vim.keymap.set("n", "<leader>su", function()
--     require("snacks").picker.undo()
-- end, { desc = "Undotree" })

-- UI - Pickers
vim.keymap.set("n", "<leader>uc", function()
    require("snacks").picker.colorschemes()
end, { desc = "Colorschemes" })

vim.keymap.set("n", "<leader>uq", function()
    require("snacks").notifier.hide()
end, { desc = "Dismiss All Notifications" })

vim.keymap.set("n", "<leader>n", function()
    require("snacks").notifier.show_history()
end, { desc = "Notification History" })

-- UI - Toggles
vim.keymap.set("n", "<leader>us", function()
    require("snacks").toggle.option("spell", { name = "Spelling" }):toggle()
end, { desc = "Toggle Spelling" })

vim.keymap.set("n", "<leader>uw", function()
    require("snacks").toggle.option("wrap", { name = "Wrap" }):toggle()
end, { desc = "Toggle Wrap" })

vim.keymap.set("n", "<leader>ul", function()
    require("snacks").toggle
        .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" })
        :toggle()
end, { desc = "Toggle Conceal Level" })

vim.keymap.set("n", "<leader>ub", function()
    require("snacks").toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):toggle()
end, { desc = "Toggle Dark Background" })

vim.keymap.set("n", "<leader>uh", function()
    require("snacks").toggle.inlay_hints():toggle()
end, { desc = "Toggle Inlay Hints" })

vim.keymap.set("n", "<leader>ud", function()
    require("snacks").toggle.diagnostics():toggle()
end, { desc = "Toggle Diagnostics" })

-- Actions
vim.keymap.set("n", "grN", function()
    require("snacks").rename.rename_file()
end, { desc = "Rename File" })

vim.keymap.set({ "n", "t" }, "]]", function()
    require("snacks").words.jump(vim.v.count1)
end, { desc = "Next Reference" })

vim.keymap.set({ "n", "t" }, "[[", function()
    require("snacks").words.jump(-vim.v.count1)
end, { desc = "Prev Reference" })
