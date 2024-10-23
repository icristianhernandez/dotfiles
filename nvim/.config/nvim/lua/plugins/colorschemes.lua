return {
    {
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
    },
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

                custom_highlights = function(colors)
                    return {
                        NonText = { fg = colors.red },
                    }
                end,
            })

            vim.cmd("colorscheme catppuccin")
        end,
    },
    -- {
    --     -- tokyonight
    --     "folke/tokyonight.nvim",
    --     lazy = false,
    --     priority = 1001,
    --     config = function()
    --         vim.cmd("colorscheme tokyonight")
    --     end,
    -- },
    -- {
    --     "rose-pine/neovim",
    --     name = "rose-pine",
    --     lazy = false,
    --     priority = 1001,
    --     config = function()
    --         vim.cmd("colorscheme rose-pine")
    --     end,
    -- },
    -- {
    --     "olimorris/onedarkpro.nvim",
    --     lazy = false,
    --     priority = 1001,
    --     config = function()
    --         vim.cmd("colorscheme onedark")
    --     end
    -- },
    -- {
    --     "sainnhe/edge",
    --     lazy = false,
    --     priority = 1001,
    --     config = function()
    --         vim.cmd("colorscheme edge")
    --     end,
    -- },
}
