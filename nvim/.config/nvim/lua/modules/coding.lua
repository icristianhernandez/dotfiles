return {
    {
        -- altermo/ultimate-autopair.nvim: smart autopairs for brackets, quotes and spacing
        "altermo/ultimate-autopair.nvim",
        lazy = true,
        event = { "InsertEnter", "CmdlineEnter" },
        opts = { space = { enable = true } },
    },
    {
        -- splitjoin: split or join arguments in/of different lines
        "echasnovski/mini.splitjoin",
        lazy = true,

        keys = {
            { "gs" },
        },

        opts = {
            mappings = {
                toggle = "gs",
            },
        },
    }
}
