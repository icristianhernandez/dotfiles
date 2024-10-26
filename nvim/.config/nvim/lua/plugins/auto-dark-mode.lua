return {
    -- auto-dark-mode: detect the OS theme and switch between light and dark mode
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    priority = 1010,
    config = function()
        require("auto-dark-mode").setup({
            set_dark_mode = function()
                vim.api.nvim_set_option_value("background", "dark", {})
            end,
            set_light_mode = function()
                vim.api.nvim_set_option_value("background", "light", {})
            end,
        })
    end,
}
