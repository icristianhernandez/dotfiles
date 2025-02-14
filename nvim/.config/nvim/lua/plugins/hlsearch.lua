return {
    -- remove highlight search after movement outside the search
    "nvimdev/hlsearch.nvim",
    lazy = true,

    keys = {
        { "/" },
        { "?" },
        { "*" },
        { "#" },
        { "g*" },
        { "g#" },
        { "n" },
        { "N" },
        { "gn" },
        { "gN" },
    },

    opts = {},
}
