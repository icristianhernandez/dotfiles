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
        },
    },
}
