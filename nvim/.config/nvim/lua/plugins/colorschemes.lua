return {
    -- colorschemes
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1001,
        config = function()
            require("catppuccin").setup({
                background = { -- :h background
                    light = "latte",
                    dark = "macchiato",
                },

                term_colors = true,

                -- custom_highlights = function(colors)
                --     return {
                --         NonText = { fg = colors.red },
                --     }
                -- end,
            })

            vim.cmd("colorscheme catppuccin")
        end,
    },
    -- list of colorschemes to try:
    { "sainnhe/sonokai", lazy = false },
    { "sainnhe/everforest", lazy = false },
    { "sainnhe/gruvbox-material", lazy = false },
    { "folke/tokyonight.nvim", lazy = false },
    { "rose-pine/neovim", lazy = false },
    { "olimorris/onedarkpro.nvim", lazy = false },
    { "sainnhe/edge", lazy = false },
}
