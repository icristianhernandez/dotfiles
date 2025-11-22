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
        name = "catppuccin",
        main = "catppuccin",
        priority = 1000,
        opts = {
            flavour = vim.o.background == "light" and "latte" or "macchiato",
            background = {
                light = "latte",
                dark = "macchiato",
            },
            default_integration = true,
            auto_integrations = true,
            dim_inactive = {
                enabled = false,
                shade = "dark",
                percentage = 0.15,
            },
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd("colorscheme catppuccin")
        end,
    },
}
