return {
    {
        -- gisketch/triforce.nvim: Coding gamified experience in nvim
        "gisketch/triforce.nvim",
        dependencies = {
            "nvzone/volt",
        },
        config = function()
            require("triforce").setup({
                keymap = {
                    show_profile = "<leader>tp", -- Open profile with <leader>tp
                },
            })
        end,
    },
    {
        -- tadaa/vimade: animated scrollbars for Neovim
        "tadaa/vimade",
        event = "VeryLazy",
        opts = {
            recipe = { "default", { animate = false } },
            fadelevel = 0.25,
        },
    },
    {
        -- sphamba/smear-cursor.nvim: cursor smear animation for motion feedback
        "sphamba/smear-cursor.nvim",
        event = "VeryLazy",
        cond = vim.g.neovide == nil,
        opts = {
            never_draw_over_target = true,
        },
    },
}
