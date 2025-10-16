return {
    -- noice: UI for messages, cmdline and popupmenu
    "folke/noice.nvim",
    opts = {
        presets = {
            bottom_search = true,
            command_palette = true,
            long_message_to_split = true,
        },

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
                    style = "single",
                    padding = { 0, 2 },
                },
                filter_options = {},
                win_options = {
                    winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
                },
            },
        },
    },
}
