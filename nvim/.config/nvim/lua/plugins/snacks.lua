-- Snacks.nvim plugin configurations
-- LSP reference highlighting setup
vim.api.nvim_set_hl(0, "LspReferenceText", { underline = true })
vim.api.nvim_set_hl(0, "LspReferenceRead", { underline = true })
vim.api.nvim_set_hl(0, "LspReferenceWrite", { underline = true })

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    pattern = { "*" },
    callback = function()
        vim.api.nvim_set_hl(0, "LspReferenceText", { underline = true })
        vim.api.nvim_set_hl(0, "LspReferenceRead", { underline = true })
        vim.api.nvim_set_hl(0, "LspReferenceWrite", { underline = true })
    end,
})

return {
    -- folke/snacks.nvim: Picker configuration
    {
        "folke/snacks.nvim",

        ---@module "snacks"
        ---@type snacks.Config
        opts = {
            picker = {
                layouts = {
                    vertical = {
                        layout = {
                            min_height = 18,
                        },
                    },
                },
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
        },
    },

    -- folke/snacks.nvim: Scratch buffer configuration
    {
        "folke/snacks.nvim",

        ---@module "snacks"
        ---@type snacks.Config
        opts = {
            styles = {
                scratch = {
                    relative = "editor",
                    min_height = 18,
                    height = 0.85,
                    width = 0.85,
                },
            },
        },

        keys = {
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
            { "<leader>.", false },
        },
    },

    -- folke/snacks.nvim: Terminal configuration
    {
        "folke/snacks.nvim",

        ---@module "snacks"
        ---@type snacks.Config
        opts = {
            terminal = {
                win = {
                    style = "float",
                },
            },
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
        },
    },

    -- folke/snacks.nvim: Words highlighting configuration
    {
        "folke/snacks.nvim",

        ---@module "snacks"
        ---@type snacks.Config
        opts = { words = { debounce = 100 } },
    },
}
