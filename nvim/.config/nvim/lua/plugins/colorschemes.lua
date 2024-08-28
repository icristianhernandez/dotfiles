return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false,
        priority = 1001,
        config = function()
            -- vim.cmd("colorscheme rose-pine")
        end,
    },
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
            })

            vim.cmd("colorscheme catppuccin")
        end,
    },
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
    --     end
    -- },
}
