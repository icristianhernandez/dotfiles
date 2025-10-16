return {
    -- Auto-pairing brackets, quotes, etc.
    "altermo/ultimate-autopair.nvim",
    lazy = true,
    event = { "InsertEnter", "CmdlineEnter" },

    opts = {
        space = {
            enable = true,
        },
    },
}
