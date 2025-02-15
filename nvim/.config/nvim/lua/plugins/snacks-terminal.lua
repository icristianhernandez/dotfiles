return {
    "folke/snacks.nvim",

    opts = {
        terminal = {
            win = { style = "float" },
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
