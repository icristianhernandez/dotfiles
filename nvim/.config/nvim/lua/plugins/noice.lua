return {
    "folke/noice.nvim",
    opts = {
        lsp = {
            signature = {
                enabled = false,
            },
        },

        cmdline = {
            format = {
                filter = false,
                lua = false,
                help = false,
            },
        },

        views = {
            cmdline_popup = {
                border = {
                    style = "none",
                    padding = { 1, 2 },
                },
                filter_options = {},
                win_options = {
                    winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
                },
            },
        },
    },
}
