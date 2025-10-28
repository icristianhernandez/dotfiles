-- Colorscheme and appearance toggles
return {
    -- f-person/auto-dark-mode.nvim: toggle background option based on system theme
    {
        "f-person/auto-dark-mode.nvim",
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
    -- catppuccin/nvim: theme with integrations and light/dark flavors
    {
        "catppuccin/nvim",
        priority = 1000,
        opts = {
            background = {
                light = "latte",
                dark = "macchiato",
            },
            default_integration = true,

            -- auto_integrations only works with lazy.nvim as package manager
            auto_integrations = true,

            dim_inactive = {
                enabled = false, -- dims the background color of inactive window
                shade = "dark",
                percentage = 0.15, -- percentage of the shade to apply to the inactive window
            },
        },
    },
}
