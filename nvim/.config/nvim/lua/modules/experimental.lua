return {
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
            -- never_draw_over_target = true,
        },
    },
    {
        -- shortcuts/no-neck-pain.nvim: center the text area in Neovim
        "shortcuts/no-neck-pain.nvim",
        opts = {
            width = 98,
            autocmds = {
                enableOnVimEnter = true,
                enableOnTabEnter = true,
                reloadOnColorSchemeChange = true,
                skipEnteringNoNeckPainBuffer = true,
            },
            mappings = {
                enabled = true,
                toggle = "<leader>un",
            },
        },
    },
}
