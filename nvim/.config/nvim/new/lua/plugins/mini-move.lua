return {
    -- move a text selection between lines
    "echasnovski/mini.move",
    lazy = true,

    keys = {
        { "<S-h", modes = "v" },
        { "<S-l", modes = "v" },
        { "<S-j", modes = "v" },
        { "<S-k", modes = "v" },
    },

    opts = {
        mappings = {
            left = "<S-h>",
            right = "<S-l>",
            down = "<S-j>",
            up = "<S-k>",
        },
    },
}
