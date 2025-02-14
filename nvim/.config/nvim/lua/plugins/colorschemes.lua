return {
    {
        "catppuccin/nvim",
        opts = {
            background = { -- :h background
                light = "latte",
                dark = "macchiato",
            },

            term_colors = true,
        },
    },
    -- { "rose-pine/neovim", as = "rose-pine" },

    {
        "LazyVim/LazyVim",

        opts = {
            colorscheme = "catppuccin",
            -- colorscheme = "rose-pine",
        },
    },
}
