return {
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
}
