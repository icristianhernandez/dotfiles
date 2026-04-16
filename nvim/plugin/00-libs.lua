vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/MunifTanjim/nui.nvim",
    "https://github.com/nvim-mini/mini.icons",
    "https://github.com/folke/snacks.nvim",
})

-- mini.icons
local MiniIcons = require("mini.icons")
MiniIcons.setup({})
MiniIcons.mock_nvim_web_devicons()

-- Compact, stable diagnostic sign setup using a small mapping.
local signs_text, signs_numhl = {}, {}
local severities = {
    { key = "error", level = vim.diagnostic.severity.ERROR },
    { key = "warning", level = vim.diagnostic.severity.WARN },
    { key = "information", level = vim.diagnostic.severity.INFO },
    { key = "hint", level = vim.diagnostic.severity.HINT },
}

for _, s in ipairs(severities) do
    local icon, hl = MiniIcons.get("lsp", s.key)
    signs_text[s.level] = icon or ""
    signs_numhl[s.level] = hl
end

vim.diagnostic.config({ signs = { text = signs_text, numhl = signs_numhl } })

-- snacks.nvim
local snacks_opts = Pack.get_config("snacks.nvim", {
    scroll = { enabled = true },
    notifier = { enabled = true },
    words = {
        enabled = true,
        debounce = 100,
        modes = { "n", "c" },
    },
    bigfile = {
        enabled = true,
    },
    terminal = {
        win = {
            style = "float",
        },
    },
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
    picker = {
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

local Snacks = require("snacks")
Snacks.setup(snacks_opts)
vim.notify = Snacks.notifier

-- Keys from snacks (merging from all previous modules)
local snacks_keys = {
    { "<leader>gg", function() Snacks.lazygit.open() end, desc = "Open Lazygit" },
    { "<c-space>", function() require("modules.extras.snacks_term").toggle_last() end, desc = "Toggle last snacks terminal", mode = { "n", "t", "i" } },
    { "<leader>tl", function() require("modules.extras.snacks_term").pick() end, desc = "Select snacks terminal" },
    { "<leader>tn", function() require("modules.extras.snacks_term").open(nil, { interactive = true, new = true }) end, desc = "New snacks terminal" },
    { "<C-n>", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<C-n>", function() Snacks.scratch(); vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false) end, mode = "i", desc = "Toggle Scratch Buffer" },
    { "<leader>sn", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files (Root Dir)" },
    { "<leader>fF", function() Snacks.picker.files({ root = false }) end, desc = "Find Files (cwd)" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent opened files" },
    { "<leader>gx", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "x" } },
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (hunks)" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep (Root Dir)" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>sc", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undotree" },
    { "<leader>uc", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    { "<leader>uq", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>us", function() Snacks.toggle.option("spell", { name = "Spelling" }):toggle() end, desc = "Toggle Spelling" },
    { "<leader>uw", function() Snacks.toggle.option("wrap", { name = "Wrap" }):toggle() end, desc = "Toggle Wrap" },
    { "<leader>ul", function() Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):toggle() end, desc = "Toggle Conceal Level" },
    { "<leader>ub", function() Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):toggle() end, desc = "Toggle Dark Background" },
    { "<leader>uh", function() Snacks.toggle.inlay_hints():toggle() end, desc = "Toggle Inlay Hints" },
    { "<leader>ud", function() Snacks.toggle.diagnostics():toggle() end, desc = "Toggle Diagnostics" },
    { "<leader>ut", function() Snacks.toggle.treesitter():toggle() end, desc = "Toggle Treesitter Highlights" },
    { "<leader>us", function() Snacks.toggle.scroll():toggle() end, desc = "Toggle Scrollbar Animation" },
    { "grN", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
}

for _, key in ipairs(snacks_keys) do
    vim.keymap.set(key.mode or "n", key[1], key[2], { desc = key.desc })
end
