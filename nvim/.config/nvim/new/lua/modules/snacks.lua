return {
    -- folke/snacks.nvim: small utilities (scratch, terminal, picker, words, quickfile)
    {
        "folke/snacks.nvim",

        ---@module "snacks"
        ---@type snacks.Config
        opts = {
            input = { enabled = true },
            quickfile = { enabled = true },
            bigfile = { enabled = true },
            scroll = { enabled = true },
            notifier = { enabled = true },

            terminal = {
                win = { style = "float" },
            },

            picker = {
                layouts = { vertical = { layout = { min_height = 18 } } },
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
            },

            styles = {
                scratch = {
                    relative = "editor",
                    min_height = 18,
                    height = 0.85,
                    width = 0.85,
                },
            },

            words = { debounce = 100 },
        },

        keys = {
            {
                "<c-space>",
                function()
                    Snacks.terminal()
                end,
                desc = "Terminal (cwd)",
                mode = { "n", "t" },
            },
            {
                "<C-n>",
                function()
                    Snacks.scratch()
                end,
                desc = "Toggle Scratch Buffer",
            },
            {
                "<C-n>",
                function()
                    Snacks.scratch()
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
                end,
                mode = "i",
                desc = "Toggle Scratch Buffer",
            },
            {
                "<leader>sn",
                function()
                    Snacks.scratch.select()
                end,
                desc = "Select Scratch Buffer",
            },
            {
                "<leader>/",
                function()
                    Snacks.picker.grep()
                end,
                desc = "Grep (Root Dir)",
            },
            {
                "<leader>:",
                function()
                    Snacks.picker.command_history()
                end,
                desc = "Command History",
            },
            {
                "<leader>n",
                function()
                    Snacks.picker.notifications()
                end,
                desc = "Notification History",
            },
            -- find
            {
                "<leader>ff",
                function()
                    Snacks.picker.files()
                end,
                desc = "Find Files (Root Dir)",
            },
            {
                "<leader>fF",
                function()
                    Snacks.picker.files({ root = false })
                end,
                desc = "Find Files (cwd)",
            },
            {
                "<leader>fr",
                function()
                    Snacks.picker.recent()
                end,
                desc = "Recent",
            },

            -- git
            {
                "<leader>gd",
                function()
                    Snacks.picker.git_diff()
                end,
                desc = "Git Diff (hunks)",
            },
            {
                "<leader>gs",
                function()
                    Snacks.picker.git_status()
                end,
                desc = "Git Status",
            },
            {
                "<leader>gS",
                function()
                    Snacks.picker.git_stash()
                end,
                desc = "Git Stash",
            },
            -- search
            {
                "<leader>sC",
                function()
                    Snacks.picker.commands()
                end,
                desc = "Commands",
            },
            {
                "<leader>sd",
                function()
                    Snacks.picker.diagnostics()
                end,
                desc = "Diagnostics",
            },
            {
                "<leader>sD",
                function()
                    Snacks.picker.diagnostics_buffer()
                end,
                desc = "Buffer Diagnostics",
            },
            {
                "<leader>sk",
                function()
                    Snacks.picker.keymaps()
                end,
                desc = "Keymaps",
            },
            {
                "<leader>sR",
                function()
                    Snacks.picker.resume()
                end,
                desc = "Resume",
            },
            {
                "<leader>su",
                function()
                    Snacks.picker.undo()
                end,
                desc = "Undotree",
            },
            -- ui
            {
                "<leader>uC",
                function()
                    Snacks.picker.colorschemes()
                end,
                desc = "Colorschemes",
            },
        },
    },
}
