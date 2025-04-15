return {
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
}
