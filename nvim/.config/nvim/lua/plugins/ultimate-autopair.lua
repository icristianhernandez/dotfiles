return {
    -- Auto-pairing brackets, quotes, etc.
    "altermo/ultimate-autopair.nvim",
    lazy = true,
    event = { "InsertEnter", "CmdlineEnter" },

    opts = {
        space = {
            -- That can be changed in the future bc it's a good option
            enable = false,
        },
    },
}
