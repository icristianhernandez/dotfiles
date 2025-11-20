-- Colorscheme and appearance management
return {
    -- f-person/auto-dark-mode.nvim: Automatically switch between light and dark mode based on OS theme
    {
        "f-person/auto-dark-mode.nvim",
        lazy = false,
        priority = 1010,

        opts = {
            set_dark_mode = function()
                vim.api.nvim_set_option_value("background", "dark", {})
            end,

            set_light_mode = function()
                vim.api.nvim_set_option_value("background", "light", {})
            end,
        },
    },

    -- catppuccin/nvim: Catppuccin colorscheme with light and dark variants
    {
        "catppuccin/nvim",
        opts = {
            background = { -- :h background
                light = "latte",
                dark = "macchiato",
            },
            -- term_colors = true,
        },
    },

    -- LazyVim/LazyVim: Set default colorscheme
    {
        "LazyVim/LazyVim",

        opts = {
            colorscheme = "catppuccin",
        },
    },
}
