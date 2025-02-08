return {
    "folke/snacks.nvim",

    ---@type snacks.Config
    opts = {
        words = {
            debounce = 50,
        },

        indent = {
            indent = {
                char = "▏",
            },

            animate = {
                enabled = false,
            },

            scope = {
                char = "▏",
            },

            chunk = {
                enabled = false,
            },
        },
    },
}
