return {
    -- indent-blankline: indent guides
    "lukas-reineke/indent-blankline.nvim",

    opts = {
        indent = {
            char = "▏",
            tab_char = "▏",
            smart_indent_cap = true,
            repeat_linebreak = true,
        },
        scope = {
            enabled = true,
        },
    },
}
